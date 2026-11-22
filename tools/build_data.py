# -*- coding: utf-8 -*-
"""Validate the catalogue and write assets/data/*.json for the Flutter app.

Run:  python3 tools/build_data.py
"""
import json
import math
import os
import re
import sys

sys.path.insert(0, os.path.dirname(__file__))
from ingredients import AISLES, ING, STORES  # noqa: E402
from recipes import REC, STYLES  # noqa: E402
from recipes2 import KEEP  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "assets", "data")

VOL = {"tsp": 5.0, "tbsp": 15.0, "cup": 240.0}
UNITS = {"g", "ml", "pc", "tsp", "tbsp", "cup"}
MEALS = {"b", "l", "d"}
APPL = {"oven", "air_fryer", "microwave", "blender", "pressure_cooker"}

errors = []
ing = {i["id"]: i for i in ING}
if len(ing) != len(ING):
    errors.append("duplicate ingredient id")
aisle_ids = {a for a, _ in AISLES}
style_ids = {s for s, _ in STYLES}

for i in ING:
    if i["aisle"] not in aisle_ids:
        errors.append(f"{i['id']}: bad aisle")
    if i["unit"] not in ("g", "ml", "pc"):
        errors.append(f"{i['id']}: bad unit")
    if i["unit"] == "pc" and not i["pcw"]:
        errors.append(f"{i['id']}: pc unit needs pcw")


def to_base(i, q, u):
    """Return (amount in ingredient base unit, grams)."""
    base = i["unit"]
    if u == "pc":
        if base == "pc":
            return q, q * i["pcw"]
        if not i["pcw"]:
            raise ValueError("pc not allowed")
        grams = q * i["pcw"]
        return (grams if base == "g" else grams / i["dens"]), grams
    if u in VOL:
        ml = q * VOL[u]
        if base == "ml":
            return ml, ml * i["dens"]
        if base == "g":
            return ml * i["dens"], ml * i["dens"]
        raise ValueError("volume on pc ingredient")
    if u == "g":
        if base == "g":
            return q, q
        if base == "ml":
            return q / i["dens"], q
        raise ValueError("g on pc ingredient")
    if u == "ml":
        if base == "ml":
            return q, q * i["dens"]
        if base == "g":
            return q * i["dens"], q * i["dens"]
        raise ValueError("ml on pc ingredient")
    raise ValueError("unit")


recipes_out = []
seen = set()
for r in REC:
    rid = r["id"]
    if rid in seen:
        errors.append(f"{rid}: duplicate recipe id")
    seen.add(rid)
    if not set(r["meals"]) <= MEALS or not r["meals"]:
        errors.append(f"{rid}: bad meals")
    if not set(r["styles"]) <= style_ids:
        errors.append(f"{rid}: bad styles {r['styles']}")
    if not set(r["appl"]) <= APPL:
        errors.append(f"{rid}: bad appliances")
    lines = []
    ids = []
    kcal = p = c = f = 0.0
    allergens, tags = set(), set()
    for part in [x.strip() for x in r["ings"].split(";") if x.strip()]:
        bits = part.split()
        if len(bits) != 3:
            errors.append(f"{rid}: bad line '{part}'")
            continue
        iid, q, u = bits[0], float(bits[1]), bits[2]
        if iid not in ing:
            errors.append(f"{rid}: unknown ingredient {iid}")
            continue
        if u not in UNITS:
            errors.append(f"{rid}: bad unit {u}")
            continue
        if iid in ids:
            errors.append(f"{rid}: duplicate ingredient {iid}")
        i = ing[iid]
        try:
            b, g = to_base(i, q, u)
        except ValueError as e:
            errors.append(f"{rid}: {iid} {u}: {e}")
            continue
        ids.append(iid)
        n = i["nutr"]
        kcal += n[0] * g / 100
        p += n[1] * g / 100
        c += n[2] * g / 100
        f += n[3] * g / 100
        allergens |= set(i["allergens"])
        tags |= set(i["tags"])
        lines.append({"i": iid, "q": q, "u": u, "b": round(b, 3)})
    text = " ".join(r["steps"])
    for ref in re.findall(r"\{(\w+)\}", text):
        if ref not in ids:
            errors.append(f"{rid}: step refers to {ref} not in ingredients")
    used = set(re.findall(r"\{(\w+)\}", text))
    for iid in ids:
        if iid not in used:
            errors.append(f"{rid}: ingredient {iid} never used in steps")
    s = r["servings"]
    recipes_out.append({
        "id": rid, "title": r["title"], "emoji": r["emoji"],
        "meals": r["meals"], "styles": r["styles"], "minutes": r["mins"],
        "appliances": r["appl"], "servings": s, "ingredients": lines,
        "steps": r["steps"],
        "nutrition": {"kcal": round(kcal / s), "protein": round(p / s, 1),
                      "carbs": round(c / s, 1), "fat": round(f / s, 1)},
        "allergens": sorted(allergens), "tags": sorted(tags),
        "keeps": rid in KEEP,
    })

