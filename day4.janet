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

(defn accessible? [neighbours]
  (< (length (filter |(= $ :roll) neighbours)) 4))

(defn has-roll? [grid x y]
  (= (get-cell grid x y) :roll))

(defn get-neighbours-indices [grid x y]
  (let [{:width width :height height} grid]
    (seq [i :in (range -1 2)
          j :in (range -1 2)
          :when (not (and (= i 0) (= j 0)))
          :let [xn (+ x i) yn (+ y j)]
          :when (< -1 xn width)
          :when (< -1 yn height)]
         [xn yn])))

(defn get-neighbours [grid x y]
  (map (fn [[xn yn]] (get-cell grid xn yn))
       (get-neighbours-indices grid x y)))

(defn get-accessible-cells [grid]
  (let [{:width width :height height} grid]
    (seq [x :in (range 0 width)
          y :in (range 0 height)
          :when (has-roll? grid x y)
          :let [n (get-neighbours grid x y)]
          :when (accessible? n)]
         [x y])))

(defn part-1 [grid] (length (get-accessible-cells grid)))

(defn part-2 [grid]
  (let [{:width width :height height} grid]
    (var count 0)
    (var queue (get-accessible-cells grid))
    (var queued @{})

    (each key queue
          (put queued key true))

    (while (not (empty? queue))
      (def [x y] (first queue))
      (array/remove queue 0)
      (set-cell grid x y :empty)
      (++ count)

      (loop [[xn yn] :in (get-neighbours-indices grid x y)
             :when (has-roll? grid xn yn)
             :let [key [xn yn]]
             :when (not (queued key))
             :let [n (get-neighbours grid xn yn)]
             :when (accessible? n)]
        (put queued key true)
        (array/push queue key)))

    count))

(defn main [& _]
  (def content (slurp input-path))
  (def grid (parse-input content))
  (print "Part 1: " (part-1 grid))
  (print "Part 2: " (part-2 grid)))
