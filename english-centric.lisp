(in-package #:cl-markov/english)

(flet ((c= (char &rest compare)
	   (loop for c in compare
		 if (char= char (coerce c 'character))
		   return t)))
  (defun punctuationp(c)
    "Test for sentence ends"
    (c= c "!" "." "?")))

(defun split-sentences(str)
  (mapcar #'str:trim
	  (split-sequence-if #'punctuationp str :remove-empty-subseqs t)))

(defun split-words(str)
  (str:words str))
                                        ;Too lazy to use a real testing framework
                                        ;for this
(let ((test "Hello there good friend. How are you?")
      (result '("Hello there good friend" "How are you")))
  (assert (equalp (split-sentences test) result)))
(let ((test "Hello there friend")
      (result '("Hello" "there" "friend")))
  (assert (equal (split-words test) result)))

(defun build-model(text &key (degree 1) (markov nil))
  "Build a model, roughly suitable for english"
  (let ((mt (if markov markov (make-markov :degree degree))))
    (loop for sentence in (split-sentences (string-downcase text))
          do(fill-table mt (split-words sentence))
	  finally (return mt))))
(export '(build-model))
