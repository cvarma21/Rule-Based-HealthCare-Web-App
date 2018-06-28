
;Helper function declaration
(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))

;Declaration of input and output variables

;Declaration of range for input variables

;Declaration of input and output variables
(declare-fun abc () Int)
(declare-fun anc () Int)
(declare-fun def () Int)
(declare-fun outp () Int)
(declare-fun outpp () Int)

;Declaration of range for input variables
(define-fun rule1_applies () Bool (and (range abc 10 20)))
(define-fun rule5_applies () Bool (and (range abc 10 20)))
(define-fun rule6_applies () Bool (and (range abc 10 20)))
(define-fun rule7_applies () Bool (and (range abc 10 20)))
(define-fun rule8_applies () Bool (and (range abc 10 20)))
(define-fun rule9_applies () Bool (and (range def 30 40)))
(define-fun rule10_applies () Bool (and (range abc 10 20)))
(define-fun rule11_applies () Bool (and (or (range abc 10 20 )(range def 30 40))))
(define-fun rule12_applies () Bool (and (range abc 20 30)))
(define-fun rule13_applies () Bool (and (range abc 10 20)(range abc 20 30)))

;Declaration of rules for output variables
(define-fun output0_rule1 () Int (ite rule1_applies 200 outp))

(define-fun output0_rule5 () Int (ite rule5_applies 200 outp))

(define-fun output0_rule6 () Int (ite rule6_applies 200 outp))

(define-fun output0_rule7 () Int (ite rule7_applies 200 outp))

(define-fun output0_rule8 () Int (ite rule8_applies 200 outp))

(define-fun output0_rule9 () Int (ite rule9_applies 200 outp))

(define-fun output0_rule10 () Int (ite rule10_applies 200 outp))

(define-fun output0_rule11 () Int (ite rule11_applies 200 outp))

(define-fun output1_rule12 () Int (ite rule12_applies 400 outpp))

(define-fun output0_rule13 () Int (ite rule13_applies 400 outp))


;Define a helper function
(define-fun atleast_two_rules_fire () Bool ((_ at-least 2) rule1_applies rule5_applies rule6_applies rule7_applies rule8_applies rule9_applies rule10_applies rule11_applies rule12_applies rule13_applies ))
(define-fun same ((fires1 Bool) (fires2 Bool) (out1 Int) (out2 Int)) Bool (implies (and fires1 fires2) (= out1 out2)))

;Define the violation for the output variables
(define-fun violation_output0 () Bool (and atleast_two_rules_fire  (not (and ( same rule1_applies rule5_applies output0_rule1 output0_rule5) ( same rule5_applies rule6_applies output0_rule5 output0_rule6) ( same rule6_applies rule7_applies output0_rule6 output0_rule7) ( same rule7_applies rule8_applies output0_rule7 output0_rule8) ( same rule8_applies rule9_applies output0_rule8 output0_rule9) ( same rule9_applies rule10_applies output0_rule9 output0_rule10) ( same rule10_applies rule11_applies output0_rule10 output0_rule11) ( same rule11_applies rule13_applies output0_rule11 output0_rule13))))) 
 
(define-fun violation_output1 () Bool (and atleast_two_rules_fire  false )) 
 
;Define the final violation constraint
(define-fun violation () Bool (or violation_output0 violation_output1 ))

(assert violation)

(check-sat)
