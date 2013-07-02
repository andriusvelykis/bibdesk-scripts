-- some options you can change
-- use a file:// URL or a path?
property useFileURL : false
-- use relative or absolute path?
property useRelativePath : true
-- delete Bibdesk-entry for linked files/URLs after converting?
property deleteLinkedFiles : true

-- how should the bibtex-entry for file links be called ?
set FileLinkEntry to "Local-Url"
-- if there are multiple files linked, should there be a delimiter between FileLinktEntry and an attached running number ?
set fileLinkEntryMultiDelim to "-"

-- how should the bibtex-entry for urls be called ?
set UrlLinkEntry to "Remote-Url"
-- if there are multiple urls linked, should there be a delimiter between UrlLinktEntry and an attached running number ?
set UrlLinkEntryMultiDelim to "-"


tell application "BibDesk"
	if (count of documents) = 0 then
		beep
		return
	end if
	
	tell document 1
		-- Christiaan's solution:
		-- set theDocDir to my containerPath(get file of it)
		-- Tilman's alternative: 
		-- need to get the basedirectory only, but containerPath doesn't work (errors)
		set PathToFile to (choose folder with prompt "Choose folder of .bib-File to edit ...")
		set theDocDir to POSIX path of PathToFile
		
		repeat with thePub in publications
			tell thePub
				
				-- convert linked files
				set theCount to count of (get linked files)
				repeat with i from 1 to theCount
					try
						if not ((linked file i) exists) then
							display dialog "A linked file is missing." buttons {"OK"} default button 1
						end if
						if useFileURL then
							set thePath to URL of linked file i
						else
							set thePath to POSIX path of (get linked file i)
							if useRelativePath then
								set thePath to my relativePath(thePath, theDocDir)
							end if
						end if
						if (theCount > 1) and (i > 1) then
							set theFieldName to FileLinkEntry & fileLinkEntryMultiDelim & i
						else
							set theFieldName to FileLinkEntry
						end if
						set the value of field theFieldName to thePath
					on error errmesg number errn
						display dialog errmesg & return & return & "error number: " & �
							(errn as text)
					end try
				end repeat
				
				if deleteLinkedFiles then delete linked files
				
				-- convert linked URLs
				set theCount to count of (get linked URLs)
				repeat with i from 1 to theCount
					set theURL to item i of (get linked URLs)
					
					if (theCount > 1) and (i > 1) then
						set theFieldName to UrlLinkEntry & UrlLinkEntryMultiDelim & i
					else
						set theFieldName to UrlLinkEntry
					end if
					-- errors produced by:
					-- set the value of field theFieldName to theURL
					set the value of field theFieldName to theURL as text --that works
				end repeat
				
				if deleteLinkedFiles then delete linked URLs
				
			end tell
		end repeat
	end tell
end tell

on containerPath(theFile)
	tell application "Finder"
		set theContainer to get container of (theFile as file)
		return POSIX path of (theContainer as alias)
	end tell
end containerPath

on relativePath(fullPath, basePath)
	set theLength to length of basePath
	if (length of fullPath > theLength) and (text 1 thru theLength of fullPath) = basePath then
		if (text end thru end of fullPath) = "/" then -- some entries have a trailing / => need to eliminate
			return "." & text theLength thru ((length of fullPath) - 1) of fullPath -- need of a leading dot
		else
			return "." & text theLength thru end of fullPath -- need of a leading dot
		end if
	else
		return fullPath
	end if
end relativePath
