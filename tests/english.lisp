(in-package :cl-markov-test)

(let ((test "Hello there good friend. How are you?")
      (result '("Hello there good friend" " How are you")))
  (ok (equal (cl-markov/english::split-sentences test) result)))

(let ((test "Hello there friend")
      (result '("Hello" "there" "friend")))
  (ok (equal (cl-markov/english::split-words test) result)))
