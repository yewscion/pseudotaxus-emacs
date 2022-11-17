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
      (concat "\\(true\\|false\\|nonexistant\\|unbound\\|missing\\|null\\|"
              "success\\|failure\\|succeeds\\|fails\\|found\\|newline\\|"
              "beep\\|indent\\|user\\|screen\\|system\\)"))
(defvar cdr:pseudotaxus-types-regexp
      (concat "\\(number\\|string\\|character\\|boolean\\|truthy\\|falsey\\|"
              "list\\|array\\|sequence\\|every\\|each\\|member\\|index\\|"
              "nothing\\|maybe\\|"
              "symbol\\|many\\|any\\|constant\\|operator\\|procedure\\|"
              "argument\\|parameter\\|"
              "file\\|stream\\|pipe\\|port\\|line\\|interrupt\\|sum\\|"
              "difference\\|product\\|quotient\\|remainder\\|value\\|name\\|"
              "result\\|message\\|field\\|an?\\|the\\)"
              "\\(ish\\|-like\\|esque\\|s\\)?"))
(defvar cdr:pseudotaxus-operators-regexp
      (regexp-opt '(">" "<" "==" "!=" "<>" "<=" ">=" "=" "!<" "!>" "≡" "≯"
                    "≮" "≥" "≤" "≠" "less than" "more than" "greater than"
                    "equal to" "different than" "different from" "¬" "⊻"
                    "∨" "∧" "&&" "||" "not" "xor" "and" "or" "exclusive"
                    "->" "<-" "→" "←" "fed" "right" "left"
                    "^" "*" "+" "-" "/" "%" "×" "÷" "plus" "minus" "times"
                    "divided by" "modulo" "add" "subtract" "multiply"
                    "divide" "take the remainder of" "raised to the"
                    "power" "squared" "cubed" "root" "square" "cube")
                  'symbols))
(defvar cdr:pseudotaxus-keywords-regexp
      (regexp-opt
       '("begin" "end" "read" "obtain" "get" "from" "take" "use" "copy" "print"
       "display" "show" "save" "return" "compute" "calculate" "determine"
       "append" "over" "set" "initialize" "init" "let" "is" "has" "contains"
       "to" "increment" "bump" "decrement" "if" "then" "else" "otherwise" "when"
       "unless" "while" "done" "endwhile" "do" "case" "of" "others" "endcase"
       "repeat" "until" "for" "endfor" "call" "exception" "as" "recurse" "this"
       "that" "except" "in" "at" "including" "convert" "wrap" "ensure" "cast"
       "expecting" "expect" "be")
       'symbols))
(defvar cdr:pseudotaxus-algorithms-regexp
      (regexp-opt
       '("sum" "difference" "product" "quotient" "remainder" "modulus" "sign"
         "reciprocal" "magnitude" "logarithm" "average" "mean" "median" "mode"
         "range" "max" "maximum" "min" "minimum" "maxima" "minima" "ceiling"
         "floor" "sort" "reverse" "search" "find" "filter in" "filter out"
         "grade up" "grade down" "scan" "map" "reduce" "expand" "replicate"
         "tally" "indexing")
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
