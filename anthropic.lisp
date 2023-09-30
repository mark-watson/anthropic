(in-package #:anthropic)

;; define the environment variable "ANTHROPIC_API_KEY" with the value of your ANTHROPIC_API_KEY API key

(defvar anthropic-host "https://api.anthropic.com/v1/complete")

(defun anthropic-helper (curl-command)
  (let ((response
          (uiop:run-program
           curl-command
           :output :string)))
    ;;(princ curl-command)
    (print response)
    (with-input-from-string
        (s response)
      (let* ((json-as-list (json:decode-json s)))
        (pprint json-as-list)
        ;; extract text (this might change if OpenAI changes JSON return format):
        ;;(cadr json-as-list)))))
        (string-trim
          " "
          (cdar json-as-list))))))

(defun completions (text max-tokens)
  (let* ((curl-command
          (concatenate
           'string
           "curl --request POST --url " anthropic-host
           " -H \"accept: application/json\""
           " -H \"anthropic-version: 2023-06-01\""
           " -H \"content-type: application/json\""
           " -H \"x-api-key: " (uiop:getenv "ANTHROPIC_API_KEY") "\""
           " --data '{ \"prompt\": \"\\n\\nHuman: "
           text
           "\\n\\nAssistant: \", \"max_tokens_to_sample\": 100, \"model\": \"claude-instant-1\" }'")))
    (princ curl-command) (terpri)
    (anthropic-helper curl-command)))

#|

(print (anthropic:completions "The President went to Congress" 20))


|#
