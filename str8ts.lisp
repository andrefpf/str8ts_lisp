(defun possible (numbers colors y x value)
    (block outer-block
        (dotimes (i SIZE)
            (if (or (= (aref numbers y i) value) (= (aref numbers i x) value))
                (return-from outer-block NIL)))

            (setf north y)
            (setf south y)
            (loop while (and (> north 0) (aref colors (- north 1) x))
                do (setf north (- north 1)))
            (loop while (and (< south (- SIZE 1)) (aref colors (+ south 1) x))
                do (setf south (+ south 1)))

            (setf space (+ (- south north) 1))
            (loop for row from north to south
                do (if (and (/= (aref numbers row x) 0) (>= (abs (- (aref numbers row x) value)) space))
                    (return-from outer-block NIL)))
            (setf west x)
            (setf east x)
            (loop while (and (> west 0) (aref colors y (- west 1)))
                do (setf west (- west 1)))
            (loop while (and (< east (- SIZE 1)) (aref colors y (+ east 1)))
                do (setf east (+ east 1)))

            (setf space (+ (- east west) 1))
            (loop for col from west to east
                do (if (and (/= (aref numbers y col) 0) (>= (abs (- (aref numbers y col) value)) space))
                    (return-from outer-block NIL)))

        T
    )
)


(defun solve (numbers colors)
    (if
        (block solve-block
            (dotimes (y SIZE)
                (dotimes (x SIZE)
                    (if (and (= (aref numbers y x) 0) (aref colors y x))
                        (progn
                            (dotimes (value SIZE)
                                (if (possible numbers colors y x (+ value 1))
                                    (progn 
                                        (setf (aref numbers y x) (+ value 1))
                                        (solve numbers colors)
                                        (setf (aref numbers y x) 0))))
                            (return-from solve-block NIL)))))
            T
        )
        (parse-output numbers colors)
    )
)


(defun parse-output (numbers colors)
    (dotimes (y SIZE)
        (terpri )
        (dotimes (x SIZE)
            (if (aref colors y x)
                (format T " ~D " (aref numbers y x))
                (format T "[~D]" (aref numbers y x)))))
    (terpri )
)


(defun parse-input ()

    (write-line "::: Lendo inteiro (>=1) que representa o tamanho do tabuleiro...")
    (setf SIZE (parse-integer (read-line )))

    (format T "::: Tamanho selecionado: ~Dx~D" SIZE SIZE)
    (terpri )
    (setf numbers (make-array (list SIZE SIZE) :initial-element 0))
    (setf colors  (make-array (list SIZE SIZE) :initial-element T))

    (write-line "::: Lendo o tabuleiro...")
    (dotimes (y SIZE)
        (dotimes (x SIZE)
            (setf word (write-to-string (read )))
            (setf (aref numbers y x) (parse-integer (subseq word 1)))
            (if (equalp (subseq word 0 1) "w")
                (setf (aref colors y x) T)
                (setf (aref colors y x) NIL))))

    (write-line "::: Tabuleiro de entrada:")
    (parse-output numbers colors)

    (write-line "::: Solucoes validas:")
    (solve numbers colors)
    (write-line "::: Concluido!")
)


(parse-input)
