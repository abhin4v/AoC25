(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/7.txt"))

(def input-peg
  (peg/compile
   ~{:main (sequence (some :row) -1)
     :row  (group (sequence (some :cell) (opt "\n")))
     :cell (choice (replace "." :empty)
                   (replace "^" :splitter)
                   (replace "S" :start))}))

(defn parse-input [content] (peg/match input-peg content))

(defn propagate [grid width row-num idx]
  (def row (in grid row-num))
  (match (in row idx)
    :empty [idx]
    :splitter (seq [o :in [-1 1]
                    :let [x (+ idx o)]
                    :when (< -1 x width)]
                   x)))

(defn part-1 [input width height start-index]
  (defn step [[beam-indices splits] row-num]
    (let [new-indices (->> beam-indices
                           keys
                           (mapcat |(propagate input width row-num $)))]
      [(apply struct (mapcat |[$ :t] new-indices))
       (+ splits (- (length new-indices) (length beam-indices)))]))

  (->
   (reduce step [{start-index :t} 0] (range 1 height))
   (in 1)))

(defn part-2 [input width height start-index]
  (def cache @{})

  (defn count-paths-memo [layer idx]
    (if (has-key? cache [layer idx])
      (get cache [layer idx])
      (let [count (if (= layer height)
                    1
                    (sum (map |(count-paths-memo (inc layer) $)
                              (propagate input width layer idx))))]
        (put cache [layer idx] count)
        count)))

  (count-paths-memo 1 start-index))

(defn main [& _]
  (def content (slurp input-path))
  (def input (parse-input content))
  (def width (length (first input)))
  (def height (length input))
  (def start-index (find-index |(= $ :start) (first input)))

  (print "Part 1: " (part-1 input width height start-index))
  (print "Part 2: " (part-2 input width height start-index)))
