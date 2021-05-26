(define (twoOperatorCalculator var) 
( 
cond
            ((list? (var))
            ((null?(cdr var)) var)
    ((eqv? (cdr var) '()) (car var))
    ((and (number? (car var)) (eqv? (cadr var) '+) (number? (caddr var))) (twoOperatorCalculator(cons (+ (car var) (caddr var)) (cdddr var) ))  )
    ((and (number? (car var)) (eqv? (cadr var) '-) (number? (caddr var))) (twoOperatorCalculator(cons (- (car var) (caddr var)) (cdddr var) ))  )
)
)
)


(define (fourOperatorCalculator var) 
( 
cond
    ((eqv? (cdr var) '()) var)
    ((and (number? (car var)) (eqv? (cadr var) ') (number? (caddr var))) (fourOperatorCalculator(cons ( (car var) (caddr var)) (cdddr var) ))  )
    ((and (number? (car var)) (eqv? (cadr var) '/) (number? (caddr var))) (fourOperatorCalculator(cons (/ (car var) (caddr var)) (cdddr var) ))  )
    (else (cons (car var) (fourOperatorCalculator (cdr var))) )
)
)



(define (Nested m)
(
cond
    ((list? m) (twoOperatorCalculator(fourOperatorCalculator(calculatorNested m))))
    (else m)
)
)


(define (calculatorNested var)(map Nested var))


(define (checkOperators var)
(
cond
    ((null? var) #f)
            ((not(list? var)) #f)
    ((and (number? (car var)) (null? (cdr var))) #t)
    ((and (list? (car var)) (null? (cdr var))) (checkOperators (car var)))
    ((and (number? (car var)) (or (eqv? '- (cadr var)) (eqv? '+ (cadr var)) (eqv? '/ (cadr var)) (eqv? '* (cadr var)))) (checkOperators (cddr var)) )
    ((and (list? (car var))   (or (eqv? '- (cadr var)) (eqv? '+ (cadr var)) (eqv? '/ (cadr var)) (eqv? '* (cadr var)))) (and (checkOperators (car var)) (checkOperators (cddr var))))
    (else #f)
)
)


(define (calculator var)
(
cond
    ((checkOperators var) (twoOperatorCalculator (fourOperatorCalculator (calculatornested var))))
    (else #f)
)
)