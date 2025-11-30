(import spork/json)
(import spork/argparse :prefix "")

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

(def ap
  ["Check if a service is reachable or online"
   "input" {:kind :option
            :required true
            :help "The input json file with a list of objects containing `ip`, `label` and `host` key"}])

(defn main
  "Entry point for pulse"
  [& args]
  (let [res (argparse ;ap)]
    # unless res has some contents inside it, break.
    # This targets empty commands and --help
    (unless (res (break))) 
    (get-connections (res "input"))))
