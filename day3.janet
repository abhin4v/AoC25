(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/3.txt"))

(defn parse-input [content]
  (filter (fn [line] (not (empty? line))) (string/split "\n" content)))

(defn max-subsequence [k input-str]
  (def memo @{})

  (defn- max-subsequence-impl [k str]
    (cond
      (= k 0) [0 0]
      (empty? str) [0 0]
      (do
        (def key [k str])
        (if (has-key? memo key)
          (get memo key)
          (do
            (def digit (- (first str) 48))
            (def rest-str (string/slice str 1))
            (def [av al] (max-subsequence-impl (- k 1) rest-str))
            (def [bv bl] (max-subsequence-impl k rest-str))
            (def av-prime (+ (* digit (math/pow 10 al)) av))
            (def result (if (> av-prime bv) [av-prime (+ al 1)] [bv bl]))
            (put memo key result)
            result)))))

  (first (max-subsequence-impl k input-str)))

(defn solve [k input]
  (var total 0)
  (each line input (+= total (max-subsequence k line)))
  total)

(defn main [& _]
  (def content (slurp input-path))
  (def input (parse-input content))
  (print "Part 1: " (solve 2 input))
  (print "Part 2: " (solve 12 input)))
