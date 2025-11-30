(declare-project
  :name "pulse"
  :description "Check various endpoints to see if they are accessible"
  :dependencies ["spork"])

(declare-executable
 :name "pulse"
 :entry "main.janet"
 :install true)
