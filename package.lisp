;;;; package.lisp

(defpackage #:cl-markov
  (:use #:cl))

(defpackage #:cl-markov/english
  (:use #:cl #:cl-markov)
  (:import-from :split-sequence
		:split-sequence-if)
  (:documentation "Utilities that assist with very simplistic handling of english text. Might work for other languages that do not use dissimilar punctuation"))
