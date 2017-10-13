<img width="388" alt="mountainscene" src="https://user-images.githubusercontent.com/18107425/31568342-acd140ca-b028-11e7-9c3b-b51472117bb7.png">

# KLX

LANGUAGE DESIGN:

	My KLX language has the following conventions:

	-	Comments
		- Everything following // on a single line is considered a comment
		- Everything between /* and */ on a single line is considered a comment
		- Everything between /** and */ is considered a comment and can be multi-line
	-	Commands
		- Command inputs/values are separated by commas
		- Commands are ended with semi-colons
			-	Move x, y; Scale 2, 2; Red Circle; Red;
	-	Variables
		- Variables can be uppercase/lowercase, but only composed of letters
		- Variables must be declared before use with the Variable command
		- Variables	can only be declared at the beginning of the program or
		  at the beginning of a control statement (to reinforce good code practice)
			-	Variable x, y;
			-	x = 0;
	-	Control statements and other statements that may possibly include 
		commands/code...
		- Are in all caps
			-	This is to distinguish functionality provided by the language
			-	IF-THEN, IF-THEN-ELSE, WHILE, FUNC, LOCAL
		- Are enclosed by square brackets [ ] and require explicit closures
			-	This is to make it clear to determine and differentiate scopes
			and what code belongs to what statement
			-	Also provides symmetry with beginning and ending statements
			-	IF (condition) THEN [ code ] ENDIF;
			-	IF (condition) THEN [ code ] ELSE [ code ] ENDIF;
			-	WHILE (condition) [ code ] ENDLOOP;
			-	FUNC Function(params) [ code ] ENDFUNC;
			-	LOCAL [ code ] ENDLOCAL;
		- May be nested
		- Are considered another scope level, or everything within is considered
		  local by default (to eliminate need to remember any state changes made)

