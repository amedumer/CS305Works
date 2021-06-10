(define if? (lambda (elem)
(and 
    (list? elem) (equal? (car elem) 'if) (= (length elem) 4))))

(define conditional? (lambda (elem)
(and 
    (list? elem)  (= (length elem) 2))))

(define cond-list? (lambda (elem)
        (and (list? elem) (conditional? (car elem)) 
                (or     (null? (cdr elem)) 
                        (cond-list? (cdr elem))))))

(define condi? (lambda (elem)
  (and (list? elem) 
        (equal? (car elem) 'cond) 
        (cond-list? 
        (cdr elem)) )))

(define define? (lambda (elem)
        (and    (list? elem) 
                (equal? (car elem) 'define) 
                (symbol? (cadr elem)) 
                (= (length elem) 3))))

(define let? (lambda (elem)
(and (list? elem) 
        (equal? (car elem) 'let) (var-list? (cadr elem)) (= (length elem) 3))))

(define letstar? (lambda (elem)
(and (list? elem) 
        (equal? (car elem) 'let*) (= (length elem) 3))))

(define var-list? (lambda (elem)
        (and 
                (list? elem) 
                (list? (car elem)) 
                (= (length (car elem)) 2) 
                (symbol? (caar elem))
        (or     (null? (cdr elem)) 
                (var-list? (cdr elem))))))


(define op? (lambda (elem)
(cond
 ((or 
        (eq? elem '+)
        (eq? elem '-) 
        (eq? elem '*) 
        (eq? elem '/)) #t)
 (else #f)
)))

(define op-input (lambda (op-symbol) 
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

(define cs305-interpret (lambda (elem env)
(cond 

  ((number? elem) elem)

  ((symbol? elem) (get-value elem env))
  
  ((if? elem) 
      (if (not (eq? (cs305-interpret (cadr elem) env) 0))
                  ( cs305-interpret (caddr elem) env)
                  ( cs305-interpret (cadddr elem) env)))


  ((not (list? elem)) 
        "ERROR")
  
  ((eq? (car elem) 'exit) (exit))
  ((eq? (car elem) 'clear) (clear))

  ((let? elem)
      (let*
           ((params (map cs305-interpret (map cadr (cadr elem)) (make-list (length (map cadr (cadr elem))) env)))
           (newenv (append ( map cons (map car (cadr elem)) params) env)))
           (cs305-interpret (caddr elem) newenv)))
  
  ((letstar? elem)
      (cond
           ((eq? (length (cadr elem)) 1) (cs305-interpret (list 'let (cadr elem) (caddr elem)) env))
           (else 
                  (let*
                      (   (par (cs305-interpret (car (cdaadr elem)) env))
                          (newenv (cons (cons (caaadr elem) par) env)))
                          (cs305-interpret (list 'let* (cdadr elem) (caddr elem)) newenv)
                )
        )
       )
  )

  ((op? (car elem)) 
          (let ((operands (map cs305-interpret (cdr elem) (make-list (length (cdr elem)) env)))
              (operator (op-input (car elem))))

                      (if (and (or (eq? operator -) (eq? operator /)) (< (length operands) 2)) 
                              "ERROR"
                              (apply operator operands))))
  ( (condi? elem)
        (if (eq? (cs305-interpret (car (cadr elem)) env) 0)
                (if (eq? (car(cadr (cdr elem))) 'else)
                        (cs305-interpret (cadr(cadr (cdr elem))) env)
                        (cs305-interpret (cons 'cond (cddr elem)) env)
                )
                (cs305-interpret (cadr (cadr elem)) env)
        )
)

  (else    
             "ERROR"
  
  ))))

(define cs305 (lambda () (repl '())))
