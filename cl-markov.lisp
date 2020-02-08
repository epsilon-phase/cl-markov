;;;; cl-markov.lisp

(in-package #:cl-markov)
(defstruct markov
  (degree 1)
  (table (make-hash-table :test 'equal))
  (finished nil))
(defun update-entry(table state word)
  (unless (gethash state table)
    (setf (gethash state table) (make-hash-table :test 'equal)))
  (incf (gethash word (gethash state table) 0))
  )
(defun filler(table)
  (lambda(state word)
    (update-entry (markov-table table) state word)
    (subseq (cons word state) 0 (markov-degree table))
    ))

(defun fill-table(table sequence)
  (when (markov-finished table) (unfinish-table table))
  (reduce (filler table)
          (prepare-sequence sequence)
          :initial-value (make-initial-state (markov-degree table))))

(defun make-initial-state(degree)
  (loop repeat degree collect :start))

(defun prepare-sequence(seq)
  (append seq '(:end)))
(defun select-array-member(array value)
  (aref array value))
(defun entries-to-array(table)
  "Takes an occurance mapping and turns it into an array :3"
  (loop with arr = (make-array 20 :fill-pointer 0 :adjustable t)
        for word being the hash-keys of table
          using (hash-value count)
        do(loop repeat count do(vector-push-extend word arr))
        finally (return arr)))
(defun array-to-entries(array)
  "Take an array representing the table and turn it into a hashtable"
  (loop with ht = (make-hash-table :test 'equal)
        for i across array
        do(incf (gethash i ht 0))
        finally (return ht)))
(defun finish-table(table)
  (loop with finished = (make-hash-table :test 'equal)
        for state being the hash-keys of (markov-table table)
          using (hash-value value)
        do(setf (gethash state finished) (entries-to-array value))
        finally(setf (markov-table table) finished
                     (markov-finished table) t)))
(defun unfinish-table(table)
  (when (markov-finished table)
    (loop with unfinished = (make-hash-table :test 'equal)
          for state being the hash-keys of (markov-table table)
            using (hash-value array)
          do(setf (gethash state unfinished) (array-to-entries array))
          finally (progn
                    (setf (markov-table table) unfinished
                          (markov-finished table) nil)
                    table)
          )))

(defun shuffle-array(array)
  (declare (type (array * (*)) array)
           (optimize (speed 2)))
  (loop for i fixnum from 0 below (array-dimension array 0)
        for j fixnum = (random i)
        do(psetf (aref array i)
                 (aref array j)
                 (aref array j)
                 (aref array i))
        finally (return array)))

(defun accumulate-till-end(table)
  (unless (markov-finished table)
    (finish-table table))
  (loop with state = (make-initial-state (markov-degree table))
        for array = (gethash state (markov-table table))
        until(null array)
        for choice = (select-array-member array (random (length array)))
        until (eq choice :end)
        collecting choice
        do (setf state
                 (subseq (cons choice state) 0 (markov-degree table)))))

(export '(accumulate-till-end fill-table make-markov))
