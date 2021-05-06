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
    (lambda (slst) (
        if (eq? (length slst) 1) 
        ( if (symbol? (car slst))
            (calculatorNested(car slst))    
            (list twoOperatorCalculator(fourOperatorCalculator (car slst)))
        )
        (
            let (
            (first (car slst))
            (sym (cadr slst))
            (rest (cddr slst)))
            (
                
                if(symbol? first)
                    (list 1)
                    (append (list first sym)   (calculatorNested rest) )
            )
        )
        )

    )
)



(calculatorNested '( 1 + (1 + 1) )      )
(calculatorNested '( 1 + 2 * ( 2 - ( 3 + 5 ) / 2 ) ) )  
(calculatorNested '( 1 + 2 * ( 2  / 2 ) ) )  