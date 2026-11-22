"""Add internet access (Gemini) and link opening (YouTube) to the Android manifest."""
import sys

path = sys.argv[1]
s = open(path, encoding="utf-8").read()
perm = '<uses-permission android:name="android.permission.INTERNET"/>'
if perm not in s:
    s = s.replace("<application", perm + "\n    <application", 1)
intent = ('<intent><action android:name="android.intent.action.VIEW"/>'
          '<data android:scheme="https"/></intent>')
if 'android:scheme="https"' not in s:
    if "<queries>" in s:
        s = s.replace("<queries>", "<queries>\n        " + intent, 1)
    else:
        s = s.replace("</manifest>", "    <queries>" + intent + "</queries>\n</manifest>", 1)
open(path, "w", encoding="utf-8").write(s)
print("manifest patched")
