-- origin: https://github.com/mushanshitiancai/vscode-paste-image
--
-- MIT License
--
-- Copyright (c) 2016 Mushan Shitiancai
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

property fileTypes : {{«class PNGf», ".png"}}

on run argv
	if argv is {} then
		return "ERROR: missing argument"
	end if

	set imagePath to (item 1 of argv)
	set theType to getType()

	if theType is not missing value then
		try
			set myFile to (open for access imagePath with write permission)
			set eof myFile to 0
			write (the clipboard as (first item of theType)) to myFile
			close access myFile
			return (POSIX path of imagePath)
		on error
			try
				close access myFile
			end try
			return "ERROR: some error occurred"
		end try
	else
		return "ERROR: no image"
	end if
end run

on getType()
	repeat with aType in fileTypes
		repeat with theInfo in (clipboard info)
			if (first item of theInfo) is equal to (first item of aType) then return aType
		end repeat
	end repeat
	return missing value
end getType
