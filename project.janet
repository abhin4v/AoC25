(declare-project
  :name "aoc25"
  :description "Advent of Code 2025 Solutions in Janet"
  :author "Abhinav Sarkar"
  :license "MIT"
  :url "https://github.com/abhin4v/AoC25.git"
  :version "0.1.0"
  :min-version "1.39.0"
  :dependencies [])

(loop [day :range [1 9]]
  (eval ~(declare-executable
           :name ,(string "day" day)
           :entry ,(string "day" day ".janet"))))
