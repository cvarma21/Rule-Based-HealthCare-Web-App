
;Helper function declaration
(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))

;Declaration of input and output variables
(declare-fun abc () Int)
(declare-fun def () Int)
(declare-fun outp () Int)
(declare-fun outpp () Int)

;Declaration of range for input variables
(define-fun rule1_applies () Bool (and (range abc 10 20)))
(define-fun rule2_applies () Bool (and (range def 40 50)))
(define-fun rule3_applies () Bool (and (or (range abc 10 20 )(range def 40 50))))
(define-fun rule4_applies () Bool (and (range abc 10 20)))

;Declaration of rules for output variables
(define-fun output0_rule1 () Int (ite rule1_applies 200 outp))

(define-fun output0_rule2 () Int (ite rule2_applies 200 outp))

(define-fun output0_rule3 () Int (ite rule3_applies 200 outp))

(define-fun output0_rule4 () Int (ite rule4_applies 300 outp))


;Define a helper function
(define-fun atleast_two_rules_fire () Bool ((_ at-least 2) rule1_applies rule2_applies rule3_applies rule4_applies ))
(define-fun same ((fires1 Bool) (fires2 Bool) (out1 Int) (out2 Int)) Bool (implies (and fires1 fires2) (= out1 out2)))

;Define the violation for the output variables
(define-fun violation_output0 () Bool (and atleast_two_rules_fire  (not (and ( same rule1_applies rule2_applies output0_rule1 output0_rule2) ( same rule2_applies rule3_applies output0_rule2 output0_rule3) ( same rule3_applies rule4_applies output0_rule3 output0_rule4) ( same rule2_applies rule3_applies output0_rule2 output0_rule3) ( same rule3_applies rule4_applies output0_rule3 output0_rule4) ( same rule3_applies rule4_applies output0_rule3 output0_rule4))))) 
 
 
 
;Define the final violation constraint
(define-fun violation () Bool (or violation_output0 ))

(assert violation)

(check-sat)
