
;Helper function declaration
(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))

;Declaration of input and output variables
(declare-fun abc () Int)
(declare-fun outp () Int)

;Declaration of range for input variables
(define-fun rule1_applies () Bool (and (range abc 10 20)))
(define-fun rule2_applies () Bool (and (range abc 10 20)))
(define-fun rule3_applies () Bool (and (range abc 10 20)))
(define-fun rule4_applies () Bool (and (range abc 10 20)))
(define-fun rule5_applies () Bool (and (range abc 10 20)))
(define-fun rule6_applies () Bool (and (range abc 10 20)))
(define-fun rule7_applies () Bool (and (range abc 10 20)))

;Declaration of rules for output variables
(define-fun output0_rule1 () Int (ite rule1_applies 100 outp))

(define-fun output0_rule2 () Int (ite rule2_applies 200 outp))

(define-fun output0_rule3 () Int (ite rule3_applies 200 outp))

(define-fun output0_rule4 () Int (ite rule4_applies 200 outp))

(define-fun output0_rule5 () Int (ite rule5_applies 200 outp))

(define-fun output0_rule6 () Int (ite rule6_applies 200 outp))

(define-fun output0_rule7 () Int (ite rule7_applies 200 outp))


;Define a helper function
(define-fun atleast_two_rules_fire () Bool ((_ at-least 2) rule1_applies rule2_applies rule3_applies rule4_applies rule5_applies rule6_applies rule7_applies ))

;Define the violation for the output variables
(define-fun violation_output0 () Bool (and atleast_two_rules_fire  (not (= output0_rule1  output0_rule2  output0_rule3  output0_rule4  output0_rule5  output0_rule6  output0_rule7  )))) 
 
;Define the final violation constraint
(define-fun violation () Bool (or violation_output0 ))

(assert violation)

(check-sat)
