(import spork/json)

(defn try-connect [label ip port]
  (try
    (ev/with-deadline 2
      (with [conn (net/connect ip port)]
        (print (string "Connected to " label " (" ip ") [port:" port "]"))
        true))
    ([err] (print "Connection to " label " refused"))))

(defn try-connect-loop [label ip port retries]
  (for i 0 retries
    (let [ok (try-connect label ip port)]
      (when ok (break ok)))
    (when (< i retries)
      (print "Retrying..."))))

(defn get-connections [path]
  (with [fl (file/open path :r)]
    (let [raw (file/read fl :all)
          jsond (json/decode raw true true)]
      (loop [conn :in jsond]
        (def {:label label :ip ip :port port} conn)
        (try-connect-loop label ip port 3)))))

(defn main
  "Entry point"
  [& args]
  (print "Hello world")
  (get-connections "./connections.json"))
