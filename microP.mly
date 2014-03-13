

%token <string> WORD
%token <int> NUM
%token COMMA, MINUS, AND, EOF

%{
open Bibtex
%}

%type <Bibtex.name list> names
%type <string list> tags
%type <Bibtex.pages> pages
%start pages tags names

%%

%public pages:
	| l=NUM EOF{ Loc l }
	| p=WORD l=NUM EOF{Loc l}
	| l=NUM MINUS u=NUM EOF{Interv (l,u)}

%public tags:
	| t=WORD EOF {[t]}
	| t=WORD COMMA ts=tags {t::ts}

%public names:
	| n=name EOF {[n]}
	| n=name AND ns=names {n::ns} 

name:
	| lastname=WORD COMMA firstname=WORD  { {firstname; lastname} }
