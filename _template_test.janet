(import ../dayN :as dayN)

(def example-content (slurp "examples/N.txt"))
(def example-input (dayN/parse-input example-content))

(assert (= (dayN/part-1 example-input) EXPECTED_PART1))
(assert (= (dayN/part-2 example-input) EXPECTED_PART2))
