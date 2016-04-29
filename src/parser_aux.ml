open Bibtex_fields	

let ( |>> ) database named_field =
  Database.add named_field.name (str named_field) database

let keydtb= 
  let dtb=
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
  in ref dtb


exception Unknown_attribute of string

let ( $= )key value =
  try ( Database.find key !keydtb ^= value  )
  with
  |Not_found ->  raw |= fun m -> Database.add key value m

let entry_start=
  create [ raw ^= Database.empty ]
let data= Database.empty
