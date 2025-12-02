(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/N.txt"))

(defn parse-input [content]
  (string/split "\n" content))

(defn part-1 [input]
  nil)

(defn part-2 [input]
  nil)

(defn main [& _]
  (def content (slurp input-path))
  (def input (parse-input content))
  (print "Part 1: " (part-1 input))
  (print "Part 2: " (part-2 input)))
