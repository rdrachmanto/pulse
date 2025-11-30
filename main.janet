(import spork/json)

(defn try-connect [label ip port]
  (try
    (with [conn (net/connect ip port)]
      (print (string "Connected to " label " (" ip ") [port:" port "]"))
      true)
    ([err] (print "Connection refused"))))

(defn get-connections [path]
  (with [fl (file/open path :r)]
    (let [raw (file/read fl :all)
          jsond (json/decode raw true true)]
      (loop [conn :in jsond]
        (def {:label label :ip ip :port port} conn)
        (try-connect label ip port)))))

(defn main 
  "Entry point"
  [& args]
  (print "Hello world")
  (get-connections "./connections.json"))
