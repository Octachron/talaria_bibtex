
include(MicroT)


exception Unknown_attribute of string*string


module Conv=struct
let ls=Lexing.from_string 

let id s=s
let num s= int_of_string s

end


module type Base= Orec.Repr.Base with type rpr=string
module type PropertySig= Orec.Repr.Sig with type rpr=string
module Property(X:Base):(PropertySig with type p=X.p)  = struct  include( Orec.Repr.Property(X))  end

module Id =Property(struct
	let name="Id"
	type p=string 
	type rpr=string
	let repr=Conv.id
	let specify=Conv.id
end)

module Kind =Property(struct 
	let name="Kind"
	type p=kind
	type rpr=string
	let repr = function
		| Article -> "article"
		| Inproceedings -> "inproceedings"
	let specify= function
		| "article" -> Article
		| "inproceedings" -> Inproceedings
		| s  -> raise @@ Unknown_attribute ("kind",s)  
end)

module Title = Property (struct
	let name="title"
	type p=string
	type rpr=string
	let repr=Conv.id
	let specify=Conv.id
end)

module Authors = Property(struct
	let name="author"
	type p=name list
	type rpr=string
	let repr p= String.concat " and " @@  List.map (fun {firstname; lastname} -> String.concat ", " [firstname;lastname] ) p  
	let specify s = MicroP.names MicroL.names @@ Conv.ls s 
end)

module Year=Property(struct 
	let name="year"
	type p=int
	type rpr=string
	let repr = string_of_int
	let specify = int_of_string 
end)

module Journal=Property(struct
	let name="journal"	
	type p=string 
	type rpr=string
	let repr=Conv.id
	let specify=Conv.id
end)

module Booktitle=Property(struct
	let name="booktitle"	
	type p=string 
	type rpr=string
	let repr=Conv.id
	let specify=Conv.id
end)

module Volume=Property(struct 
	let name="volume"
	type p=int
	type rpr=string
	let repr = string_of_int
	let specify = int_of_string 
end)

module Number=Property(struct 
	let name="number"
	type p=int
	type rpr=string
	let repr = string_of_int
	let specify = int_of_string 
end)

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

module Abstract=Property(struct
	let name="abstract"	
	type p=string 
	type rpr=string
	let repr=Conv.id
	let specify=Conv.id
end)


type entry = Orec.Repr.t
module Database=Map.Make(String)
type data = entry Database.t
