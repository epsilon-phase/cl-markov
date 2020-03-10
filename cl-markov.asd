;;;; cl-markov.asd

(asdf:defsystem #:cl-markov
  :description "Describe cl-markov here"
  :author "Violet White <violet.white.dammit@protonmail.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:glacier #:str #:split-sequence)
  :components ((:file "package")
               (:file "cl-markov")
	       (:file "english-centric"))
  :in-order-to ((test-op (test-op "cl-markov-test"))))

