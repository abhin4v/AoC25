(import ../day6 :as day6)

(def example-content (slurp "examples/6.txt"))

(assert (= (day6/part-1 (day6/parse-input-1 example-content)) 4277556))
(assert (= (day6/part-2 (day6/parse-input-2 example-content)) 3263827))
