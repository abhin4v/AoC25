(import ../day9 :as day9)

# (def example-content (slurp "examples/9.txt"))
# (def example-input (day9/parse-input example-content))

# (assert (= (day9/part-1 example-input) EXPECTED_PART1))
# (assert (= (day9/part-2 example-input) EXPECTED_PART2))

# Tests for inside-polygon? function

# Simple square polygon (0,0) to (2,2)
(def square [[0 0] [2 0] [2 2] [0 2]])

# Points clearly inside the square
(assert (day9/inside-polygon? square [1 1]) "center of square")
(assert (day9/inside-polygon? square [0.5 0.5]) "corner region inside square")
(assert (day9/inside-polygon? square [1.5 1.5]) "near opposite corner")

# Points on the vertices (should be inside)
(assert (day9/inside-polygon? square [0 0]) "on vertex [0 0]")
(assert (day9/inside-polygon? square [2 0]) "on vertex [2 0]")
(assert (day9/inside-polygon? square [2 2]) "on vertex [2 2]")
(assert (day9/inside-polygon? square [0 2]) "on vertex [0 2]")

# Points on the edges (should be inside)
(assert (day9/inside-polygon? square [1 0]) "on edge between [0 0] and [2 0]")
(assert (day9/inside-polygon? square [2 1]) "on edge between [2 0] and [2 2]")
(assert (day9/inside-polygon? square [1 2]) "on edge between [2 2] and [0 2]")
(assert (day9/inside-polygon? square [0 1]) "on edge between [0 2] and [0 0]")

# Points clearly outside the square
(assert (not (day9/inside-polygon? square [-1 1])) "left of square")
(assert (not (day9/inside-polygon? square [3 1])) "right of square")
(assert (not (day9/inside-polygon? square [1 -1])) "below square")
(assert (not (day9/inside-polygon? square [1 3])) "above square")
(assert (not (day9/inside-polygon? square [-1 -1])) "far corner outside")

# Triangle polygon
(def triangle [[0 0] [4 0] [2 3]])

# Points inside triangle
(assert (day9/inside-polygon? triangle [2 1]) "center-ish of triangle")
(assert (day9/inside-polygon? triangle [1 0.5]) "near base of triangle")
(assert (day9/inside-polygon? triangle [3 0.5]) "near base right of triangle")

# Points outside triangle
(assert (not (day9/inside-polygon? triangle [0 1])) "left of triangle")
(assert (not (day9/inside-polygon? triangle [4 1])) "right of triangle")
(assert (not (day9/inside-polygon? triangle [2 4])) "above triangle")
(assert (not (day9/inside-polygon? triangle [2 -1])) "below triangle")

# Pentagon polygon (regular-ish)
(def pentagon [[1 0] [3 1] [3 3] [1 3] [0 1]])

# Points inside pentagon
(assert (day9/inside-polygon? pentagon [1.5 1.5]) "center region of pentagon")
(assert (day9/inside-polygon? pentagon [2 1.5]) "right of center in pentagon")

# Points outside pentagon
(assert (not (day9/inside-polygon? pentagon [0 0])) "corner outside pentagon")
(assert (not (day9/inside-polygon? pentagon [4 2])) "right outside pentagon")

# Concave polygon (L-shape)
(def concave [[0 0] [3 0] [3 1] [1 1] [1 3] [0 3]])

# Points inside concave polygon
(assert (day9/inside-polygon? concave [0 0]) "on corner of L")
(assert (day9/inside-polygon? concave [2 0]) "inside bottom of L")
(assert (day9/inside-polygon? concave [0 2]) "inside top-left of L")

# Points in the concave indent (should be outside)
(assert (not (day9/inside-polygon? concave [2 2])) "in the indent of L-shape")
(assert (not (day9/inside-polygon? concave [3 2])) "in the indent right side")

# Points outside concave polygon
(assert (not (day9/inside-polygon? concave [-1 1])) "left outside")
(assert (not (day9/inside-polygon? concave [4 1])) "right outside")
