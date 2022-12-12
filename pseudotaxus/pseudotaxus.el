;;; pseudotaxus.el --- a major mode for editing Pseudotaxus files

;; Copyright (C) 2022 Christopher Rodriguez

;; Author: Christopher Rodriguez <yewscion@gmail.com>
;; Keywords: pseudocode pseudotaxus
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a major mode for editing pseudocode files adhering to the
;; Pseudotaxus standard.

;;; Code:

(defvar cdr:pseudotaxus-function-name-regexp
      "\\[.*\\S .*\\]")
(defvar cdr:pseudotaxus-variable-name-regexp
      "\\([[:upper:]]\\w*\\)\\([[:punct:]]\\|[[:space:]]\\|$\\)")
(defvar cdr:pseudotaxus-preprocessor-regexp
      "`.+`")
(defvar cdr:pseudotaxus-constants-regexp
  (regexp-opt
   '("true" "false" "nonexistant" "unbound" "missing" "null" "success" "failure"
"succeeds" "fails" "found" "newline" "beep" "indent" "user" "screen" "system"
"datum" "data" "caclulation" "calculations" "action" "actions")
   'symbols))
(defvar cdr:pseudotaxus-types-regexp
  (regexp-opt
   '("number" "word" "phrase" "item" "identifier" "truthy" "falsey" "sequence"
"every" "each" "member" "index" "nothing" "maybe" "symbol" "many" "any"
"object" "constant" "operator" "procedure" "argument" "parameter" "file"
"stream" "pipe" "port" "line" "interrupt" "value" "name" "result" "message"
"field" "an" "a" "the" "integer" "character" "boolean" "floating-point"
"fixed-point" "pointer" "reference" "enum" "enumeration" "structure" "array"
"record" "tuple" "string" "union" "variant" "coproduct" "t-union" "sum-type"
"product-type" "list" "set" "suite" "stack" "queue" "tree" "graph" "heap"
"grid" "hash-map" "priority-queue" "binary-tree" "quad-tree" "cons-list"
"doubly-linked-list" "k-d-tree" "skip-list" "linked-list" "matrix"
"lookup-table" "bit-array" "variable-length-array" "dynamic-array"
"gap-buffer" "zipper" "b-tree" "binary-search-tree" "b-plus-tree"
"binary-heap" "binomial-heap" "radix-tree" "suffix-tree" "ternary-tree"
"m-ary-tree" "k-ary-tree" "and-or-tree" "spqr-tree" "in-tree" "segment-tree"
"range-tree" "bin" "finger-tree" "bloom-filter" "count-min-sketch"
"adjacency-list" "adjacency-matrix" "decision-tree" "directed-graph"
"undirected-graph" "forest" "link-cut-tree" "dynamic-tree" "array-list"
"a-list" "numbers" "words" "phrases" "items" "identifiers" "sequences"
"members" "indices" "nothings" "maybes" "symbols" "objects" "constants"
"operators" "procedures" "arguments" "parameters" "files" "streams" "pipes"
"ports" "lines" "interrupts" "values" "names" "results" "messages" "fields"
"integers" "characters" "booleans" "floating-points" "fixed-points"
"pointers" "references" "enums" "enumerations" "structures" "arrays"
"records" "tuples" "strings" "unions" "variants" "coproducts" "t-unions"
"sum-types" "product-types" "lists" "sets" "suites" "stacks" "queues" "trees"
"graphs" "heaps" "grids" "hash-maps" "priority-queues" "binary-trees"
"quad-trees" "cons-lists" "doubly-linked-lists" "k-d-trees" "skip-lists"
"linked-lists" "matrices" "lookup-tables" "bit-arrays"
"variable-length-arrays" "dynamic-arrays" "gap-buffers" "zippers" "b-trees"
"binary-search-trees" "b-plus-trees" "binary-heaps" "binomial-heaps"
"radix-trees" "suffix-trees" "ternary-trees" "m-ary-trees" "k-ary-trees"
"and-or-trees" "spqr-trees" "in-trees" "segment-trees" "range-trees" "bins"
"finger-trees" "bloom-filters" "count-min-sketches" "adjacency-lists"
"adjacency-matrices" "decision-trees" "directed-graphs" "undirected-graphs"
"forests" "link-cut-trees" "dynamic-trees" "array-lists" "a-lists"
"numberish" "numbery" "stringish" "stringy" "characterish" "charactery"
"booleanish" "booleany" "listish" "listy" "arrayish" "array-y" "sequenceish"
"sequencey" "memberish" "membery" "indexish" "indexy" "nothingish" "nothingy"
"maybeish" "maybe-y" "symbolish" "symboly" "objectish" "objecty"
"constantish" "constanty" "operatorish" "operatory" "procedureish"
"procedurey" "argumentish" "argumenty" "parameterish" "parametery" "fileish"
"filey" "streamish" "streamy" "pipeish" "pipey" "portish" "porty" "lineish"
"liney" "interruptish" "interrupty")
   'symbols))
(defvar cdr:pseudotaxus-operators-regexp
  (regexp-opt
   '(">" "<" "==" "!=" "<>" "<=" ">=" "=" "!<" "!>" "≡" "≯" "≮" "≥" "≤" "≠" "^"
"*" "+" "-" "/" "%" "×" "÷" "¬" "⊻" "∨" "∧" "⍱" "⍲" "<-" "->" "<" "less than"
"more than" "greater than" "equals" "equal to" "different than" "different
from" "plus" "minus" "times" "divided by" "modulo" "squared" "cubed" "root"
"square" "cube" "not" "xor" "and" "or" "nand" "nor" "resulting in" "fed to"
"right" "left" "leads to" "results in" "raise" "lower" "share" "is equivalent
to" "taken from" "stored in")
                  'symbols))
(defvar cdr:pseudotaxus-keywords-regexp
      (regexp-opt
       '("read" "obtain" "get" "from" "use" "copy" "expect" "print" "display" "show"
"save" "return" "compute" "execute" "calculate" "determine" "append" "to"
"over" "set" "initialize" "init" "let" "is" "has" "contains" "be" "increment"
"bump" "decrement" "if" "then" "else" "otherwise" "when" "unless" "while"
"done" "endwhile" "do" "case" "of" "others" "endcase" "repeat" "until" "for"
"endfor" "call" "calling" "exception" "as" "recurse" "on" "this" "that"
"except" "in" "at" "with" "without" "aside" "convert" "cast" "ensure"
"expecting" "begin" "end" "rhizome" "," ":" "where" "containing" "either")
       'symbols))
(defvar cdr:pseudotaxus-algorithms-regexp
      (regexp-opt
       '("sum" "difference" "product" "quotient" "remainder" "modulus" "sign"
"reciprocal" "magnitude" "logarithm" "average" "mean" "median" "mode" "range"
"max" "maximum" "min" "minimum" "maxima" "minima" "ceiling" "floor" "sort"
"reverse" "search" "find" "filter in" "filter out" "grade up" "grade down"
"scan" "map" "reduce" "expand" "replicate" "depth" "match" "tally" "enlist"
"membership" "pick" "drop" "take" "iota")
       'symbols))
(defvar cdr:pseudotaxus-string-regexp
      "\\('.*'\\|\\\".*\\\"\\)")
(defvar cdr:pseudotaxus-special-types-regexp
      (regexp-opt '("truthy" "falsey") 'symbols))
(defvar cdr:pseudotaxus-special-operator-regexp
      "!=\\|!<\\|!>\\|\\^\\|\\*\\|take the remainder of\\|raised to\\|resulting in")
(defvar cdr:pseudotaxus-numeric-ordinals-regexp
      (concat
       "first\\|second\\|third\\|fourth\\|fifth\\|sixth\\|seventh\\|eighth\\|"
       "ninth\\|tenth\\|eleventh\\|twelfth\\|thirteenth\\|fourteenth\\|"
       "fifteenth\\|sixteenth\\|seventeenth\\|eighteenth\\|nineteenth\\|"
       "twentieth\\|thirtieth\\|fortieth\\|fiftieth\\|sixtieth\\|"
       "seventieth\\|eightieth\\|nintieth\\|hundreth\\|thousandth\\|"
       "millionth\\|billionth\\|trillionth\\|quadrillionth\\|"
       "quintillionth\\|sextillionth\\|septillionth\\|octillionth\\|"
       "nonillionth\\|decillionth\\|undecillionth\\|duodecillionth"))
(defvar cdr:pseudotaxus-numeric-words-regexp
      (concat
       "one\\|two\\|three\\|four\\|five\\|six\\|seven\\|eight\\|nine\\|ten\\|eleven\\|"
       "twelve\\|thirteen\\|fourteen\\|fifteen\\|sixteen\\|seventeen\\|"
       "eighteen\\|ninteen\\|twenty\\|thirty\\|forty\\|fifty\\|sixty\\|seventy\\|"
       "eighty\\|ninety\\|hundred\\|thousand\\|million\\|billion\\|trillion\\|"
       "quadrillion\\|quintillion\\|sextillion\\|septillion\\|octillion\\|"
       "nonillion\\|decillion\\|undecillion\\|duodecillion\\|googol\\|centillion"))
(define-generic-mode
    'pseudotaxus-mode
                                        ; Comments
  '(";" "#" "//" ("/*" . "*/"))
                                        ; Keywords
  '()
  `((,cdr:pseudotaxus-string-regexp . 'font-lock-string-face)
    (,cdr:pseudotaxus-function-name-regexp . 'font-lock-function-name-face)
    (,cdr:pseudotaxus-variable-name-regexp . 'font-lock-variable-name-face)
    (,cdr:pseudotaxus-preprocessor-regexp . 'font-lock-preprocessor-face)
    (,cdr:pseudotaxus-special-types-regexp . 'font-lock-type-face)
    (,cdr:pseudotaxus-special-operator-regexp . 'font-lock-builtin-face)
    (,cdr:pseudotaxus-algorithms-regexp . 'font-lock-function-name-face)
    (,cdr:pseudotaxus-constants-regexp . 'font-lock-constant-face)
    (,cdr:pseudotaxus-operators-regexp . 'font-lock-builtin-face)
    (,cdr:pseudotaxus-keywords-regexp . 'font-lock-keyword-face)
    (,cdr:pseudotaxus-types-regexp . 'font-lock-type-face)
    (,cdr:pseudotaxus-numeric-words-regexp . 'font-lock-number-face)
    (,cdr:pseudotaxus-numeric-ordinals-regexp . 'font-lock-number-face))
  '("\\.pseudo$" "\\.taxus$")
  nil
  "A mode for editing Pseudotaxus files.")

(provide 'pseudotaxus)
;;; pseudotaxus.el ends here
