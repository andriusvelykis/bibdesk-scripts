# BibDesk scripts

Scripts to manipulate BibTeX references using [BibDesk][bibdesk] application.

[bibdesk]: http://bibdesk.sourceforge.net/


## LinkedFilesToFields

Converts BibDesk linked files and URLs (e.g. `Bdsk-File-1` entries) to old-style `Local-Url`
and `Url` (or `Remote-Url`) fields.

The script is useful when Mac file aliases are not preferable in _.bib_ files - it will convert
them to relative paths.


## OrderPublications

Orders the bibliography by _author + year + citekey_.

Useful when the underlying _.bib_ file should have some structure.


## FileOrder

Runs the above scripts one after the other - a convenience solution to avoid multiple clicks.

---

## Author

**Andrius Velykis**

+ http://andrius.velykis.lt
+ http://github.com/andriusvelykis



## Copyright and license

Copyright 2013 Andrius Velykis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this work except in compliance with the License.
You may obtain a copy of the License in the LICENSE file, or at:

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
