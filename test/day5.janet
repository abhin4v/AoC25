(import ../day5 :as day5)

(def example-content (slurp "examples/5.txt"))
(def example-input (day5/parse-input example-content))

(assert (= (day5/part-1 example-input) 3))
(assert (= (day5/part-2 example-input) 14))
