-- some options you can change
-- use a file:// URL or a path?
property useFileURL : false
-- use relative or absolute path?
property useRelativePath : true
-- delete linked files/URLs after converting?
property deleteLinkedFiles : false

tell application "BibDesk"
	if (count of documents) = 0 then
		beep
		return
	end if
	
	tell document 1
		set theDocDir to my containerPath(get file of it)
		set thePubs to selection
		repeat with thePub in thePubs
			tell thePub
				
				-- convert linked files
				set theCount to count of (get linked files)
				repeat with i from 1 to theCount
					if useFileURL then
						set thePath to URL of linked file i
					else
						set thePath to POSIX path of (get linked file i)
						if useRelativePath then
							set thePath to my relativePath(thePath, theDocDir)
						end if
					end if
					set theFieldName to "Local-Url"
					if i > 1 then set theFieldName to "Local-Url-" & i
					set the value of field theFieldName to thePath
				end repeat
				
				if deleteLinkedFiles then delete linked files
				
				-- convert linked URLs
				set theCount to count of (get linked URLs)
				repeat with i from 1 to theCount
					set theURL to (get linked URL i)
					set theFieldName to "Url"
					if i > 1 then set theFieldName to "Url-" & i
					set the value of field theFieldName to theURL
				end repeat
				
				if deleteLinkedFiles then delete linked URLs
				
			end tell
		end repeat
	end tell
end tell

on containerPath(theFile)
	tell application "Finder"
		set theContainer to get container of (theFile as alias)
		return POSIX path of (theContainer as alias)
	end tell
end containerPath

on relativePath(fullPath, basePath)
	set theLength to length of basePath
	if (length of fullPath > theLength) and (text 1 thru theLength of fullPath) = basePath then
		return text theLength thru end of fullPath
	else
		return fullPath
	end if
end relativePath
