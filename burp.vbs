Option Explicit
Dim WshShell, fso, baseDir, cmd
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
baseDir = fso.GetParentFolderName(WScript.ScriptFullName)
WshShell.CurrentDirectory = baseDir
cmd = """javaw.exe"" --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -Dfile.encoding=utf-8 -javaagent:""loader.jar"" -noverify -jar ""Burp_Suite_Pro.jar"""
WshShell.Run cmd, 0, False
Set WshShell = Nothing
