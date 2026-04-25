;;; vulpea-capf.el --- Completion-at-point for vulpea note links -*- lexical-binding: t; -*-

;; Drop-in replacement for the custom org-roam corfu function you had before.
;; Type a word/phrase anywhere in an org buffer, and if it matches a vulpea
;; note title or alias, corfu will offer it; selecting it inserts a proper
;; [[id:...][Title]] link.

;;; --- Candidate building -----------------------------------------------

(defvar rr/vulpea-capf--cache nil
  "Cached list of candidate strings for `rr/vulpea-capf'.
Rebuilt lazily; invalidated by `rr/vulpea-capf--invalidate-cache'.")

(defun rr/vulpea-capf--build-candidates ()
  "Build completion candidates from all vulpea notes.
Each candidate is a propertized string carrying `vulpea-id' (and,
for aliases, `vulpea-title' holding the canonical title)."
  (let (candidates)
    (dolist (note (vulpea-db-query (lambda (_) t)))
      (let ((id (vulpea-note-id note))
            (title (vulpea-note-title note)))
        (push (propertize title 'vulpea-id id) candidates)
        (dolist (alias (vulpea-note-aliases note))
          (push (propertize alias 'vulpea-id id 'vulpea-title title)
                candidates))))
    (nreverse candidates)))

(defun rr/vulpea-capf--candidates ()
  "Return cached candidates, building them if necessary."
  (or rr/vulpea-capf--cache
      (setq rr/vulpea-capf--cache (rr/vulpea-capf--build-candidates))))

(defun rr/vulpea-capf--invalidate-cache (&rest _)
  "Drop the candidate cache so it's rebuilt on next completion."
  (setq rr/vulpea-capf--cache nil))

;; Vulpea's database updates asynchronously via file watchers (autosync).
;; Invalidate the cache whenever a sync happens, so new/renamed notes show
;; up without a manual refresh. Adjust hook name if your vulpea version
;; exposes a different sync-completion hook - check vulpea-db-sync.el if
;; this doesn't fire for you.
(with-eval-after-load 'vulpea-db-sync
  (advice-add 'vulpea-db-sync-update-file :after #'rr/vulpea-capf--invalidate-cache)
  (advice-add 'vulpea-db-sync-full-scan :after #'rr/vulpea-capf--invalidate-cache))

;;; --- The CAPF itself -----------------------------------------------------

(defun rr/vulpea-capf ()
  "Completion-at-point function for vulpea note titles/aliases."
  (when (and (thing-at-point 'symbol)
             (not (org-in-src-block-p))
             (not (save-match-data (org-in-regexp org-link-any-re))))
    (let ((bounds (bounds-of-thing-at-point 'symbol)))
      (list (car bounds) (cdr bounds)
            (rr/vulpea-capf--candidates)
            :exclusive 'no
            :company-kind (lambda (_) 'reference)
            :exit-function
            (lambda (text _status)
              (let* ((id (get-text-property 0 'vulpea-id text))
                     (title (or (get-text-property 0 'vulpea-title text) text)))
                (when id
                  (delete-char (- (length text)))
                  (insert (format "[[id:%s][%s]]" id title)))))))))

;;; --- Wiring into org-mode + corfu -----------------------------------------

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'completion-at-point-functions #'rr/vulpea-capf nil t)))

(provide 'vulpea-capf)
;;; vulpea-capf.el ends here
