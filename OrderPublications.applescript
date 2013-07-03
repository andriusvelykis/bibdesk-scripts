-- Sorts publications in the document by the given field.
-- This is useful to achieve the desired order in the saved .bib file.

-- which field to sort publications by?
set SortField to "Cite Key"

tell application "BibDesk"
	if (count of documents) = 0 then
		beep
		return
	end if
	
	set theDocument to document 1
	tell theDocument
		set thePubs to publications
		set thePubs to (sort thePubs by SortField)
		-- cannot just delete, adding new ones is problematic then..
		-- instead, duplicate and remove
		--delete publications
		repeat with thePub in thePubs
			duplicate thePub to end of publications
			remove thePub from publications
		end repeat
	end tell
end tell
