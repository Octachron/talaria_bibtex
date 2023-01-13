%token <string> TEXT
%token <string> KIND
%token LCURL COMMA RCURL EQUAL EOF
%type < Fields.raw_entry Fields.Database.t> main
%start main

%{
  let add raw_entry database = Fields.Database.add raw_entry.Fields.uid raw_entry database
%}

%%

%public main:
	| entry=entry d=main { add entry d}
	| EOF {Fields.Database.empty}

entry:
	| kind=KIND LCURL name=TEXT COMMA e=properties RCURL
	{ {Fields.uid=name; kind; raw=e} }

properties:
	| key=TEXT EQUAL LCURL p=rtext RCURL COMMA e=properties
	  { Fields.Database.add (String.trim key) p e }
	| key=TEXT EQUAL LCURL p=rtext RCURL opt_comma
	  { Fields.Database.singleton (String.trim key) p }

opt_comma:
	| 	{()}
	| COMMA {()}

rtext:
	| s=TEXT {s}
	| s=TEXT EQUAL rs=rtext {s^"="^rs}
	| s1=TEXT COMMA rs=rtext  {s1 ^","^ rs }
	| LCURL s1=TEXT RCURL rs=rtext {s1 ^ rs }
