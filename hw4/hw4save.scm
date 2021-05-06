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

(twoOperatorCalculator '(1))
(twoOperatorCalculator '(1 + 2))
(twoOperatorCalculator '(1 + -2))
(twoOperatorCalculator '(2 - 1 + 3 + 1))
(twoOperatorCalculator '(1 + 15 - 32/5 + -2))
(twoOperatorCalculator '(32/5))
(twoOperatorCalculator '(1 - 2))

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
                    (fourOperatorCalculator(list (* first (car rest)) (cadr rest) (cadr (cdr rest)) ))
                )
                (if (eq? sym '/) 
                    (if (eq? (length rest) 1)
                        (list (/ first (car rest)))
                        (fourOperatorCalculator ( list(/ first (car rest) ) (cadr rest) (cadr (cdr rest)) ))
                    )
                    (append (list first sym) (fourOperatorCalculator rest))
                
                )
            )
        )
    )
)
)

(twoOperatorCalculator '(1))
(twoOperatorCalculator '(1 + 2))
(twoOperatorCalculator '(1 + -2))
(twoOperatorCalculator '(2 - 1 + 3 + 1))
(twoOperatorCalculator '(1 + 15 - 32/5 + -2))
(twoOperatorCalculator '(32/5))
(twoOperatorCalculator '(1 - 2))
(fourOperatorCalculator '(5 + 2 * 2 + 2))
(fourOperatorCalculator '(5 / 2 * 2))
(fourOperatorCalculator '(5 / 2))
(fourOperatorCalculator '(4 / 5 * 8))
(fourOperatorCalculator '(3 * 5 - 4 / 5 * 8 + 2 * -1))

