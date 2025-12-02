(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/2.txt"))

(def input-peg
  (peg/compile ~{:main (sequence :ranges -1)
                 :ranges (some :range)
                 :range (group (sequence (number :num) "-" (number :num) (opt ",")))
                 :num (some :d)}))

(defn parse-input [content]
  (var matches (map tuple/slice (peg/match input-peg content)))
  (sort matches)
  (tuple/slice matches))

(defmacro in-range? [n & _]
  (def ranges (parse-input (slurp input-path)))
  ~(or ,;(map (fn [[s e]] ~(<= ,s ,n ,e)) ranges)))

(defn multiple-digits [n k digit-power]
  (var sum 0)
  (for i 0 k
       (set sum (+ (* digit-power sum) n)))
  sum)

(defn part-1 [input]
  (def limit (last (last input)))
  (var i 1)
  (var digit-power 10)
  (var n (multiple-digits i 2 digit-power))
  (var sum 0)
  (while (<= n limit)
    (when (in-range? n input)
      (set sum (+ sum n)))
    (++ i)
    (when (>= i digit-power)
      (set digit-power (* digit-power 10)))
    (set n (multiple-digits i 2 digit-power)))
  sum)

(defn part-2 [input]
  (def limit (last (last input)))
  (var sum 0)
  (var multiple 2)
  (var seen @{})
  (while (<= (multiple-digits 1 multiple 10) limit)
    (var i 1)
    (var digit-power 10)
    (var n (multiple-digits i multiple digit-power))
    (while (<= n limit)
      (when (and (not (get seen n)) (in-range? n input))
        (put seen n true)
        (set sum (+ sum n)))
      (++ i)
      (when (>= i digit-power)
        (set digit-power (* digit-power 10)))
      (set n (multiple-digits i multiple digit-power)))
    (++ multiple))
  sum)

(defn main [& _]
  (def content (slurp input-path))
  (def input (parse-input content))
  (print "Part 1: " (part-1 input))
  (print "Part 2: " (part-2 input)))
