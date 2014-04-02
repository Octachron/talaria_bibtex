open Bibtex
let p=Printf.printf
open BibtexP
open MicroP
let f=open_in "test.bib"


let rec scanp lexb= match MicroL.pages lexb with
	| MicroP.EOF -> p "EOF \n"
	| MicroP.NUM(n) -> p "Num(%d)" n; scanp lexb
	| MicroP.MINUS -> p "<->"; scanp lexb
	| MicroP.WORD(s)-> p "WORD(%s)\n" s; scanp lexb
	| MicroP.COMMA -> p"<,>"
	| MicroP.AND -> p"<and>"
	| MicroP.SEP -> p "</>"; scanp lexb




let bib = Bibparse.parse @@ Lexing.from_channel f
  

let rec scan lexbuf= match BibtexL.main lexbuf with
	| EOF -> p "EOF \n"
	| TEXT(s) -> p "text: \"%s\" \n" s ; scan lexbuf
	| LCURL -> p "<" ; scan lexbuf
	| RCURL -> p ">"; scan lexbuf
	| COMMA -> p ":,:"; scan lexbuf
	| KIND s->p "Type \"%s\"" s; scan lexbuf
	| EQUAL -> p "="; scan lexbuf

let mayr (type p) entry (module M:Orec.Repr.Sig with type p=p) f =  try f @@ M.get entry with
| Not_found -> ()  

let ( *? ) = mayr



let mayp (type p) (module M:Orec.Repr.Sig with type p=p) fmt entry= 
entry *? (module M ) @@ p fmt 

let decorated op en pr e = print_string op; pr e; print_string en

let decoratedN name= decorated (Printf.sprintf "\t %s: [" name) "]\n"

let plist sep pr l=
	let rec inner l = match l with
	| [] -> ()
	| [a] -> pr a 
	| a::q -> pr a; p sep; inner q   in
	inner l

let plistn name pr = decoratedN name @@ plist ", "  pr

let () = Database.iter (fun id entry ->
	p "Entry : %s \n " id;
	entry *?  (module Title) @@ decoratedN "Title" print_string;    
	entry *? (module Authors) @@ plistn "Authors" (fun {firstname;lastname} -> p "%s %s" firstname lastname);
	entry *? (module Year) @@ decoratedN "Year" print_int;
	entry *? (module Journal) @@  decoratedN "Journal" print_string;
	entry *? (module Volume) @@  decoratedN "Volume" print_int;
	entry *? (module Number) @@  decoratedN "Number" print_int;
	entry *? (module Pages) @@ (function Loc k -> p "\t Pages: [%d] \n" k | Interv(k,l) -> p "\t Pages: [%d-%d] \n" k l);
	entry *? (module Arxiv) @@  decoratedN "Arxiv" print_string;
	entry *? (module Doi) @@  plistn "Doi" print_string;
	entry *? (module Tags)  @@  plistn "Tags"  (p "%s"); 
	entry *? (module Abstract) @@  decoratedN "Abstract" print_string;
	
) bib
