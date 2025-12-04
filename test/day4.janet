(import ../day4 :as day4)

(def example-content (slurp "examples/4.txt"))
(def example-grid (day4/parse-input example-content))

(assert (= (day4/part-1 example-grid) 13))
(assert (= (day4/part-2 example-grid) 43))
