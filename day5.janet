(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/5.txt"))

(def input-peg
  (peg/compile
   ~{:main   (sequence :ranges "\n" :ids -1)
     :ranges (group (some :range))
     :range  (group (sequence (number :num) "-" (number :num) (opt "\n")))
     :ids    (group (some :id))
     :id     (sequence (number :num) (opt "\n"))
     :num    (some :d)}))

(defn merge-ranges [ranges]
  (if (empty? ranges)
    @[]
    (do
      (var result @[(first ranges)])
      (each [start end] (slice ranges 1)
            (let [[prev-start prev-end] (last result)]
              (if (<= start (inc prev-end))
                (do
                  (array/pop result)
                  (array/push result [prev-start (max prev-end end)]))
                (array/push result [start end]))))
      result)))

(defn parse-input [content]
  (let [[ranges ids] (peg/match input-peg content)]
    {:ranges (->> ranges
                  (map tuple/slice)
                  sorted
                  merge-ranges
                  tuple/slice)
     :ids    (tuple/slice ids)}))

(defn fresh? [ranges n]
  (some (fn [[s e]] (<= s n e)) ranges))

(defn part-1 [{:ranges ranges :ids ids}]
  (->> ids
       (filter (partial fresh? ranges))
       (length)))

(defn part-2 [{:ranges ranges}]
  (->> ranges
       (map (fn [[s e]] (inc (- e s))))
       (sum)))

(defn main [& _]
  (def content (slurp input-path))
  (def input (parse-input content))
  (print "Part 1: " (part-1 input))
  (print "Part 2: " (part-2 input)))
