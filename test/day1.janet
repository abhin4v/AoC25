(import ../day1 :as day1)

(def example-content (slurp "examples/1.txt"))
(def example-moves (day1/parse-moves example-content))

(assert (= (day1/apply-moves-1 example-moves 50) 3))
(assert (= (day1/apply-moves-2 example-moves 50) 6))
