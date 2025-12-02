(import ../day2 :as day2)

(def example-content (slurp "examples/2.txt"))
(def example-input (day2/parse-input example-content))

(assert (= (day2/part-1 example-input) 1227775554))
(assert (= (day2/part-2 example-input) 4174379265))
