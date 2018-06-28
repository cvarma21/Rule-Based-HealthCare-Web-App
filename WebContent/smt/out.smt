
;Helper function declaration
(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))

;Declaration of input and output variables
(declare-fun abc () Int)
(declare-fun anc () Int)
(declare-fun def () Int)
(declare-fun outp () Int)

;Declaration of range for input variables
(define-fun rule1_applies () Bool (and (range abc 10 20)))
(define-fun rule5_applies () Bool (and (range abc 10 20)))
(define-fun rule6_applies () Bool (and (range abc 10 20)))
(define-fun rule7_applies () Bool (and (range abc 10 20)))
(define-fun rule8_applies () Bool (and (range abc 10 20)))

;Declaration of rules for output variables
(define-fun output0_rule1 () Int (ite rule1_applies 200 outp))

(define-fun output0_rule5 () Int (ite rule5_applies 200 outp))

(define-fun output0_rule6 () Int (ite rule6_applies 200 outp))

(define-fun output0_rule7 () Int (ite rule7_applies 200 outp))

(define-fun output0_rule8 () Int (ite rule8_applies 200 outp))


;Define a helper function
(define-fun atleast_two_rules_fire () Bool ((_ at-least 2) rule1_applies rule5_applies rule6_applies rule7_applies rule8_applies ))
(define-fun same ((fires1 Bool) (fires2 Bool) (out1 Int) (out2 Int)) Bool (implies (and fires1 fires2) (= out1 out2)))
;Define the violation for the output variables
(define-fun violation_output0 () Bool (and atleast_two_rules_fire  (not (and ( same rule1_applies rule5_applies output0_rule1 output0_rule5) ( same rule5_applies rule6_applies output0_rule5 output0_rule6) ( same rule6_applies rule7_applies output0_rule6 output0_rule7) ( same rule7_applies rule8_applies output0_rule7 output0_rule8))))) 
 
;Define the final violation constraint
(define-fun violation () Bool (or violation_output0 ))

(assert violation)

(check-sat)
