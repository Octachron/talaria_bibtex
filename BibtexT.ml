
open Bibtex
open Umap

exception Unknown_attribute of string*string

module Parse=struct
let ls=Lexing.from_string 

let k = function
| "article" -> Article
| "inproceedings" -> Inproceedings
| s  -> raise @@ Unknown_attribute ("kind",s)  

let id s=s
let num s= int_of_string s
let authors s = MicroP.names MicroL.names @@ ls s 
let pages s = MicroP.pages MicroL.pages @@ ls s 
let state =function
| "published" -> Published
| "accepted" -> Accepted
| "submitted"  -> Submitted
| "wip" -> WIP
| s -> raise @@ Unknown_attribute ("state",s)  

let tags s= MicroP.tags MicroL.tags @@ ls s 
end

let combine (type r) (module M:Umap.PropertySig with type r=r) parser str opr=
	M.s  (parser str) opr
	

let empty=Umap.empty
let process = Database.empty
	|>  Database.add "kind" (combine (module Kind) Parse.k)
	|>  Database.add "title" (combine (module Title) Parse.id)
	|>  Database.add "author" (combine (module Authors) Parse.authors)
	|>  Database.add "journal" (combine (module Journal) Parse.id )
	|>  Database.add "year" (combine (module Year) Parse.num )
	|>  Database.add "volume" (combine (module Volume) Parse.num )
	|>  Database.add "number" (combine (module Number) Parse.num )
	|>  Database.add "pages" (combine (module Pages) Parse.pages )
	|>  Database.add "doi" (combine (module Doi) Parse.id )
	|>  Database.add "arxiv" (combine (module Arxiv) Parse.id )
	|>  Database.add "abstract" (combine (module Abstract) Parse.id )
	|>  Database.add "state" (combine (module State) Parse.state )
	|>  Database.add "tags" (combine (module Tags) Parse.tags )
	|>  Database.add "booktitle" (combine (module Booktitle) Parse.id ) 

exception Unknown_attribute of string

let setAttribute name s e  =
	try (
	let f= Database.find name process in
	f s e )
	with
		|Not_found ->  raise @@ Unknown_attribute name
	 
let data= Database.empty
	
