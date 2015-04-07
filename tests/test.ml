open Bibtex
let p=Printf.printf
open MicroP
let f=open_in "webtest.bib"


let rec scanp lexb= match MicroL.pages lexb with
	| MicroP.EOF -> p "EOF \n"
	| MicroP.NUM(n) -> p "Num(%d)" n; scanp lexb
	| MicroP.MINUS -> p "<->"; scanp lexb
	| MicroP.WORD(s)-> p "WORD(%s)\n" s; scanp lexb
	| MicroP.COMMA -> p"<,>"
	| MicroP.AND -> p"<and>"
	| MicroP.SEP -> p "</>"; scanp lexb




let bib = parse @@ Lexing.from_channel f
  

let rec scan lexbuf= match Lexer.main lexbuf with
	| EOF -> p "EOF \n"
	| TEXT(s) -> p "text: \"%s\" \n" s ; scan lexbuf
	| LCURL -> p "<" ; scan lexbuf
	| RCURL -> p ">"; scan lexbuf
	| COMMA -> p ":,:"; scan lexbuf
	| KIND s->p "Type \"%s\"" s; scan lexbuf
	| EQUAL -> p "="; scan lexbuf

let mayr entry field f = let open Fields in  match entry.{field} with
| None -> ()
| Some v -> f v  

let ( *? ) = mayr



let mayp field fmt entry= 
entry *? field @@ p fmt 

let decorated op en pr e = print_string op; pr e; print_string en

let decoratedN name= decorated (Printf.sprintf "\t %s: [" name) "]\n"

let plist sep pr l=
	let rec inner l = match l with
	| [] -> ()
	| [a] -> pr a 
	| a::q -> pr a; p sep; inner q   in
	inner l

let plistn name pr = decoratedN name @@ plist ", "  pr

let setN name pr s= s |> Fields.StrSet.elements |>  plistn name pr 

let () =
let open Fields in
  Database.iter (fun id entry ->
	p "Entry : %s \n " id;
	entry *? title @@ decoratedN "Title" print_string;    
	entry *? authors @@ plistn "Authors" (fun {firstname;lastname} -> p "%s %s" firstname lastname);
	entry *? year @@ decoratedN "Year" print_int;
	entry *? journal @@  decoratedN "Journal" print_string;
	entry *? volume @@  decoratedN "Volume" print_int;
	entry *? number @@  decoratedN "Number" print_int;
	entry *? pages @@ (function Loc k -> p "\t Pages: [%d] \n" k | Interv(k,l) -> p "\t Pages: [%d-%d] \n" k l);
	entry *? arxiv @@  decoratedN "Arxiv" print_string;
	entry *? doi @@  plistn "Doi" print_string;
	entry *? tags  @@  setN "Tags"  (p "%s"); 
	entry *? abstract @@  decoratedN "Abstract" print_string;
	
) bib
