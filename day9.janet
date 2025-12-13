(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/9.txt"))

(def input-peg
  (peg/compile
   ~{:main (sequence (some :row) -1)
     :row  (group (sequence (some :num) (opt "\n")))
     :num  (sequence (number :d+) (opt ","))}))

(defn parse-input [content]
  (->> (peg/match input-peg content)
       (map tuple/slice)
       tuple/slice))

(defn area [[x1 y1] [x2 y2]]
  (* (inc (math/abs (- x2 x1))) (inc (math/abs (- y2 y1)))))

(defn point-pairs [points]
  (def count (length points))
  (var pairs (array/new (/ (* count (dec count)) 2)))
  (for i 0 count
       (for j (inc i) count
            (let [p1 (in points i)
                  p2 (in points j)]
              (array/push pairs [p1 p2 (area p1 p2)]))))
  (sort pairs | (> (in $0 2) (in $1 2))))

(defn part-1 [input]
  (-> input
      point-pairs
      (in 0)
      (in 2)))

(defn inside-polygon? [polygon p]
  (label result
         (do
           (def vertices-count (length polygon))
           (var inside false)
           (var p1 (in polygon 0))
           (var p2 nil)

           (for i 1 (inc vertices-count)
                (set p2 (in polygon (% i vertices-count)))
                #point on corner
                (when (or (= p p1) (= p p2))
                  (return result :c))
                (let [[x y] p
                      [x1 y1] p1
                      [x2 y2] p2]
                  #point on horizontal edge
                  (when (and (= y y1 y2) (<= (min x1 x2) x (max x1 x2)))
                    (return result :h))
                  (when (<= (min y1 y2) y (max y1 y2))
                    #point on verticle edge
                    (when (= x x1 x2)
                      (return result :v))
                    (when (<= x (max x1 x2))
                      (pp [y1 y2])
                      (let [x-inter (+ (/ (* (- y y1) (- x2 x1)) (- y2 y1)) x1)]
                        (when (or (= x1 x2) (<= x x-inter))
                          (set inside (not inside)))))))
                (pp [p1 p2 inside])
                (set p1 p2))

           inside)))

(defn other-pair [[x1 y1] [x2 y2]]
  (if (or (= x1 x2) (= y1 y2))
    []
    [[x1 y2] [x2 y1]]))

(defn part-2 [polygon]
  (def pairs (point-pairs polygon))

  (find
   (fn [[p1 p2 _]]
     (let [opp-pair (other-pair p1 p2)]
       (and (all (partial inside-polygon? polygon) [p1 p2])
            (all (partial inside-polygon? polygon) opp-pair))))
   pairs))

(defn main [& _]
  (def content (slurp input-path))
  (def input (parse-input content))
  (print "Part 1: " (part-1 input))
  (print "Part 2: " (pp (part-2 input))))
