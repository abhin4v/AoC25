(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/6.txt"))

(defn input-peg [num-entry-pattern]
  (peg/compile
   ~{:main (sequence :num-rows :op-row -1)
     :num-rows (group (some :num-row))
     :num-row (group (sequence (some :num-entry) "\n"))
     :num-entry ,num-entry-pattern
     :op-row (group (some (sequence :op (opt (some :s)))))
     :op (choice (replace "*" :mult) (replace "+" :add))}))

(defn parse-input [content num-entry-pattern]
  (let [[num-rows op-row] (peg/match (input-peg num-entry-pattern) content)]
    {:num-rows num-rows :op-row op-row}))

(defn transpose [num-rows]
  (def height (length num-rows))
  (def width (length (first num-rows)))
  (var arr (array/new width))
  (for i 0 width
       (var inner (array/new height))
       (for j 0 height
            (put inner j (get-in num-rows [j i])))
       (put arr i inner))
  arr)

(defn evaluate [op nums]
  ((match op
     :add sum
     :mult product)
   nums))

(defn part-1 [{:num-rows num-rows :op-row op-row}]
  (->> num-rows
       transpose
       (map evaluate op-row)
       sum))

(defn to-cephalopod-num [digits]
  (->> digits
       (reduce
        (fn [[acc digit-count] digit]
          (if (zero? digit)
            [acc digit-count]
            [(+ acc (* digit (math/pow 10 digit-count))) (inc digit-count)]))
        [0 0])
       first))

(defn part-2 [{:num-rows num-rows :op-row op-row}]
  (->> num-rows
       transpose
       (map (comp to-cephalopod-num reverse))
       (partition-by zero?)
       (filter |(-> $ first zero? not))
       (map evaluate op-row)
       sum))

(defn parse-input-1 [content]
  (parse-input content ~(sequence (any " ") (number :d+) (any " "))))

(defn parse-input-2 [content]
  (parse-input
   content
   ~(sequence (any (replace " " 0)) (some (number :d)) (any (replace " " 0)))))

(defn main [& _]
  (def content (slurp input-path))
  (print "Part 1: " (part-1 (parse-input-1 content)))
  (print "Part 2: " (part-2 (parse-input-2 content))))
