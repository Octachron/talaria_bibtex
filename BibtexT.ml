
open MicroT



module Kind = (val Umap.property (module struct type t=kind end) )
module Title = (val Umap.property (module struct type t=string end) )
module Authors = (val Umap.property (module struct type t=name list end) )
module Year= ( val Umap.property (module struct type t=int end) )
module Journal= (val Umap.property (module struct type t=string end) ) 
module Volume = ( val Umap.property (module struct type t= int end) )
module Number = ( val Umap.property (module struct type t= int end) )
module Pages = (val Umap.property (module struct type t=pages end) )
module Doi = (val Umap.property (module struct type t=string end))
module Arxiv = (val Umap.property (module struct type t=string end) )
module Tags= (val Umap.property (module struct type t=string list end ) )
module State= (val Umap.property (module struct type t=state end) )
module Abstract = (val Umap.property (module struct type t=string end) )


exception Unknown_attribute of string*string

module Parse=struct
let ls=Lexing.from_string 

let k = function
| "article" -> Article
| "inproceeding" -> Inproceedings
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
	
type entry = Umap.t
let empty=Umap.empty
	 
module Database=Map.Make(String)


type data = entry Database.t

let process = Database.empty
	|>  Database.add "kind" (combine (module Kind) Parse.k)
	|>  Database.add "title" (combine (module Title) Parse.id)
	|>  Database.add "authors" (combine (module Authors) Parse.authors)
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


let setAttribute name s e  =
	let f= Database.find name process in
	f s e 

	
