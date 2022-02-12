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

(defun take_while(test seq)
    (if (null seq)
        ()
    (if (funcall test (first seq)) 
        (cons (first seq) (take_while test (rest seq)))
    ; else 
        ()
    ))
)

(defun drop_while(test seq)
    (if (null seq)
        ()
    (if (funcall test (first seq)) 
        (drop_while test (rest seq))
    ; else 
        seq
    ))
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

(defun get_row(row board size)
  (slice (* row size) ( + (* row size) size) 1 board)
)

(defun get_col(col board size)
  (slice col (* size size) size board)
)
(defun is_white(x)
  (and (numberp x) (>= x 0))
)

(defun is_black(x)
  (not (is_white x))
)

(defun is_blank(x)
  (= x 0 )
)

(defun is_number(x)
  (and (numberp x) (/= x 0))
)

(defun is_complete(seq)
    (if (null seq)
        T
    (if (= (first seq) 0)
        NIL
    ; else
        (is_complete (rest seq))
    ))
)

(defun extract_straights(seq)
    (setq straight (take_while #'is_white (drop_while #'is_black seq)))
    (setq remaining (drop_while #'is_white (drop_while #'is_black seq)))
    
    (if (null seq)
        ()
    (if (null straight)
        (extract_straights remaining)
    ; else 
        (cons straight (extract_straights remaining))
    ))
)

(defun valid_straight(seq)
    (if (inList 0 seq) T
    (if (/= (- (length seq) 1) (- (reduce #'max seq) (reduce #'min seq))) NIL
    (if (repeated seq) NIL
     T
    )))
)

(defun valid_coord(n board size)
    (setq row (get_row (floor n size) board size))
    (setq col (get_col (mod   n size) board size))
    
    (if (repeated (map 'list #'abs (remove-if-not #'is_number row)))
        NIL
    (if (repeated (map 'list #'abs (remove-if-not #'is_number col)))
        NIL
    (if (not (every #'valid_straight (extract_straights row)))
        NIL
    (if (not (every #'valid_straight (extract_straights col)))
        NIL
    ; else
        T
    ))))
)

(defun bruteforce_cell(i board size)
    (remove-if-not 
        (lambda (x) (valid_coord i x size))
    
        (map 'list 
            (lambda (x) (repl i x board))
            (list 1 2 3 4 5 6 7 8 9)
        )
    )
)

; (defun backtrack_str8ts(x seq)
;  (if(< i 0) 
;   NIL
;   (if(>= x (lenght seq)) seq 
;  (concatenate (map (backtrack_str8ts (+ x 1)) (bruteforce_cell x 1 seq)))
; )


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

(defun solve_str8ts(x)
  (backtrack_str8ts 0 x)
)

(defun create_board()
    (setq board   '(x  0  0 -1  x  x
                    x  0  0  0  5  0
                    x  0  1  0  0  0
                    4  0  0  1  0  x     
                    0  6  5  0  0  x
                    x  x  x  0  1 -4)
    )
    (setq size 6)
)

(defun main()
    (create_board)
    (write (bruteforce_cell 1 board size))
    ; (write (append (list 1 2 3 4) '(5)))
    ; (write (valid_coord 3 board size))
    ; (show_board board size)
    ; (write (extract_straights (get_row 0 board size)))
)

(main)
















































