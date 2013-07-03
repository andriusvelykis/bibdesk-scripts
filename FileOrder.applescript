-- Runs both scripts: orders the publications and updates linked files

my runScript("OrderPublications.applescript")
my runScript("LinkedFilesToFields.applescript")

on runScript(scriptName)
	tell application "Finder"
		set myPath to container of (path to me) as text
	end tell
	
	set loadPath to (myPath & scriptName)
	run script (alias loadPath)
end runScript
