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

(defun get_row(row seq size)
  (slice (* row size) ( + (* row size) size) 1 seq)
)

(defun get_col(col seq size)
  (slice col (* size size) size seq)
)
(defun is_white(x)
  (>= x 0) 
)

(defun is_black(x)
  (< x 0)
)

(defun is_blank(x)
  (= x 0 )
)

(defun bruteforce_cell(x y seq)
 (if(<= x 0)) NIL
 (if(> x 9)) NIL
 (if(not (is_blank (or seq y)))) seq
 (if(not (valid_coord  y (replace x y seq)))
   (bruteforce_cell y (+ x 1) seq))
 (concatenate((replace y x seq) (brutefore_cell y (+x 1) seq)))
)

(defun backtrack_str8ts(x seq)
 (if(< i 0) 
  NIL
  (if(>= x (lenght seq)) seq 
 (concatenate (map (backtrack_str8ts (+ x 1)) (bruteforce_cell x 1 seq)))
)

(defun solve_str8ts(x)
  (backtrack_str8ts 0 x)
)

(defun is_number(x)
  (and (numberp x) (/= x 0))
)

(defun valid_straight(seq)
    (if (inList 0 seq) T
    (if (/= (- (length seq) 1) (- (reduce #'max seq) (reduce #'min seq))) NIL
    (if (repeated seq) NIL
     T
    )))
)

(defun valid_coord(n seq)
    (setq row (list 1 2 4 3))
    (setq col (list 3 4 5 6))
    
    (setq row_str (list (list 2 4 3)))
    (setq col_str (list (list 1 2 3)))
    
    (if (repeated (map 'list #'abs (remove-if-not #'is_number row)))
        NIL
    (if (repeated (map 'list #'abs (remove-if-not #'is_number col)))
        NIL
    (if (not (every #'valid_straight row_str))
        NIL
    (if (not (every #'valid_straight col_str))
        NIL
        T
    ))))
)

(defun create_board()
    (setq board   '(x  0  0 -1  x  x
                    x  0  0  0  5  0
                    x  0  1  0  0  0
                    4  0  0  0  0  x     
                    0  6  5  0  0  x
                    x  x  x  0  1 -4)
    )
    (setq size 6)
)

(defun show_board(board size)
    (dotimes (y size)
        (dotimes(x size)
            (setq val (nth (+ (* y size) x) board))
            
            (if (not (numberp val))
                (format T "[ ]")
            (if (= val 0)
                (format T "   ")
            (if (< val 0)
                (format T "[~D]" (abs val))    
            ; else
                (format T " ~D " val)
            )))
        )
        (terpri )
    )
)


(defun main()
    (create_board)
    (show_board board size)
    ; (write (get_col 3 board size))
)

(main)






