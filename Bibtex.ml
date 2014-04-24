
include(MicroT)


exception Unknown_attribute of string*string


module Conv=struct
let ls=Lexing.from_string 

let id s=s
let num s= int_of_string s

end

module Rec = Orec.Repr()

module type Base= Rec.Base with type rpr=string
module type PropertySig= Rec.Sig with type rpr=string
module Property(X:Base):(PropertySig with type p=X.p)  = struct  include( Rec.Property(X))  end

module StrProperty( X: sig val name : string end ) =
  struct include (
	Property( struct
		let name = X.name
		type p = string
		type rpr = string
		let repr = Conv.id
		let specify = Conv.id
	end) 
  ) 
end

module IntProperty( X: sig val name : string end ) =
  struct include (
	Property( struct
		let name=X.name
		type p=int
		type rpr=string
		let repr = string_of_int
		let specify = int_of_string 
	end) 
  ) 
end


module Id =StrProperty(struct let name = "Id" end )

module Kind =Property(struct 
	let name="Kind"
	type p=kind
	type rpr=string
	let repr = function
		| Article -> "article"
		| Inproceedings -> "inproceedings"
		| Talk -> "talk"
		| Book -> "book"
		| Poster -> "poster"
	let specify= function
		| "article" -> Article
		| "inproceedings" -> Inproceedings
		| "talk" -> Talk
		| "book" -> Book
		| "poster" -> Poster
		| s  -> raise @@ Unknown_attribute ("kind",s)  
end)

module Title = StrProperty (struct let name="title" end ) 

module Authors = Property(struct
	let name="author"
	type p=name list
	type rpr=string
	let repr p= String.concat " and " @@  List.map (fun {firstname; lastname} -> String.concat ", " [lastname;firstname] ) p  
	let specify s = MicroP.names MicroL.names @@ Conv.ls s 
end)

module Year=IntProperty(struct let name="year" end)

module Journal=StrProperty(struct let name="journal" end )

module Booktitle=StrProperty(struct let name="booktitle" end)

module Volume=IntProperty(struct let name="volume" end)

module Number=IntProperty(struct let name="number" end)

module Pages=Property(struct 
	let name="pages"
	type p=pages
	type rpr=string
	let repr = function Loc n -> string_of_int n | Interv (k,l) -> String.concat "-" @@ List.map string_of_int [k;l] 
	let specify s = MicroP.pages MicroL.pages @@ Conv.ls s 
end)

module Doi=Property(struct 
	let name="doi"
	type p=string list
	type rpr=string
	let repr = String.concat "/" 
	let specify s = MicroP.path MicroL.path @@ Conv.ls s 
end)

module Arxiv=Property(struct 
	let name="arxiv"	
	type p=string 
	type rpr=string
	let repr=Conv.id
	let specify=Conv.id
end)

module Tags=Property(struct
	let name="tags"	
	type p=string list
	type rpr=string
	let repr=String.concat ","
	let specify s=MicroP.tags MicroL.tags @@ Conv.ls s 
end)


module State=Property(struct
	let name="state"
	type p=state
	type rpr=string
	let repr= function Published -> "published" | Accepted -> "accepted" | Submitted -> "submitted" | WIP -> "wip"
	let specify=function
		| "published" -> Published
		| "accepted" -> Accepted
		| "submitted"  -> Submitted
		| "wip" -> WIP
		| s -> raise @@ Unknown_attribute ("state",s)  
end
)

module Abstract=StrProperty(struct let name="abstract" end)

module Location=StrProperty( struct let name = "location" end ) 
module Conference=StrProperty( struct let name = "conference" end)

type entry = Rec.t
module Database=Map.Make(String)
type data = entry Database.t
