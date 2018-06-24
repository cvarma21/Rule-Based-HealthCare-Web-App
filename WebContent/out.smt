
;Helper function declaration
(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))

;Declaration of input and output variables
(declare-fun abc () Int)
(declare-fun def () Int)
(declare-fun efg () Int)
(declare-fun outp () Int)
(declare-fun outpp () Int)

;Declaration of range for input variables
(define-fun rule1_applies () Bool (and (range abc 10 20)))
(define-fun rule2_applies () Bool (and (range def 20 30)))
(define-fun rule3_applies () Bool (and (range def 20 30)))
(define-fun rule4_applies () Bool (and (range def 20 30)))
(define-fun rule5_applies () Bool (and (range def 20 30)))
(define-fun rule6_applies () Bool (and (range def 20 30)))
(define-fun rule7_applies () Bool (and (range def 20 30)))
(define-fun rule8_applies () Bool (and (range def 20 30)))
(define-fun rule9_applies () Bool (and (range def 20 30)))
(define-fun rule10_applies () Bool (and (range def 20 30)))

;Declaration of rules for output variables
(define-fun output0_rule1 () Int (ite rule1_applies 200 outp))

(define-fun output1_rule2 () Int (ite rule2_applies 300 outpp))

(define-fun output1_rule3 () Int (ite rule3_applies 300 outpp))

(define-fun output1_rule4 () Int (ite rule4_applies 300 outpp))

(define-fun output1_rule5 () Int (ite rule5_applies 300 outpp))

(define-fun output1_rule6 () Int (ite rule6_applies 300 outpp))

(define-fun output1_rule7 () Int (ite rule7_applies 100 outpp))

(define-fun output1_rule8 () Int (ite rule8_applies 100 outpp))

(define-fun output1_rule9 () Int (ite rule9_applies 100 outpp))

(define-fun output1_rule10 () Int (ite rule10_applies 100 outpp))


;Define a helper function
(define-fun atleast_two_rules_fire () Bool ((_ at-least 2) rule1_applies rule2_applies rule3_applies rule4_applies rule5_applies rule6_applies rule7_applies rule8_applies rule9_applies rule10_applies ))

;Define the violation for the output variables
(define-fun violation_output0 () Bool (and atleast_two_rules_fire  false )) 
 
(define-fun violation_output1 () Bool (and atleast_two_rules_fire  ( distinct output1_rule2  output1_rule3  output1_rule4  output1_rule5  output1_rule6  output1_rule7  output1_rule8  output1_rule9  output1_rule10  ))) 
 
;Define the final violation constraint
(define-fun violation () Bool (or violation_output0 violation_output1 ))

(assert violation)

(check-sat)
