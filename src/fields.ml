include Field_types


exception Unknown_attribute of string*string

module Record = Orec.Namespace.Make()
include(Record)

type 'a named_field =
  { name : string; f : 'a Record.field ; conv: ('a,string) Record.bijection }
let str named_field = Record.( named_field.f @: named_field.conv )
let named_field ~name conv = {name; f=Record.new_field (); conv }
let str_field = let id x = x in named_field Record.{ to_ = id ; from = id }
let int_field = named_field Record.{to_ = string_of_int; from = int_of_string }

module StrSet = Set.Make(String)
module RawMap = Map.Make(String)

let strset_field = named_field Record.{
    to_ =  ( fun x -> x |> StrSet.elements |> String.concat "," ) ;
    from = ( fun x -> x |> Lexing.from_string |>
                      Field_parsers.tags Field_lexers.tags |> StrSet.of_list )
  }

let uid = str_field  ~name:"uid"
let raw : string RawMap.t Record.field = Record.new_field ()

let kind = named_field ~name:"kind" Record.{
             to_ = (function
                | Article -> "article"
                | Inproceedings -> "inproceedings"
                | Talk -> "talk"
                | Book -> "book"
                | Poster -> "poster"
                   );
             from= ( function
                | "article" -> Article
                | "inproceedings" -> Inproceedings
                | "talk" -> Talk
                | "book" -> Book
                | "poster" -> Poster
                | s  -> raise @@ Unknown_attribute ("kind",s)  )
           }

let title = str_field ~name:"title"

let authors =
   named_field ~name:"author"
    Record.{
      to_ =( fun p -> String.concat " and " @@
             List.map (fun {firstname; lastname} ->
                 String.concat ", " [lastname;firstname]
               ) p );
      from = (fun s -> s |> Lexing.from_string |> Field_parsers.names Field_lexers.names )
    }

let year = int_field ~name:"year"
let journal = str_field ~name:"journal"
let booktitle=str_field ~name:"booktitle"

let volume = int_field ~name:"volume"
let number = int_field ~name:"number"
let pages =
  named_field ~name:"pages" Record.{
      to_ = (function Loc n -> string_of_int n | Interv (k,l) ->
          Printf.sprintf "%d-%d" k l);
      from = ( fun s -> s |> Lexing.from_string |>  Field_parsers.pages Field_lexers.pages )
    }

let doi =
  named_field ~name:"doi" Record.{
      to_ = String.concat "/" ;
      from = (fun s ->  s |> Lexing.from_string |> Field_parsers.path Field_lexers.path)
    }

let arxiv = str_field ~name:"arxiv"

let tags = strset_field ~name:"tags"
let src = strset_field ~name:"src"

let state= named_field ~name:"state" Record.{
    to_ = (  function Published -> "published"
                    | Accepted -> "accepted"
                    | Submitted -> "submitted"
                    | WIP -> "wip" );
             from = ( function
                | "published" -> Published
                | "accepted" -> Accepted
                | "submitted"  -> Submitted
                | "wip" -> WIP
                | s -> raise @@ Unknown_attribute ("state",s) )
           }

let abstract = str_field ~name:"abstract"
let location = str_field  ~name:"location"
let conference = str_field  ~name:"conference"

let get_uid entry = match entry.%{uid.f} with None -> assert false | Some x -> x
let get_kind entry = match entry.%{kind.f} with
  | None -> assert false
  | Some x -> x
let get_state entry = match entry.%{state.f} with None -> WIP | Some x -> x

type entry = Record.t
module Database=Map.Make(String)
type data = entry Database.t

type raw_entry = { uid:string; kind:string; raw: string Database.t  }
let default_keys =
  let ( |>> ) database named_field =
    Database.add named_field.name (str named_field) database
  in
  Database.empty
  |>> title
  |>> authors
  |>> journal
  |>> year
  |>> volume
  |>> number
  |>> pages
  |>> doi
  |>> arxiv
  |>> abstract
  |>> state
  |>> tags
  |>> src
  |>> booktitle
  |>> location
  |>> conference

let check_entry keydtb raw_entry =
  let add key value e =
    match Database.find key keydtb with
    | exception Not_found ->  e.%{ raw |= fun m -> Database.add key value m }
    | key -> e.%{ key ^= value }
  in
  let init = create [ str uid ^= raw_entry.uid; str kind ^= raw_entry.kind; raw ^= Database.empty ] in
  Database.fold add raw_entry.raw init

let check ?(with_keys=default_keys) raw =
  Database.map (check_entry with_keys) raw
