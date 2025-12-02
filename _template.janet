(defn parse-input [content]
  (string/split "\n" content))

(defn part-1 [input]
  nil)

(defn part-2 [input]
  nil)

(defn main [& _]
  (def input-path (string (os/getenv "AOC_INPUT_PATH") "/N.txt"))
  (def content (slurp input-path))
  (def input (parse-input content))
  (print "Part 1: " (part-1 input))
  (print "Part 2: " (part-2 input)))
