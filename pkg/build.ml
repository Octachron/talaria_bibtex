#!/usr/bin/env ocaml 
#directory "pkg"
#use "topkg.ml"

let () = 
  Pkg.describe "talaria_bibtex"  ~builder:`OCamlbuild [
		 Pkg.lib "pkg/META";
		 Pkg.lib ~exts:Exts.module_library "src/bibtex";
		 Pkg.lib ~exts:Exts.module_library "src/bibtex_fields";
		 Pkg.lib ~exts:Exts.library "src/bibtex_lib";
		 Pkg.doc "Readme.md"; 
]
