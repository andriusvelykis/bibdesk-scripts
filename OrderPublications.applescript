-- Sorts publications in the document by author + year + citekey.
-- This is useful to achieve the desired order in the saved .bib file.

-- which field to sort publications by?
--set SortField to "Cite Key"

tell application "BibDesk"
	if (count of documents) = 0 then
		beep
		return
	end if
	
	set theDocument to document 1
	tell theDocument
		set thePubs to publications
		
		-- instead of sorting by a single field, use custom sort key: author + year + citekey (see below)
		--set thePubs to (sort thePubs by SortField)
		
		-- cannot just delete, adding new ones is problematic then..
		-- instead, duplicate and remove
		--delete publications
		
		-- create sort keys for publications
		set sortPubs to {}
		repeat with thePub in thePubs
			
			if (count of author of thePub) > 0 then
				set authorOrEditor to the first author of thePub
			else if (count of editor of thePub) > 0 then
				set authorOrEditor to the first editor of thePub
			end if
			
			if (authorOrEditor is missing value) then
				set authorName to ""
			else
				set authorName to the abbreviated normalized name of the authorOrEditor
			end if
			
			-- remove {} characters that can be in the author names and mess up the order
			if ((offset of "{" in authorName) ³ 0 or (offset of "}" in authorName) ³ 0) then
				set authorName to my replaceChars(my replaceChars(authorName, "}", ""), "{", "")
			end if
			
			set theYear to the value of field "Year" of thePub
			set citeKey to the cite key of thePub
			
			set sortKey to authorName & "-" & theYear & "-" & citeKey
			
			-- create sort key record and add to the list
			set sortRecord to {key:sortKey, value:thePub}
			set the end of sortPubs to sortRecord
		end repeat
		
		
		-- perform sort on the sort keys
		set sortPubs to my bubbleSortKey(sortPubs)
		
		-- get the values from sorted records
		set sortResults to {}
		repeat with thePubRec in sortPubs
			set the end of sortResults to (value of thePubRec)
		end repeat
		
		
		-- move publications to correct positions
		set theCount to count of sortResults
		repeat with i from 1 to theCount
			move item i of sortResults to before publication i
		end repeat
		
	end tell
end tell


on bubbleSortKey(theList)
	-- defining an internal script makes for faster run times!
	script bs
		property alist : theList
	end script
	set theCount to length of bs's alist
	if theCount < 2 then return bs's alist
	repeat with indexA from theCount to 1 by -1
		repeat with indexB from 1 to indexA - 1
			if key of item indexB of bs's alist > key of item (indexB + 1) of bs's alist then
				set temp to item indexB of bs's alist
				set item indexB of bs's alist to item (indexB + 1) of bs's alist
				set item (indexB + 1) of bs's alist to temp
			end if
		end repeat
	end repeat
	return bs's alist
end bubbleSortKey


-- taken from http://www.macosxautomation.com/applescript/sbrt/sbrt-06.html
on replaceChars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replaceChars
