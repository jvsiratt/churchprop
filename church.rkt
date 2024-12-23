#lang typed/racket

(require "./kernel/formula.rkt" "./kernel/proof.rkt")

(provide (rename-out [proof->string print-proof])
         (struct-out falsehood)
         (struct-out variable)
         (struct-out implication)
         Proof
         proof-conclusion
         form
         assuming
         apply-axiom1
         apply-axiom2
         apply-axiom3
         apply-modus-ponens)

(: formula->string (-> Formula String))
(define (formula->string form)
  (match form
    [(implication x y) (format "(~a -> ~a)"
                               (formula->string x)
                               (formula->string y))]
    [(variable l) (format "~a" l)]
    [(falsehood) "FALSE"]))

(: proof->string (-> Proof String String))
(define (proof->string pf name)
  (: temp-recurse (-> Proof String String))
  (define (temp-recurse pf* label)
    (match pf*
      [(assumption form) (format "~a}\n ~a\n   - by Assumption" label (formula->string form))]
      [(axiom1 form) (format "~a}\n  ~a\n   - following from Axiom 1" label (formula->string form))]
      [(axiom2 form) (format "~a}\n  ~a\n   - following from Axiom 2" label (formula->string form))]
      [(axiom3 form) (format "~a}\n  ~a\n   - following from Axiom 3" label (formula->string form))]
      [(modus-ponens form pf1 pf2) (format "~a}\n  ~a\n   - following from ~a and ~a\n\n~a\n\n~a"
                                           label (formula->string form)
                                           (format "~a.A" label)
                                           (format "~a.B" label)
                                           (temp-recurse pf1 (format "~a.A" label))
                                           (temp-recurse pf2 (format "~a.B" label)))]))
  (temp-recurse pf name))

(define-syntax form
  (syntax-rules ()
    [(form (falsehood)) (falsehood)]
    [(form (a -> b)) (implication (form a) (form b))]
    [(form a) (variable a)]))


(: assuming (-> Formula assumption))
(define (assuming phi)
  (assumption phi))

(: apply-axiom1 (-> Formula Formula axiom1))
(define (apply-axiom1 phi psi)
  (axiom1 (implication phi (implication psi phi))))

(: apply-axiom2 (-> Formula Formula Formula axiom2))
(define (apply-axiom2 phi psi gamma)
  (axiom2 (implication (implication phi (implication psi gamma))
                       (implication (implication phi psi)
                                    (implication phi gamma)))))

(: apply-axiom3 (-> Formula axiom3))
(define (apply-axiom3 phi)
  (axiom3 (implication (implication (implication phi (falsehood))
                                    (falsehood))
                       phi)))

(: apply-modus-ponens (-> Proof Proof modus-ponens))
(define (apply-modus-ponens proof-of-implication proof-of-antecedent)
  (if (implication? (proof-conclusion proof-of-implication))
      (modus-ponens (implication-consequent (proof-conclusion proof-of-implication))
                    proof-of-implication
                    proof-of-antecedent)
      (error (format "~a is not an implication." (print (proof-conclusion proof-of-implication))))))