; funções para mexer com listas
(defun drop(n seq)
    (if (= n 0) 
        seq
        (drop (- n 1) (rest seq))
    )
)

(defun take(n seq)
    (if (= n 0) 
        ()
    ; else 
        (cons (first seq) (take (- n 1) (rest seq)))
    )
)


(defun steps(n seq)
    (if (null seq)
        ()
    ; else
        (cons (first seq) (steps n (drop (- n 1) (rest seq) )))
    )
)

(defun slice(start end step seq)
    (if (null seq) 
        ()
    ; else
        (steps step (drop start (take end seq))) 
    )
)

(defun inList(el seq)
    (if (null seq)
        NIL
    (if (= el (first seq))
        T
    ; else
        (inList el (rest seq))
    ))
)

(defun repeated(seq)
    (if (null seq)
        NIL
    (if (inList (first seq) (rest seq))
        T
    ; else
        (repeated (rest seq))   
    ))
)

(defun repl(n el seq)
    (if (= n 0)
        (cons el (rest seq))
        (cons (first seq) (repl (- n 1) el (rest seq)))
    )
)



; funções para o resolvedor

(defun validStraight(seq)

    (if (inList 0 seq) T
    (if (/= (- (length seq) 1) (- (reduce #'max seq) (reduce #'min seq))) NIL
    (if (repeated seq) NIL
    ; else
    T
    )))
)






(defun create_board()
    (setq board   '(x  0  0 -1  x  x
                    x  0  0  0  5  0
                    x  0  1  0  0  0
                    4  0  0  0  0  x     
                    0  6  5  0  0  x
                    x  x  x  0  1 -4)
    )

)





(defun main()
    (create_board)
    (write (validStraight (list 3 1 1)))
)

(main)
































