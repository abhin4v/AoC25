(import ../day7 :as day7)

(def example-content (slurp "examples/7.txt"))
(def example-input (day7/parse-input example-content))
(def width (length (first example-input)))
(def height (length example-input))
(def start-index (find-index |(= $ :start) (first example-input)))

(assert (= (day7/part-1 example-input width height start-index) 21))
(assert (= (day7/part-2 example-input width height start-index) 40))
