(import ../day3 :as day3)

(def example-content (slurp "examples/3.txt"))
(def example-input (day3/parse-input example-content))

(assert (= (day3/solve 2 example-input) 357))
(assert (= (day3/solve 12 example-input) 3121910778619))
