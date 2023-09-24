@echo off
SETLOCAL EnableDelayedExpansion
::get file
	SET "_-_-FILENAME-_-_=%~f1"
	ECHO [33mFile to load: [30;107m%_-_-FILENAME-_-_%[m
::setup
	ECHO [33mDirective:[m Set up program.
	CALL :SETUP
	ECHO [33mDirective [32mcompleted[0m.
::load file
	ECHO [33mDirective:[m Load file.
	CALL :LOAD
	ECHO [33mDirective [32mcompleted[m.
::main
	ECHO [36mProgram ready:[32m Starting...[m
	CALL :MAIN
	ECHO [31mEnd.[m
EXIT /B

:SETUP (sets up the program)
	ECHO [94mCreating temp dir...[31m
	MKDIR %TMP%/TEXTED/
	::	================  Keybinds  ================	::
	SET INP.YES=y
	::INP.YES: Press to say yes.
	SET INP.NO=n
	::INP.no: Press to say no.
	SET INP.SC_UP=q
	::INP.SC_UP: Scroll up by one line.
	SET INP.SC_DN=a
	::INP.SC_DN: Scroll down by one line.
	SET INP.MV_UP=w
	::INP.MV_UP: Move up by one line. Scrolls up
	::one if at top of screen.
	SET INP.MV_DN=s
	::INP.MV_DN: Move down by one line. Scrolls down
	::one if at bottom of screen.
	SET INP.RP_LN=e
	::INP.RP_LN <new line>: Replaces the current line
	::with <new line>.
	SET INP.RM_LN=d
	::INP.RM_LN: Deletes the current line. You must
	::press INP.YES after to confirm.
	SET INP.IN_AB=r
	::INP.IN_AB: Inserts a line before the current
	::line and moves your cursor there.
	SET INP.IN_BE=f
	::INP.IN_BE: Inserts a line after the current
	::line and moves your cursor there.
	SET INP.QUIT=x
	::INP.QUIT: Press to exit. Slightly easier than
	::vim.
	SET INP.HELP=h
	::INP.HELP: Exits the program. No settings for
	::you!!
	SET INP.SAVE=z
	::INP.SAVE: Saves the file.
	::	================   Window   ================	::
	SET /A WIN.HEIGHT = 20
	::WIN.HEIGHT: How many lines to display (not
	::including UI)
	SET /A WIN.LINE_NOs=1
	::WIN.LINE_NOs: Show line NOs if <=0, don't
	::otherwise.
	EXIT /B

:LOAD
	:LOAD_FILE
		SET /A CURRENT_LINE_NUMBER = 1
		FOR /F "tokens=*" %%Z IN (%_-_-FILENAME-_-_%) DO CALL :LOAD_FILE-SET_LINE "%%Z"
		GOTO LOAD_FILE-END
		:LOAD_FILE-SET_LINE <line contents>
			SET "FILE_%CURRENT_LINE_NUMBER%=%~1"
			::ECHO %CURRENT_LINE_NUMBER%^|%~1
			SET /A CURRENT_LINE_NUMBER += 1
			EXIT /B
		:LOAD_FILE-END
		SET /A Lines_in_file = %CURRENT_LINE_NUMBER% - 1
		ECHO Loaded file of %Lines_in_file% line(s).
		::Clean up
		SET CURRENT_LINE_NUMBER=
	EXIT /B

:MAIN
	SET /A line = 1
	SET /A scroll = 1
	SET /A exit_condition = 0
	CLS
	CALL :MAIN-Loop
	EXIT /B
	:MAIN-LOOP
		SET /A end_of_screen = %scroll% + %WIN.HEIGHT% - 1
		rem IF %end_of_screen% GEQ %Lines_in_file% (
			rem 
		rem )
		ECHO [H[36m========================================[m
		FOR /l %%i in (%scroll%,1,%end_of_screen%) do (CALL :DrawLine %%i)
		ECHO [2K[36mln%line%	================================[m
		ECHO [2K[33m[%INP.SC_UP%]ScrollUp   [%INP.MV_UP%]MoveUp   [%INP.RP_LN%]Replace [%INP.IN_AB%]InsAbove [%INP.SAVE%]Save
		ECHO [2K[%INP.SC_DN%]ScrollDown [%INP.MV_DN%]MoveDown [%INP.RM_LN%]Remove  [%INP.IN_BE%]InsBelow [%INP.HELP%]Help [%INP.QUIT%]Quit
		CHOICE /c:%INP.SC_UP%%INP.SC_DN%%INP.MV_UP%%INP.MV_DN%%INP.RP_LN%%INP.RM_LN%%INP.IN_AB%%INP.IN_BE%%INP.QUIT%%INP.HELP%%INP.SAVE% /N :[m[J 
		SET choice=%ERRORLEVEL%
		IF %choice% == 1 (IF %scroll% GTR 1 (
			IF %end_of_screen% == %line% (SET /A line -= 1)
			SET /A scroll -= 1))
		IF %choice% == 2 (IF %end_of_screen% LSS %Lines_in_file% (
			IF %scroll% == %line% (SET /A line += 1)
			SET /A scroll += 1))
		IF %choice% == 3 (IF %line% GTR 1 (IF %line% == %scroll% (
			SET /A scroll -= 1)&SET /A line -= 1))
		IF %choice% == 4 (IF %line% LSS %Lines_in_file% (IF %line% == %end_of_screen% (
			SET /A scroll += 1)&SET /A line += 1))
		IF %choice% == 5 (SET /P FILE_%line%=[31m%line%:[m )
		IF %choice% == 6 (CALL :DeleteLine %line%)
		IF %choice% == 7 (CALL :InsertLineAbove %line%)
		IF %choice% == 8 (CALL :InsertLineBelow %line%&SET /A line += 1)
		IF %choice% == 9 (SET /A exit_condition = 1)
		IF %choice% == 10 (SET /A exit_condition = 1)
		IF %choice% == 11 (
			ECHO Sorry, I can't figure out how to save :^(
			ECHO Press any key to shame me.&pause>nul )
		IF %exit_condition% NEQ 0 (EXIT /B)
		GOTO MAIN-LOOP

:DrawLine <line_no>
	set /A scr_pos = %0 - %scroll%
	IF %1 LEQ %Lines_in_file% (
		IF %line% == %1 (
			IF %WIN.LINE_NOs% GEQ 0 (
				ECHO [%scr_pos%H[2K[44m%1:[m [34m!FILE_%1![m
			) ELSE (
				ECHO [%scr_pos%H[2K[31m!FILE_%1![m
			)
		) ELSE (
			IF %WIN.LINE_NOs% GEQ 0 (
				ECHO [%scr_pos%H[2K[32m%1:[m !FILE_%1!
			) ELSE (
				ECHO [%scr_pos%H[2K!FILE_%1!
			)
		)
	)
	EXIT /B

:DeleteLine <line_no>
	SET /A line_no = %1
	SET /A new_length = %Lines_in_file% - 2
	:DeleteLine-DelLoop
		SET /A line_no_plus_one = %line_no% + 1
		SET FILE_%line_no%=!FILE_%line_no_plus_one%!
		SET /A line_no = %line_no_plus_one%
		IF %line_no% LSS %new_length% (GOTO :DeleteLine-DelLoop)
	SET /A Lines_in_file = %new_length% + 1
	EXIT /B

:InsertLineAbove <line_no>
	SET /A line_no = %1 - 1
	CALL :InsertLineBelow %line_no%
	EXIT /B

:InsertLineBelow <line_no>
	SET /A line_no = %1
	SET /A new_length = %Lines_in_file% + 1
	SET /A current_line_no = %new_length%
	:InsertAbove-Loop
		SET /A line_no_plus_one = %current_line_no% + 1
		SET FILE_%line_no_plus_one%=!FILE_%current_line_no%!
		SET /A current_line_no -= 1
		IF %current_line_no% GTR %line_no% (GOTO :InsertAbove-Loop)
	SET /A line_no += 1
	SET FILE_%line_no%=
	SET /A Lines_in_file = %new_length%
	EXIT /B