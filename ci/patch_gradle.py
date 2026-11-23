"""Enable core library desugaring (needed by flutter_local_notifications)."""
import os, re, sys

root = sys.argv[1]
kts = os.path.join(root, "app", "build.gradle.kts")
groovy = os.path.join(root, "app", "build.gradle")
if os.path.exists(kts):
    s = open(kts).read()
    if "isCoreLibraryDesugaringEnabled" not in s:
        s = re.sub(r"compileOptions\s*\{", "compileOptions {\n        isCoreLibraryDesugaringEnabled = true", s, count=1)
    if "desugar_jdk_libs" not in s:
        s += '\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n}\n'
    open(kts, "w").write(s)
    print("patched", kts)
elif os.path.exists(groovy):
    s = open(groovy).read()
    if "coreLibraryDesugaringEnabled" not in s:
        s = re.sub(r"compileOptions\s*\{", "compileOptions {\n        coreLibraryDesugaringEnabled true", s, count=1)
    if "desugar_jdk_libs" not in s:
        s += "\ndependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'\n}\n"
    open(groovy, "w").write(s)
    print("patched", groovy)
else:
    print("no app gradle file found")
