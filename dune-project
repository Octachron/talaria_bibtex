(lang dune 2.7)
(using menhir 2.1)

(name talaria-bibtex)
(authors "Florian Angeletti <octa@polychoron.fr>")
(maintainers "Florian Angeletti <octa@polychoron.fr>")
(homepage https://github.com/Octachron/talaria_bibtex)
(bug_reports https://github.com/Octachron/talaria_bibtex/issues)
(source (github Octachron/talaria_bibtex))

 (generate_opam_files true)

(package
  (name talaria-bibtex)
  (version 0.5.0)
  (license GPL-3.0-or-later)
  (synopsis "Alternative ocaml dependency analyzer")
  (depends orec dune (menhir (>= 20180523)) (ocaml (>= 4.08)))
  (description "Talaria-bibtex is a parser for bibtex files. Talaria-bibtex parses bibtex-file into record
   with an extensible sets of known fields to make it easy to handle well-formed bibtex file and
   extract data like the publication year."
)
)
