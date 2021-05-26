(define if? (lambda (e)
(and 
    (list? e) (equal? (car e) 'if) (= (length e) 4))))

(define conditional? (lambda (e)
(and 
    (list? e)  (= (length e) 2))))

(define cond-list? (lambda (e)
(and (list? e) (conditional? (car e)) 
        (or (null? (cdr e)) (cond-list? (cdr e))))))

(define condi? (lambda (e)
  (and (list? e) 
        (equal? (car e) 'cond) (cond-list? (cdr e)) )))



(define define? (lambda (e)
(and (list? e) (equal? (car e) 'define) (symbol? (cadr e)) (= (length e) 3))))

(define let? (lambda (e)
(and (list? e) 
        (equal? (car e) 'let) (var-list? (cadr e)) (= (length e) 3))))

(define letstar? (lambda (e)
(and (list? e) 
        (equal? (car e) 'let*) (= (length e) 3))))

(define var-list? (lambda (e)
(and (list? e) (list? (car e)) (= (length (car e)) 2) (symbol? (caar e))
        (or (null? (cdr e)) (var-list? (cdr e))))))


(define op? (lambda (e)
(cond
 ((or (eq? e '+) (eq? e '-) (eq? e '*) (eq? e '/)) #t)
 (else #f))))

(define get-operator (lambda (op-symbol) 
(cond 
  ((equal? op-symbol '+) +)
  ((equal? op-symbol '-) -)
  ((equal? op-symbol '*) *)
  ((equal? op-symbol '/) /)
  (else "ERROR"))))

(define get-value (lambda (var env)
(cond
  ((null? env) "ERROR")
  ((equal? (caar env) var) (cdar env))
  (else (get-value var (cdr env))))))


(define repl (lambda (env)
(let* (
       (dummy1 (display "cs305> "))

       (expr (read))

       (new-env (if (define? expr)
                    (extend-env (cadr expr) (cs305-interpret (caddr expr) env) env)
                    env))

       (val (if (define? expr)
                (cadr expr)
                (cs305-interpret expr env)))

       (dummy2 (display "cs305: "))
       (dummy3 (display val))

       (dummy4 (newline))
       (dummy4 (newline)))
   (repl new-env))))

(define extend-env (lambda (var val old-env)
(cons (cons var val) old-env)))

(define cs305-interpret (lambda (e env)
(cond 

  ((number? e) e)

  ((symbol? e) (get-value e env))
  
  ((if? e) 
      (if (not (eq? (cs305-interpret (cadr e) env) 0))
                  ( cs305-interpret (caddr e) env)
                  ( cs305-interpret (cadddr e) env)))


  ((not (list? e)) 
        "ERROR")
  
  ((eq? (car e) 'exit) (exit))
  ((eq? (car e) 'clear) (clear))

  ((let? e)
      (let*
           ((params (map cs305-interpret (map cadr (cadr e)) (make-list (length (map cadr (cadr e))) env)))
           (newenv (append ( map cons (map car (cadr e)) params) env)))
           (cs305-interpret (caddr e) newenv)))
  
  ((letstar? e)
      (cond
           ((eq? (length (cadr e)) 1) (cs305-interpret (list 'let (cadr e) (caddr e)) env))
           (else 
                  (let*
                      (   (par (cs305-interpret (car (cdaadr e)) env))
                          (newenv (cons (cons (caaadr e) par) env)))
                          (cs305-interpret (list 'let* (cdadr e) (caddr e)) newenv)
                )
        )
       )
  )

  ((op? (car e)) 
          (let ((operands (map cs305-interpret (cdr e) (make-list (length (cdr e)) env)))
              (operator (get-operator (car e))))

                      (if (and (or (eq? operator -) (eq? operator /)) (< (length operands) 2)) 
                              "ERROR"
                              (apply operator operands))))
  ( (condi? e)
        (if (eq? (cs305-interpret (car (cadr e)) env) 0)
                (if (eq? (car(cadr (cdr e))) 'else)
                        (cs305-interpret (cadr(cadr (cdr e))) env)
                        (cs305-interpret (cons 'cond (cddr e)) env)
                )
                (cs305-interpret (cadr (cadr e)) env)
        )
)

  (else    
             "ERROR"
  
  ))))

(define cs305 (lambda () (repl '())))
