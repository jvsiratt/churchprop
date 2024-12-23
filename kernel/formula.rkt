#lang typed/racket

(provide (rename-out [formula Formula])
         (struct-out falsehood)
         (struct-out variable)
         (struct-out implication))


(struct formula ()
  #:transparent
  #:constructor-name avoid)

(struct falsehood formula () #:transparent)

(struct variable formula
  ([label : Any])
  #:transparent)

(struct implication formula
  ([antecedent : formula]
   [consequent : formula])
  #:transparent)