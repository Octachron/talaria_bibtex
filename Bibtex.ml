

type pages = Loc of int | Interv of int*int
type name = {firstname : string; lastname : string}
type kind = Article | Inproceedings
type state = Published | Accepted | Submitted | WIP 


module Kind = (val Umap.property (module struct type t=kind end) )
module Title = (val Umap.property (module struct type t=string end) )
module Authors = (val Umap.property (module struct type t=name list end) )
module Year= ( val Umap.property (module struct type t=int end) )
module Journal= (val Umap.property (module struct type t=string end) ) 
module Booktitle = (val Umap.property (module struct type t=string end) )
module Volume = ( val Umap.property (module struct type t= int end) )
module Number = ( val Umap.property (module struct type t= int end) )
module Pages = (val Umap.property (module struct type t=pages end) )
module Doi = (val Umap.property (module struct type t=string list end))
module Arxiv = (val Umap.property (module struct type t=string end) )
module Tags= (val Umap.property (module struct type t=string list end ) )
module State= (val Umap.property (module struct type t=state end) )
module Abstract = (val Umap.property (module struct type t=string end) )


type entry = Umap.t
module Database=Map.Make(String)
type data = entry Database.t
