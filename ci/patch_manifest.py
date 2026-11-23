"""Android manifest: internet (Gemini), opening links (YouTube) and
scheduled notifications (reminders, cooking timer)."""
import sys

path = sys.argv[1]
s = open(path, encoding="utf-8").read()

perms = [
    "android.permission.INTERNET",
    "android.permission.POST_NOTIFICATIONS",
    "android.permission.RECEIVE_BOOT_COMPLETED",
    "android.permission.VIBRATE",
    "android.permission.USE_EXACT_ALARM",
    "android.permission.SCHEDULE_EXACT_ALARM",
]
add = "".join(f'    <uses-permission android:name="{p}"/>\n' for p in perms if p not in s)
s = s.replace("<application", add + "    <application", 1)

receivers = """
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
"""
if "ScheduledNotificationReceiver" not in s:
    s = s.replace("</application>", receivers + "    </application>", 1)

intent = ('<intent><action android:name="android.intent.action.VIEW"/>'
          '<data android:scheme="https"/></intent>')
if 'android:scheme="https"' not in s:
    if "<queries>" in s:
        s = s.replace("<queries>", "<queries>\n        " + intent, 1)
    else:
        s = s.replace("</manifest>", "    <queries>" + intent + "</queries>\n</manifest>", 1)
open(path, "w", encoding="utf-8").write(s)
print("manifest patched")
