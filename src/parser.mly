%token <string> TEXT
%token <string> KIND
%token LCURL COMMA RCURL EQUAL EOF
%type <Bibtex_fields.data> main
%start main

%{
open Parser_aux
open Bibtex_fields
%}

%%

%public main:
	| ne=entry d=main { let (name,e)= ne in Database.add name e d}
	| EOF {Database.empty}

entry:
	| kind_v=KIND LCURL name=TEXT COMMA e=properties RCURL
	{ name, e.%{ str kind ^= kind_v & uid.f ^= name } }

properties:
	| key=TEXT EQUAL LCURL p=rtext RCURL COMMA e=properties { e.%{ key $= p } }
	| key=TEXT EQUAL LCURL p=rtext RCURL opt_comma { entry_start.%{ key $= p } }

opt_comma:
	| 	{()}
	| COMMA {()}

rtext:
	| s=TEXT {s}
	| s=TEXT EQUAL rs=rtext {s^"="^rs}
	| s1=TEXT COMMA rs=rtext  {s1 ^","^ rs }
	| LCURL s1=TEXT RCURL rs=rtext {s1 ^ rs }
