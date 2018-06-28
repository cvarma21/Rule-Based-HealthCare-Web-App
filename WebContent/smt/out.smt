
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
(define-fun rule5_applies () Bool (and (range abc 10 20)))
(define-fun rule6_applies () Bool (and (range def 40 50)))
(define-fun rule7_applies () Bool (and (or (range abc 10 20 )(range def 40 50))))
(define-fun rule8_applies () Bool (and (or (range abc 10 20 )(range def 40 50))))
(define-fun rule9_applies () Bool (and (or (range abc 10 20 )(range def 40 50))))

;Declaration of rules for output variables
(define-fun output0_rule1 () Int (ite rule1_applies 200 outp))

(define-fun output0_rule2 () Int (ite rule2_applies 200 outp))

(define-fun output0_rule3 () Int (ite rule3_applies 200 outp))

(define-fun output0_rule4 () Int (ite rule4_applies 200 outp))

(define-fun output1_rule5 () Int (ite rule5_applies 300 outpp))

(define-fun output1_rule6 () Int (ite rule6_applies 300 outpp))

(define-fun output1_rule7 () Int (ite rule7_applies 300 outpp))

(define-fun output0_rule8 () Int (ite rule8_applies 200 outp))
(define-fun output1_rule8 () Int (ite rule8_applies 300 outpp))

(define-fun output0_rule9 () Int (ite rule9_applies 100 outp))
(define-fun output1_rule9 () Int (ite rule9_applies 100 outpp))


;Define a helper function
(define-fun atleast_two_rules_fire () Bool ((_ at-least 2) rule1_applies rule2_applies rule3_applies rule4_applies rule5_applies rule6_applies rule7_applies rule8_applies rule9_applies ))
(define-fun same ((fires1 Bool) (fires2 Bool) (out1 Int) (out2 Int)) Bool (implies (and fires1 fires2) (= out1 out2)))

;Define the violation for the output variables
(define-fun violation_output0 () Bool (and atleast_two_rules_fire  (not (and ( same rule1_applies rule2_applies output0_rule1 output0_rule2) ( same rule2_applies rule3_applies output0_rule2 output0_rule3) ( same rule3_applies rule4_applies output0_rule3 output0_rule4) ( same rule4_applies rule8_applies output0_rule4 output0_rule8) ( same rule8_applies rule9_applies output0_rule8 output0_rule9) ( same rule2_applies rule3_applies output0_rule2 output0_rule3) ( same rule3_applies rule4_applies output0_rule3 output0_rule4) ( same rule4_applies rule8_applies output0_rule4 output0_rule8) ( same rule8_applies rule9_applies output0_rule8 output0_rule9) ( same rule3_applies rule4_applies output0_rule3 output0_rule4) ( same rule4_applies rule8_applies output0_rule4 output0_rule8) ( same rule8_applies rule9_applies output0_rule8 output0_rule9) ( same rule4_applies rule8_applies output0_rule4 output0_rule8) ( same rule8_applies rule9_applies output0_rule8 output0_rule9) ( same rule8_applies rule9_applies output0_rule8 output0_rule9))))) 
 
(define-fun violation_output1 () Bool (and atleast_two_rules_fire  (not (and ( same rule5_applies rule6_applies output1_rule5 output1_rule6) ( same rule6_applies rule7_applies output1_rule6 output1_rule7) ( same rule7_applies rule8_applies output1_rule7 output1_rule8) ( same rule8_applies rule9_applies output1_rule8 output1_rule9) ( same rule6_applies rule7_applies output1_rule6 output1_rule7) ( same rule7_applies rule8_applies output1_rule7 output1_rule8) ( same rule8_applies rule9_applies output1_rule8 output1_rule9) ( same rule7_applies rule8_applies output1_rule7 output1_rule8) ( same rule8_applies rule9_applies output1_rule8 output1_rule9) ( same rule8_applies rule9_applies output1_rule8 output1_rule9))))) 
 
;Define the final violation constraint
(define-fun violation () Bool (or violation_output0 violation_output1 ))

(assert violation)

(check-sat)
