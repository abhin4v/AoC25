(def pattern-captured
  '(some (sequence (capture (choice "L" "R"))
                   (number (some :d))
                   (opt "\n"))))

(defn parse-moves [input]
  (let [matches (peg/match pattern-captured input)]
    (if matches
      (map (fn [i]
             {:dir (in matches i) :steps (in matches (+ i 1))})
           (range 0 (length matches) 2))
      (error "no matches"))))

(defn wrap-position [pos]
  (cond
    (zero? pos) 0
    (zero? (% pos 100)) 0
    (pos? pos) (% pos 100)
    (neg? pos) (+ (% pos 100) 100)))

(defn move-dial [position {:dir direction :steps steps}]
  (wrap-position
   (if (= direction "L")
     (- position steps)
     (+ position steps))))

(defn apply-moves-1 [moves start-position]
  (var current start-position)
  (var zero-hits 0)
  (each move moves
        (set current (move-dial current move))
        (when (= current 0)
          (++ zero-hits)))
  zero-hits)

(defn apply-moves-2 [moves start-position]
  (var current start-position)
  (var zero-crossings 0)
  (each move moves
        (let [{:dir direction :steps steps} move
              steps-to-zero (if (= direction "L") current (- 100 current))]
          (when (>= steps steps-to-zero)
            (set zero-crossings
                 (+ zero-crossings
                    (+ (if (pos? steps-to-zero) 1 0) (div (- steps steps-to-zero) 100)))))
          (set current (move-dial current move))))
  zero-crossings)

(defn main [& _]
  (def input-path (string (os/getenv "AOC_INPUT_PATH") "/1.txt"))
  (def content (slurp input-path))
  (def moves (parse-moves content))
  (print "Part 1 - Count of 0s: " (apply-moves-1 moves 50))
  (print "Part 2 - Times crossing 0: " (apply-moves-2 moves 50)))
