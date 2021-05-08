(define calculatorNested 
(lambda(lst)
    (cond
        (   
            (null? lst) 
            #f
        )
        (
            (and (eq? (length lst) 1) 
                (number? (car lst))) 
                (list (car lst))
        )
        (
            (and (list? (car lst))
                (not (null? (cdr lst))))
                (cons (twoOperatorCalculator (fourOperatorCalculator (calculatorNested (car lst)))) (cons (cadr lst) (calculatorNested (cddr lst))))
        )
        (
            (and (list? (car lst)) (null? (cdr lst))) (list (twoOperatorCalculator (fourOperatorCalculator (calculatorNested (car lst)))))
        )
        (
            (and (not (list? (car lst))) (not (null? (cdr lst)))) 
                (cons (car lst) (cons (cadr lst) (calculatorNested (cddr lst))))
        )
        (
            else (list (car lst))
        )
    )
)
)