# About
`Editor.bat` is a less functional text editor for windows command prompt

# Running
To run the program:
1) be in the same active directory as Editor.bat
2) type the following in command prompt (`cmd`):
	```bat
	Editor filename
	```

`filename` is the name of the file that will be edited.

# Limitations
As written in [#About](#about) above, this is a less functional text editor meaning there are a few limitations on what it can do.

- This software does not show most `!` or `%` characters.
- This software will not show blank lines.
- This software only replaces a whole line at a time.

# Using the editor
> This information is based on default settings.

Press [`q`] to scroll up a line.  
Press [`a`] to scroll down a line.  
Press [`w`] to move up a line.  
Press [`s`] to move down a line.  
Press [`e`] to replace a line.  
Press [`d`] to remove a line.  
Press [`r`] to insert a blank line above the current line.  
Press [`f`] to insert a blank line below the current line.  
Press [`z`] to open the save file dialogue.  
Press [`h`] to be disappointed.  
Press [`x`] to quit.

# Cool features
You can insert information into the current line.
Here's an example of copying line 2 onto line 1:
> Move cursor to line 1.  
> Press [`e`].  
> Type "`!FILE_2!`".  
> Press enter.

# Configuration
You can configure the editor using the variables below:
- `INP.YES`
- `INP.NO`
- `INP.SC_UP`
- `INP.SC_DN`
- `INP.MV_UP`
- `INP.MV_DN`
- `INP.RP_LN`
- `INP.RM_LN`
- `INP.IN_AB`
- `INP.IN_BE`
- `INP.QUIT`
- `INP.HELP`
- `INP.SAVE`
- `INP.SV_AS`
- `WIN.HEIGHT`
- `WIN.LINE_NOs`

They are all described in the `Editor.bat` file.
