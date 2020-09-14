(require 'url)
(require 'json)
(require 'request)

(setf *api-key* "Enter API Key here")
(setf *base-ptc-uri* "https://api.podcastindex.org/")
(setf *api-secret* "API Secret goes here")

(defun calculate-auth-headers ()
  (let ((auth-date (format-time-string "%s")))
    `(("Accept" . "application/json")
      ("User-Agent" . "PodMacs/0.01")
      ("X-Auth-Key" . ,*api-key*)
	  ("X-Auth-Date" . ,auth-date)
	  ("Authorization" .
	   ,(secure-hash 'sha1
			(concat *api-key*
				*api-secret*
				auth-date))))))

(defun api-search (search-term)
  (let* ((api-url (concat *base-ptc-uri*
			  "api/1.0/search/byterm")))
    (cdadr (request-response-data (request (format api-url)
				    :headers (calculate-auth-headers)
				    :params `(("q" . ,search-term))
				    :encoding 'binary
				    :sync t
				    :parser 'json-read
				    :complete (print "Done"))))))

