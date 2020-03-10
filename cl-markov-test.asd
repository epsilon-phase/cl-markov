;;;; cl-markov-test.asd

(asdf:defsystem #:cl-markov-test
  :description "Describe cl-markov here"
  :author "Violet White <violet.white.dammit@protonmail.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (#:cl-markov #:rove)
  :components ((:module "tests"
		:components
		((:file "package")
		 (:file "english")))))
