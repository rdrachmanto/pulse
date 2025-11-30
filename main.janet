(defn try-connect []
  (try
    (with [conn (net/connect "127.0.0.1" "8000")]
      (print (string "Connected to " conn))
      true)
    ([err] (print "Connection refused"))
    ))

(defn main 
  "Entry point"
  [& args]
  (print "Hello world")
  (try-connect))
