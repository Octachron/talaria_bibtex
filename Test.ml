open MicroT
open BibtexT
open BibtexP
let p=Printf.printf
let s="@article{Essai,
 title={Quel titre!},
 tags={neant, rien},
 pages={892-893},
 year={2053}
}"

let rec scanp lexb= match MicroL.pages lexb with
	| MicroP.EOF -> p "EOF \n"
	| MicroP.NUM(n) -> p "Num(%d)" n; scanp lexb
	| MicroP.MINUS -> p "<->"; scanp lexb
	| MicroP.WORD(s)-> p "WORD(%s)\n" s; scanp lexb
	| MicroP.COMMA -> p"<,>"
	| MicroP.AND -> p"<and>"





let lexbuf = Lexing.from_string s
let bib = BibtexP.main BibtexL.main lexbuf
  

let rec scan lexbuf= match BibtexL.main lexbuf with
	| EOF -> p "EOF \n"
	| TEXT(s) -> p "text: \"%s\" \n" s ; scan lexbuf
	| LCURL -> p "<" ; scan lexbuf
	| RCURL -> p ">"; scan lexbuf
	| COMMA -> p ":,:"; scan lexbuf
	| KIND s->p "Type \"%s\"" s; scan lexbuf
	| EQUAL -> p "="; scan lexbuf 


let mayp (type r) (module M:Umap.PropertySig with type r=r) f e= try p f @@ M.get e with
| Not_found -> ()

let mayr (type r) entry (module M:Umap.PropertySig with type r=r) f =  try f @@ M.get entry with
| Not_found -> ()  

let ( *? ) = mayr

let () = Database.iter (fun id entry ->
	p "Entry : %s \n " id;
	mayp (module Title) "\t Title : %s \n" entry;    
	mayp (module Year) "\t Year : %d \n" entry;
	entry *? (module Tags)  @@  fun l -> p "\t Tags: ["; List.iter (p "%s,") l ; p "]\n";
	entry *? (module Pages) @@ function Loc k -> p "\t Pages: %d \n" k | Interv(k,l) -> p "\t Pages: %d-%d \n" k l
) bib
