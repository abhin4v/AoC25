(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/8.txt"))

(def input-peg
  (peg/compile
   ~{:main (sequence (some :row) -1)
     :row (group (sequence (some :num) (opt "\n")))
     :num (sequence (number :d+) (opt ","))}))

(defn parse-input [content]
  (->> (peg/match input-peg content)
       (map tuple/slice)
       tuple/slice))

(defn distance [a b]
  (var sum 0)
  (for i 0 (length a)
       (let [d (- (in a i) (in b i))] (+= sum (* d d))))
  sum)

(defn point-pairs [points]
  (def count (length points))
  (var pairs (array/new (/ (* count (dec count)) 2)))
  (for i 0 count
       (for j (inc i) count
            (let [p1 (in points i)
                  p2 (in points j)]
              (array/push pairs [p1 p2 (distance p1 p2)]))))
  (sort pairs | (< (in $0 2) (in $1 2))))

(def disjoint-set-prototype
  @{:find (fn [self i]
            (def parents (self :parents))
            (let [parent (get parents i)]
              (if (not (= (get parents parent) parent))
                (let [root (:find self parent)]
                  (put parents i root)
                  root)
                parent)))

    :union (fn [self i j]
             (def parents (self :parents))
             (def sizes (self :sizes))
             (let [i-root (:find self i)
                   j-root (:find self j)]
               (when (not (= i-root j-root))
                 (let [i-size (in sizes i-root)
                       j-size (in sizes j-root)
                       ij-size (+ i-size j-size)]
                   (if (< i-size j-size)
                     (do
                       (put parents i-root j-root)
                       (put sizes j-root ij-size))
                     (do
                       (put parents j-root i-root)
                       (put sizes i-root ij-size)))
                   (when (> ij-size (self :max-size))
                     (put self :max-size ij-size))
                   self))))})

(defn new-disjoint-set [nodes]
  (table/setproto
   @{:parents (reduce (fn [acc node] (put acc node node)) @{} nodes)
     :sizes (reduce (fn [acc node] (put acc node 1)) @{} nodes)
     :max-size 1}
   disjoint-set-prototype))

(defn part-1 [pairs]
  (def pair-count (if (= base-path "examples") 10 1000))
  (def closest-pairs (array/slice pairs 0 pair-count))
  (def points (->>
               closest-pairs
               (reduce (fn [acc [p1 p2 _]] (do (put acc p1 :t) (put acc p2 :t))) @{})
               keys))
  (def ds (new-disjoint-set points))
  (each [p1 p2 _] closest-pairs (:union ds p1 p2))
  (->> (-> (ds :sizes) values (sorted >))
       (take 3)
       product))

(defn part-2 [points pairs]
  (def points-count (length points))
  (def ds (new-disjoint-set points))
  (var prev-pair nil)
  (each [p1 p2 _] pairs
        (when (= (ds :max-size) points-count)
          (break))
        (:union ds p1 p2)
        (set prev-pair [p1 p2]))
  (let [[[x1 _ _] [x2 _ _]] prev-pair]
    (* x1 x2)))

(defn main [& _]
  (def content (slurp input-path))
  (def points (parse-input content))
  (def pairs (point-pairs points))
  (print "Part 1: " (part-1 pairs))
  (print "Part 2: " (part-2 points pairs)))
