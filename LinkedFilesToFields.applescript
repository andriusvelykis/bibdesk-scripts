-- some options you can change
-- use a file:// URL or a path?
property useFileURL : false
-- use relative or absolute path?
property useRelativePath : true
-- use relative to .bib file without asking the user?
property relativeToBib : true
-- delete Bibdesk-entry for linked files/URLs after converting?
property deleteLinkedFiles : true
-- ignore DOI URLs when converting URLs?
property ignoreDoi : true

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
	
	set theDocument to document 1
	tell theDocument
		
		if relativeToBib then
			set theDocFile to the file of theDocument
			set theDocDir to my containerPath(theDocFile)
		else
			-- Christiaan's solution:
			-- set theDocDir to my containerPath(get file of it)
			-- Tilman's alternative: 
			-- need to get the basedirectory only, but containerPath doesn't work (errors)
			set PathToFile to (choose folder with prompt "Choose folder of .bib-File to edit ...")
			set theDocDir to POSIX path of PathToFile
		end if
		
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
						
						-- if the value has changed, set it (this will change modification date)
						if thePath is not equal to (get value of field theFieldName) then
							set the value of field theFieldName to thePath
						end if
					on error errmesg number errn
						display dialog errmesg & return & return & "error number: " & Â
							(errn as text)
					end try
				end repeat
				
				if deleteLinkedFiles then delete linked files
				
				-- convert linked URLs
				set urlFieldValue to the value of field "Url"
				set allLinkedUrls to (get linked URLs)
				set linkedUrls to {}
				repeat with theURL in my allLinkedUrls
					-- avoid repeating URL field
					set dupUrlField to (theURL as text is equal to urlFieldValue)
					-- ignore DOI entries if selected
					set ignoreAsDoi to (ignoreDoi and ((theURL as text) contains "dx.doi.org"))
					if not dupUrlField and not ignoreAsDoi then
						-- add to list
						set end of linkedUrls to theURL
					end if
				end repeat
				
				set theCount to count of linkedUrls
				repeat with i from 1 to theCount
					set theURL to item i of linkedUrls
					
					if (theCount > 1) and (i > 1) then
						set theFieldName to UrlLinkEntry & UrlLinkEntryMultiDelim & i
					else
						set theFieldName to UrlLinkEntry
					end if
					
					set urlText to theURL as text
					
					-- if the value has changed, set it (this will change modification date)
					if urlText is not equal to (get value of field theFieldName) then
						set the value of field theFieldName to urlText
					end if
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
		if (text end thru end of fullPath) = "/" then -- some entries have a trailing / => need to eliminate
			return "." & text theLength thru ((length of fullPath) - 1) of fullPath -- need of a leading dot
		else
			return "." & text theLength thru end of fullPath -- need of a leading dot
		end if
	else
		return fullPath
	end if
end relativePath
