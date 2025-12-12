(import ../day8 :as day8)

(def example-content (slurp "examples/8.txt"))
(def example-input (day8/parse-input example-content))
(def pairs (day8/point-pairs example-input))

(assert (= (day8/part-1 pairs) 40))
(assert (= (day8/part-2 example-input pairs) 25272))
