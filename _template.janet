(defn parse-input [content]
  (string/split "\n" content))

(defn part-1 [input]
  nil)

(defn part-2 [input]
  nil)

(defn main [& args]
  (when (< (length args) 2)
    (error "Usage: janet dayN.janet <filename>"))
  (def filename (get args 1))
  (def content (slurp filename))
  (def input (parse-input content))
  (print "Part 1: " (part-1 input))
  (print "Part 2: " (part-2 input)))
