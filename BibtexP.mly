%token <string> TEXT
%token <string> KIND
%token LCURL COMMA RCURL EQUAL EOF
%{
open BibtexT
let data= Database.empty
%}
%type <BibtexT.data> main
%start main

%%

%public main: 
	| ne=entry d=main { let (name,e)= ne in Database.add name e d}
	| EOF {Database.empty}

entry:
	| kind=KIND LCURL name=TEXT COMMA e=properties RCURL { let e= Kind.s (Parse.k kind) e in (name,e) } 

properties:
	| p=TEXT EQUAL LCURL t=rtext RCURL COMMA e=properties { e |> setAttribute p t }  
	| p=TEXT EQUAL LCURL t=rtext RCURL {empty |> setAttribute p t }

rtext:
	| s=TEXT {s}
	| s1=TEXT COMMA rs=rtext  {s1 ^","^ rs }
	| LCURL s1=TEXT RCURL rs=rtext {s1 ^ rs } 
