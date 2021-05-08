(define twoOperatorCalculator
    (lambda (slst)
        (if (eq? (length slst) 1) 
            (car slst)
            (
                let (
                    (first (car slst))
                    (sym (cadr slst))
                    (rest (cddr slst))
                )
                ( if (eq? sym '+) 
                    (+ first (twoOperatorCalculator rest)) 
                    (
                        if (eq? (length rest) 1) 
                            (- first (car rest))
                            (+ (- first (car rest)) (twoOperatorCalculator (cddr rest) ))
                    ) 
                )

            )
        )
    )
)

(define fourOperatorCalculator 
    (lambda (slst)
        (
            if (eq? (length slst) 1) 
            slst
            (
                    let (
                    (first (car slst))
                    (sym (cadr slst))
                    (rest (cddr slst))

                )
                ( if (eq? sym '*) 
                    (if (eq? (length rest) 1) 
                        (list (* first (car rest)) )
                        (fourOperatorCalculator( append ( append( list(* first (car rest)) (cadr rest)) (fourOperatorCalculator (cddr rest))) ))
                    )
                    (if (eq? sym '/) 
                        (if (eq? (length rest) 1)
                            (list (/ first (car rest)))
                            (fourOperatorCalculator ( append ( append( list(/ first (car rest)) (cadr rest)) (fourOperatorCalculator (cddr rest))) ))
                        )
                        (append (list first sym) (fourOperatorCalculator rest))
                    
                    )
                )
            )
        )
    )
)

(define calculatorNested 
    (lambda(slst)
        (cond
            (   
                (null? slst) 
                #f
            )
            (
                (and (eq? (length slst) 1) 
                    (number? (car slst))) 
                    (list (car slst))
            )
            (
                (and (list? (car slst))
                    (not (null? (cdr slst))))
                    (cons   (twoOperatorCalculator (fourOperatorCalculator (calculatorNested (car slst)))) 
                            (cons (cadr slst) (calculatorNested (cddr slst)))
                    )
            )
            (
                (and (list? (car slst)) (null? (cdr slst))) (list (twoOperatorCalculator (fourOperatorCalculator (calculatorNested (car slst)))))
            )
            (
                (and (not (list? (car slst))) (not (null? (cdr slst)))) 
                    (cons (car slst) (cons (cadr slst) (calculatorNested (cddr slst))))
            )
            (
                else (list (car slst))
            )
        )
    )
)

(define checkOperators (
lambda(slst)
(cond
    ((null? slst) #f)
    ((and (list? (car slst)) (null? (cdr slst))) (checkOperators (car slst)))
    ((and
        (list? (car slst)) 
        (not (null? (cdr slst)))) 
            (and (checkOperators (car slst)) (checkOperators (cdr slst)))
    )
    ((and 
        (number? (car slst)) 
        (not (null? (cdr slst)))) 
    (if (not (number? (cadr slst)))
        (checkOperators (cdr slst))
        #f))
    ((and 
        (number? (car slst)) 
        (null? (cdr slst))) #t )
    ((not 
        (and (or (eq? (car slst) '+) 
        (eq? (car slst) '-) 
        (eq? (car slst) '*) 
        (eq? (car slst) '/ )) 
            (not (number? (car slst)))))
        #f
    )
    ((and 
        (or (eq? (car slst) '+) 
        (eq? (car slst) '-) 
        (eq? (car slst) '*) 
        (eq? (car slst) '/ )) 
            (not (null? (cdr slst)))
        ) 
            (checkOperators (cdr slst)))
    ((and (or (eq? (car slst) '+) (eq? (car slst) '-) (eq? (car slst) '*) (eq? (car slst) '/ )) (null? (cdr slst))) #f)
    (else #t))
)
)

(define calculator (
    lambda(slst)
        (
            if (null? slst)
            #f
            (if (checkOperators slst)
                (twoOperatorCalculator (fourOperatorCalculator (calculatorNested slst)))
                #f
            )
        )
)
)