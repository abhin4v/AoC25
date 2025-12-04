(def base-path (os/getenv "AOC_INPUT_PATH"))
(def input-path (string base-path "/4.txt"))

(defn parse-input [content]
  (let [cells (->> content
                   (string/split "\n")
                   (filter (complement empty?))
                   (map (fn [line] (map |(match $ 46 :empty 64 :roll) line))))]
    {:cells cells
     :width (length (first cells))
     :height (length cells)}))

(defn get-cell [grid x y]
  (-> grid (get :cells) (in y) (in x)))

(defn set-cell [grid x y value]
  (update-in grid [:cells y x] (fn [_] value)))

(defn roll-count [neighbours]
  (length (filter |(= $ :roll) neighbours)))

(defn get-neighbours [grid x y]
  (let [{:width width :height height} grid]
    (seq [i :in (range -1 2)
          j :in (range -1 2)
          :when (not (and (= i 0) (= j 0)))
          :let [xn (+ x i) yn (+ y j)]
          :when (< -1 xn width)
          :when (< -1 yn height)]
         (get-cell grid xn yn))))

(defn part-1 [grid]
  (let [{:width width :height height} grid]
    (var count 0)
    (loop [x :in (range 0 width)
           y :in (range 0 height)
           :when (= (get-cell grid x y) :roll)
           :let [ns (get-neighbours grid x y)]]
      (when (< (roll-count ns) 4)
        (++ count)))
    count))

(defn part-2 [grid]
  (let [{:width width :height height} grid]
    (var count 0)
    (var removed true)
    (while removed
      (set removed false)
      (def to-remove
        (seq [x :in (range 0 width)
              y :in (range 0 height)
              :when (= (get-cell grid x y) :roll)
              :let [ns (get-neighbours grid x y)]
              :when (< (roll-count ns) 4)]
             [x y]))
      (each [x y] to-remove
            (set-cell grid x y :empty))
      (+= count (length to-remove))
      (set removed (not (empty? to-remove))))
    count))

(defn main [& _]
  (def content (slurp input-path))
  (def grid (parse-input content))
  (print "Part 1: " (part-1 grid))
  (print "Part 2: " (part-2 grid)))
