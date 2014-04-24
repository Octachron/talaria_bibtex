%token <string> TEXT
%token <string> KIND
%token LCURL COMMA RCURL EQUAL EOF
%type <Bibtex.data> main
%start main

%{
open Bibtex
open BibtexT
module D=Bibtex.Database
%}

%%

%public main: 
	| ne=entry d=main { let (name,e)= ne in D.add name e d}
	| EOF {D.empty}

entry:
	| kind=KIND LCURL name=TEXT COMMA e=properties RCURL { let e= Kind.Repr.s kind e in (name,Id.set e name) } 

properties:
	| key=TEXT EQUAL LCURL p=rtext RCURL COMMA e=properties { e |> setAttribute key p}  
	| key=TEXT EQUAL LCURL p=rtext RCURL {Rec.empty |> setAttribute key p }

rtext:
	| s=TEXT {s}
	| s=TEXT EQUAL rs=rtext {s^"="^rs}
	| s1=TEXT COMMA rs=rtext  {s1 ^","^ rs }
	| LCURL s1=TEXT RCURL rs=rtext {s1 ^ rs } 
