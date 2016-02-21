(define (compare-expr x y)
    (cond
      [
        (and
          (list? x)
          (list? y)
          (equal? (length x) (length y))
          (not (empty? x))
          (not (empty? y))
          (or
            (equal? (first x) 'quote)
            (equal? (first y) 'quote)
          )
        )
        (handle-quote x y)
      ]
      ;;; handle IF statement
      [
        (and
          (list? x)
          (list? y)
          (equal? (length x) (length y))
          (not (empty? x))
          (not (empty? y))
          (or
            (equal? (first y) 'if)
            (equal? (first x) 'if)
          )
        )
        (handle-if x y)
      ]
      ;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; handle LET statement
      ;;;;;;;;;;;;;;;;;;;;;;;;
      [
        (and
          (list? x)
          (list? y)
          (equal? (length x) (length y))
          (not (empty? x))
          (not (empty? y))
          (or
            (equal? (first x) 'let)
            (equal? (first y) 'let)
          )
        )
         (handle-let  x  y)
      ]
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; handle LAMBDA statement
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;
      [
        (and
          (list? x)
          (list? y)
          (equal? (length x) (length y))
          (not (empty? x))
          (not (empty? y))
          (equal? (first x) 'lambda)
          (equal? (first y) 'lambda)
        )
         (handle-lamb x y)
      ]
      [else (handle-list x y)]
    )
)


(define (check-constraints x y)
  (if
    (and
      (list? x)
      (list? y)
      (equal? (length x) (length y))
      (not (empty? x))
      (not (empty? y))
    )
    #t
    #f
  )
)

(define (handle x y)
  (if (equal? x y)
      x
      (cond
       [(and (equal? x #t) (equal? y #f)) '(TCP)]
       [(and (equal? x #f) (equal? y #t)) '(not TCP)]
       [`(if TCP ,x ,y)]
      )
  )
)



(define (handle-list x y)
  (cond
    [
      (and
        (list? x)
        (list? y)
        (equal? (length x) (length y))
        (not (empty? x))
        (not (empty? y))
      )
     (cons (compare-expr (first x) (first y)) (compare-expr (rest x) (rest y)))
    ]
    [else (handle x y)]
  )
)

(define (handle-quote x y)
  (handle x y)
)

(define (handle-if x y)
  (if (equal? (first x) (first y))
    (cons (handle (first x) (first y)) (compare-expr (rest x) (rest y)))
    (handle x y)
  )
)

(define (handle-let x y)
  (if (let-map (cadr x) (cadr y))
    (cons (print-let x y) (compare-expr (caddr x) (caddr y)))
    (handle x y)
  )
)

(define (print-let x y)
  (cons (handle (first x) (first y)) (handle-list (cadr x) (cadr y)))
)

(define (handle-lamb x y)
  (if (and (equal? (cadr x) (cadr y)) (list? x) (list? y))

    (cons (handle (first x) (first y))
     (compare-expr (rest x) (rest y)))
    (handle x y)
  )
)

(define (print-lamb x y)
  (append (handle (first x) (first y)) (list (handle (cadr x) (cadr y))))
)

(define (let-map x y)
  (cond
    [
    (and
      (list? x)
      (list? y)
      (empty? x)
      (empty? y)
    )
    #t
    ]
    [
      (and
        (list? x)
        (list? y)
        (not (empty? x))
        (not (empty? y))
        (equal? (length x) (length y))
        (is-eq (first x) (first y))
      )
      (let-map (rest x) (rest y))
    ]
    [else #f]
  )
)

(define (is-eq x y)
  (if
    (and
      (list? x)
      (list? y)
      (not (empty? x))
      (not (empty? y))
      (equal? (length x) (length y))
      (equal? (first x) (first y))
    )
    #t
    #f
  )
)

(define (length list)
  (if (null? list)
      0
      (+ 1 (length (rest list)))
  )
)