for k in KEEP:
    if k not in seen:
        errors.append(f"KEEP has unknown recipe {k}")

if errors:
    print("ERRORS:")
    for e in errors:
        print(" -", e)
    sys.exit(1)

os.makedirs(OUT, exist_ok=True)
catalog = {
    "version": 1,
    "aisles": [{"id": a, "name": n} for a, n in AISLES],
    "stores": [{"id": s, "name": n, "factor": fct} for s, n, fct in STORES],
    "styles": [{"id": s, "name": n} for s, n in STYLES],
    "ingredients": [{
        "id": i["id"], "name": i["name"], "aisle": i["aisle"],
        "unit": i["unit"], "pack": i["pack"], "price": i["price"],
        "pcName": i["pcn"], "pcWeight": i["pcw"], "density": i["dens"],
        "allergens": i["allergens"], "tags": i["tags"], "pantry": i["pantry"],
    } for i in ING],
}
with open(os.path.join(OUT, "catalog.json"), "w", encoding="utf-8") as fh:
    json.dump(catalog, fh, ensure_ascii=False, separators=(",", ":"))
with open(os.path.join(OUT, "recipes.json"), "w", encoding="utf-8") as fh:
    json.dump(recipes_out, fh, ensure_ascii=False, separators=(",", ":"))

# ------------------------------------------------------------ report
def cost(r, factor=1.0, pantry=False):
    t = 0.0
    for ln in r["ingredients"]:
        i = ing[ln["i"]]
        if i["pantry"] and not pantry:
            continue
        t += ln["b"] / i["pack"] * i["price"] * factor
    return t / r["servings"]

print(f"ingredients: {len(ING)}  recipes: {len(recipes_out)}")
by = {m: [x for x in recipes_out if m in x["meals"]] for m in "bld"}
for m, xs in by.items():
    cs = sorted(cost(x) for x in xs)
    print(f"  {m}: {len(xs):2d} recipes  cost/serving SAR min {cs[0]:.1f}  "
          f"median {cs[len(cs)//2]:.1f}  max {cs[-1]:.1f}")
veg = [x for x in recipes_out if not set(x["tags"]) & {"chicken", "beef", "lamb", "fish", "seafood"}]
print(f"  vegetarian: b {sum('b' in x['meals'] for x in veg)} l {sum('l' in x['meals'] for x in veg)} d {sum('d' in x['meals'] for x in veg)}")
print("  top cost:", sorted(((round(cost(x), 1), x["id"]) for x in recipes_out))[-5:])
print("  keeps:", sum(x["keeps"] for x in recipes_out), " l/d keepers:", sum(x["keeps"] and ("l" in x["meals"] or "d" in x["meals"]) for x in recipes_out))
print("  kcal range:", min(x["nutrition"]["kcal"] for x in recipes_out), max(x["nutrition"]["kcal"] for x in recipes_out))
