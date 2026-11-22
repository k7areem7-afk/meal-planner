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
from ingredients import AISLES, EMOJI, ING, STORES  # noqa: E402
from recipes import REC, STYLES  # noqa: E402
from recipes2 import KEEP  # noqa: E402
from recipes_eg import VIBES  # noqa: E402
import recipes_health  # noqa: E402,F401

FIBER = {"red_lentils", "brown_lentils", "chickpeas_can", "chickpeas_dry",
         "kidney_beans", "white_beans", "black_eyed_peas", "fava_can",
         "broad_beans_dry", "bulgur", "freekeh", "oats", "quinoa", "jareesh",
         "wheat", "spinach", "broccoli", "molokhia", "okra", "green_beans",
         "peas_carrots", "cabbage", "cauliflower"}
PROCESSED = {"mayo", "ketchup", "pastrami", "cream", "cheese_triangles",
             "cream_cheese", "halawa", "sambosa_sheets", "breadcrumbs",
             "burger_buns", "noodles"}
OLD_VIBES = {
    "takeout": "shawarma beef_burger crispy_chicken_burger honey_wings tortilla_pizza beef_tacos chicken_burrito quesadilla koshari hawawshi falafel chicken_fajita sweet_sour_chicken egg_fried_rice chicken_noodles meat_sambosa cheese_sambosa butter_chicken shrimp_fried_rice chicken_pane",
    "family": "kabsa_chicken mandi_chicken maqluba saudi_macaroni bechamel_pasta bolognese lasagna_beef chicken_pane kofta_tahini shawarma beef_burger chicken_burrito bukhari_chicken roast_chicken molokhia_chicken peas_stew kousa_mahshi chicken_veg_rice pancakes french_toast",
    "comfort": "jareesh saleeg harees lentil_soup oat_soup marqa_meat marqooq bamia_meat peas_stew green_beans_meat potato_tagine molokhia_chicken bechamel_pasta saloona_chicken mujaddara koshari shakriyeh tomato_soup mushroom_soup kabsa_lamb chicken_vermicelli_soup",
    "one_pan": "shakshuka eggs_tomato eggs_potato soy_chicken egg_fried_rice chicken_liver madhghout red_rice_chicken shrimp_rice coconut_curry keema chili_con_carne mexican_rice chicken_rice_bowl beef_broccoli almond_chicken frittata saudi_macaroni",
}
for _v, _ids in OLD_VIBES.items():
    for _i in _ids.split():
        VIBES.setdefault(_i, set()).add(_v)

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
    oil = sum(ln["b"] for ln in lines if ln["i"] == "veg_oil")
    fried = oil >= 70 or any(w in text for w in ("اقلِ", "اقلها", "اقليه", "اقليها", "اقلي "))
    kc, pr_, cb = kcal / s, p / s, c / s
    meat = tags & {"chicken", "beef", "lamb", "liver"}
    fishy = tags & {"fish", "seafood"}
    diets = []
    if not meat:
        diets.append("pescatarian")
        if not fishy:
            diets.append("vegetarian")
            if not (allergens & {"dairy", "eggs"}) and "honey" not in ids:
                diets.append("vegan")
    if cb <= 15:
        diets.append("keto")
    if pr_ >= (18 if "b" in r["meals"] and len(r["meals"]) == 1 else 25):
        diets.append("high_protein")
    processed = bool(set(ids) & PROCESSED)
    if kc <= 550 and pr_ >= 15 and not fried:
        diets.append("glp1")
    if not fried and not processed and "sugar" not in ids:
        diets.append("anti_inflammatory")
    if "olive_oil" in ids and not fried and not processed and "lamb" not in ids:
        diets.append("mediterranean")
    vibes = set(VIBES.get(rid, set()))
    if r["mins"] <= 25:
        vibes.add("quick")
    if rid in KEEP:
        vibes.add("batch")
    if kc <= 500 and not fried and not processed:
        vibes.add("fresh")
    if len(set(ids) & FIBER) >= 1 and (len(set(ids) & FIBER) >= 2 or any(i in FIBER for i in ids[:2])):
        vibes.add("fiber")
    recipes_out.append({
        "id": rid, "title": r["title"], "emoji": r["emoji"],
        "meals": r["meals"], "styles": r["styles"], "minutes": r["mins"],
        "appliances": r["appl"], "servings": s, "ingredients": lines,
        "steps": r["steps"],
        "nutrition": {"kcal": round(kcal / s), "protein": round(p / s, 1),
                      "carbs": round(c / s, 1), "fat": round(f / s, 1)},
        "allergens": sorted(allergens), "tags": sorted(tags),
        "keeps": rid in KEEP,
        "fried": fried,
        "diets": diets,
        "vibes": sorted(vibes),
    })

for i in ING:
    if i["id"] not in EMOJI:
        errors.append(f"no emoji for {i['id']}")
for k in VIBES:
    if k not in seen:
        errors.append(f"VIBES has unknown recipe {k}")
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
        "emoji": EMOJI.get(i["id"], "🥫"), "nutr": list(i["nutr"]),
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
from collections import Counter
print("  egyptian:", sum("egyptian" in x["styles"] for x in recipes_out), " healthy:", sum("healthy" in x["styles"] for x in recipes_out))
print("  diets:", dict(Counter(d for x in recipes_out for d in x["diets"])))
print("  vibes:", dict(Counter(v for x in recipes_out for v in x["vibes"])))
print("  kcal range:", min(x["nutrition"]["kcal"] for x in recipes_out), max(x["nutrition"]["kcal"] for x in recipes_out))
