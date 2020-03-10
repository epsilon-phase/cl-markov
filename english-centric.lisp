(in-package #:cl-markov/english)
(import '(split-sequence:split-sequence))

(defun whitespacep(c)
  (or (char= #\space c)
      (char= #\tab c)
      (char= #\newline c)))
(defun punctuationp(c)
  "Test for sentence ends. Primitive and creppy"
  (or (char= #\? c)
      (char= #\. c)
      (char= #\! c)))

(defun split-sentences(str)
  (split-sequence:split-sequence-if #'punctuationp str :remove-empty-subseqs t))
(defun split-words(str)
  (split-sequence:split-sequence-if #'whitespacep str :remove-empty-subseqs t))

(defun build-model(text &key (degree 1) (markov nil))
  "Build a model, roughly suitable for english"
  (let ((mt (if markov markov (make-markov :degree degree))))
    (loop for sentence in (split-sentences (string-downcase text))
          do(fill-table mt (split-words sentence)))
    mt
    ))
(export '(build-model))
