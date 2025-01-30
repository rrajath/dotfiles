;;; private-config.el --- DESCRIPTION -*- lexical-binding: t; -*- 
(setq user-full-name "Rajath Ramakrishna"
      user-mail-address "r.rajath@pm.me")

;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;;  (setq gc-cons-threshold (* 50 1000 1000))

(defun rr/display-startup-time ()
  "Displays startup time in the echo buffer and Messages buffer as
    soon as Emacs loads."
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'rr/display-startup-time)

(use-package no-littering)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(straight-use-package 'org)

(setq rr-org-mode-dir "~/Library/CloudStorage/Dropbox/org-mode")
(setq rr-org-roam-dir "~/Library/CloudStorage/Dropbox/org-roam")
(setq initial-major-mode #'lisp-interaction-mode)

(setq my-fixed-pitch-font "JetBrains Mono")
(setq my-variable-pitch-font "SN Pro")

(defun rr/set-font-faces ()
  (message "Setting font faces!")
  (set-face-attribute 'default nil :font "JetBrains Mono" :height 125)
  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil
                      :font my-fixed-pitch-font
                      :height 170
                      :weight 'light)

  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil
                      :font my-variable-pitch-font
                      :height 150
                      :weight 'regular))

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (setq doom-modeline-icon t)
                (with-selected-frame frame (rr/set-font-faces))))
  (rr/set-font-faces))

(use-package nerd-icons
  :vc (:url "https://github.com/rainstormstudio/nerd-icons.el")
  :custom
  (set-fontset-font t 'symbol "Symbols Nerd Font Mono" nil 'prepend)
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  (nerd-icons-scale-factor 1.15))

(use-package doom-modeline
  :after nerd-icons
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30))

(use-package catppuccin-theme)
(setq catppuccin-flavor 'mocha)
(catppuccin-reload)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-molokai t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme
  ;; (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package all-the-icons)

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (select-frame frame)
                (load-theme 'catppuccin t)))
  (load-theme 'catppuccin t))

(use-package rainbow-delimiters
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package avy
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))

(use-package hungry-delete
  :defer 2
  :config
  (setq hungry-delete-join-reluctantly t))
(global-hungry-delete-mode)

(defun rr/revert-buffer-no-confirm ()
  "Revert the buffer, but don't ask for confirmation"
  (interactive)
  (revert-buffer nil t nil))

(require 'mm-url) ; to include mm-url-decode-entities-string

(defun rr/org-insert-html-link ()
  "Insert org link where default description is set to html title."
  (interactive)
  (let* ((url (read-string "URL: "))
         (title (rr/get-html-title-from-url url)))
    (org-insert-link nil url title)))

(defun rr/get-html-title-from-url (url)
  "Return content in <title> tag."
  (let (x1 x2 (download-buffer (url-retrieve-synchronously url)))
    (save-excursion
      (set-buffer download-buffer)
      (beginning-of-buffer)
      (setq x1 (search-forward "<title>"))
      (search-forward "</title>")
      (setq x2 (search-backward "<"))
      (mm-url-decode-entities-string (buffer-substring-no-properties x1 x2)))))

(use-package highlight-symbol
  :config
  (set-face-attribute 'highlight-symbol-face nil
                      :background (face-background 'default)
                      :foreground "#48E5C2") ;original: #FA009A, DE7C5A
  (setq highlight-symbol-idle-delay 0)
  (setq highlight-symbol-on-navigation-p t)
  (add-hook 'prog-mode-hook #'highlight-symbol-mode)
  (add-hook 'prog-mode-hook #'highlight-symbol-nav-mode))

(use-package embark
  :ensure t

  :bind
  (("C-," . embark-act)         ;; pick some comfortable binding
   ("C-M-," . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  (keymap-set minibuffer-local-map "M-k" "C-. k y")
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package embrace
  :defer t)
(global-set-key (kbd "C-.") #'embrace-commander)
(add-hook 'org-mode-hook #'embrace-org-mode-hook)

(defun rr/pulse-line (_)
  (pulse-momentary-highlight-one-line (point)))
(setq window-selection-change-functions '(rr/pulse-line))

(use-package drag-stuff
  :defer 2
  :config
  (drag-stuff-global-mode t))

(defun rr/beginning-of-line ()
  "Go to beginning of line or to first non-whitespace character
depending on current position of point"
  (interactive)
  (if (= 0 (current-column))
      (back-to-indentation)
    (beginning-of-line)))

(defun rr/delete-lines ()
  (interactive)
  (if (region-active-p)
      (delete-region (region-beginning) (region-end))
    (progn
      (beginning-of-line)
      (kill-line)
      (delete-forward-char 1))))

(use-package popper
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "^\\*Warnings\\*"
          "^\\*IBuffer\\*"
          "^\\*Compile-Log\\*"
          "^\\*Backtrace\\*"
          "[Oo]utput\\*$"
          "\\*Help\\*"
          "\\*helpful\\*"
          "\\*Excorporate\\*"
          "\\*xref\\*"
          eat-mode
          help-mode
          helpful-mode
          compilation-mode
          org-roam-mode
          term-mode))
  (popper-mode +1))

(defun rr/lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
        (funcall (plist-get (car result) :secret))
      nil)))

(use-package ultra-scroll
  :vc (:url "https://github.com/jdtsmith/ultra-scroll")
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0) 
  :config
  (ultra-scroll-mode 1))

(use-package auto-capitalize
  :vc (:url "https://github.com/yuutayamada/auto-capitalize-el")
  :hook (org-mode-hook . auto-capitalize-mode)
  :custom
  (auto-capitalize-mode 1))
(setq auto-capitalize-words `("I" "English" "I've" "I'll" "I'd" "I'm"))

(use-package yasnippet
  :defer t
  :hook ((text-mode
          prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on)
  :config
  (yas-reload-all))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-emoji))

(use-package jinx
  :custom
  (dolist (hook '(org-mode-hook) prog-mode-hook conf-mode-hook))
  (add-hook hook #'jinx-mode))

;; Set up a global idle timer to save all org buffers when Emacs is idle for 5 seconds
(run-with-idle-timer 5 t #'org-save-all-org-buffers)

(setq which-key-idle-delay 0.3)
(setq which-key-max-description-length 100)
(global-visual-line-mode)

(setq electric-pair-preserve-balance nil)

(global-set-key (kbd "C-M-j") 'consult-buffer)

(keymap-global-set "C-w" 'backward-kill-word)
(keymap-global-set "C-s" 'save-buffer)
(keymap-global-set "s-[" 'tab-previous)
(keymap-global-set "s-]" 'tab-next)
(keymap-global-set "s-r" 'rr/revert-buffer-no-confirm)
(keymap-global-set "M-o" 'completion-at-point)
(keymap-global-set "M-y" 'consult-yank-pop)
(keymap-global-set "C-a" 'rr/beginning-of-line)
(keymap-global-set "s-d" 'rr/delete-lines)
(keymap-global-set "C-'" 'next-window-any-frame)
(keymap-global-set "C-u" 'rr/ultra-scroll-up)
(keymap-global-set "C-d" 'rr/ultra-scroll-down)
(keymap-global-set "s-/" 'comment-line)
(keymap-global-set "s-<up>" 'beginning-of-buffer)
(keymap-global-set "s-<down>" 'end-of-buffer)
(keymap-global-set "M-<up>" 'drag-stuff-up)
(keymap-global-set "M-<down>" 'drag-stuff-down)
(keymap-global-set "C-;" 'popper-kill-latest-popup)
(keymap-global-set "M-RET" 'org-insert-item)
(keymap-global-set "C-S-u" 'universal-argument)
(keymap-global-set "s-t" 'activities-resume)

(defun rr/meow-insert-at-start ()
  (interactive)
  (beginning-of-line)
  (meow-insert-mode))

(defun rr/meow-insert-at-end ()
  (interactive)
  (end-of-line)
  (meow-insert-mode))

(defun rr/meow-paste-before ()
  (interactive)
  (meow-open-above)
  (beginning-of-line)
  (meow-yank)
  (meow-normal-mode))

(defun rr/meow-delete-char-or-region ()
  (interactive)
  (cond
   ((equal mark-active t)
     (delete-region (region-beginning) (region-end)))
   ((equal mark-active nil)
    (delete-char 1))))

(defun rr/copy-line ()
  (interactive)
  (save-excursion
    (back-to-indentation)
    (kill-ring-save
     (point)
     (line-end-position)))
  (message "1 line copied"))

(defun rr/meow-save ()
  (interactive)
  (cond
   ((org-at-heading-p)
    (org-copy-subtree))
   ((equal mark-active t)
    (meow-save))
   ((equal mark-active nil)
    (rr/copy-line))))

(defun rr/ultra-scroll-up ()
  (interactive)
  (ultra-scroll-up (- (/ (window-pixel-height) 2) 30)))

(defun rr/ultra-scroll-down ()
  (interactive)
  (ultra-scroll-down (- (/ (window-pixel-height) 2) 30)))

(defun consult-info-emacs ()
  "Search through Emacs info pages."
  (interactive)
  (consult-info "emacs" "efaq" "elisp" "cl" "compat" "eat" "corfu" "eglot" "magit"))

(setq meow-org-motion-keymap (make-keymap))
(meow-define-state org-motion
  "Org-mode structural motion"
  :lighter "[O]"
  :keymap meow-org-motion-keymap)

(meow-define-keys 'org-motion
  '("<escape>" . meow-normal-mode)
  '("i" . meow-insert-mode)
  '("g" . meow-normal-mode)
  '("u" .  meow-undo)
  ;; Moving between headlines
  '("k" .  org-previous-visible-heading)
  '("j" .  org-next-visible-heading)
  ;; Moving between headings at the same level
  '("p" .  org-backward-heading-same-level)
  '("n" .  org-forward-heading-same-level)
  ;; Moving subtrees themselves
  '("K" .  org-subtree-up)
  '("J" .  org-subtree-down)
  ;; Subtree de/promotion
  '("L" .  org-demote-subtree)
  '("H" .  org-promote-subtree)
  ;; Completion-style search of headings
  '("v" .  consult-org-heading)
  ;; Setting subtree metadata
  '("L" .  org-set-property)
  '("t" .  org-todo)
  '("D" .  org-deadline)
  '("S" .  org-schedule)
  '("E" .  org-set-effort)
  ;; Block navigation
  '("B" .  org-previous-block)
  '("F" .  org-next-block)
  ;; Narrowing/widening
  '("N" .  org-narrow-to-subtree)
  '("W" .  widen))

(defvar meow-nav-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "h") #'beginning-of-line)
    (define-key keymap (kbd "l") #'end-of-line)
    (define-key keymap (kbd "g") #'beginning-of-buffer)
    (define-key keymap (kbd "e") #'end-of-buffer)
    (define-key keymap (kbd "s") #'back-to-indentation)
    (define-key keymap (kbd "y") #'eglot-find-typeDefinition)
    (define-key keymap (kbd "i") #'eglot-find-implementation)
    (define-key keymap (kbd "O") #'meow-org-motion-mode)
    keymap))

;; define an alias for your keymap
(defalias 'meow-nav-keymap meow-nav-keymap)
;;  (global-set-key (kbd "C-x C-w") 'nav-keymap)
;;                              ^ note the quote

(defvar meow-activities-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "a") #'activities-resume)
    (define-key keymap (kbd "b") #'activities-switch-buffer)
    (define-key keymap (kbd "d") #'activities-define)
    (define-key keymap (kbd "g") #'activities-revert)
    (define-key keymap (kbd "k") #'activities-kill)
    (define-key keymap (kbd "l") #'activities-list)
    (define-key keymap (kbd "m") #'activities-switch)
    (define-key keymap (kbd "n") #'activities-new)
    (define-key keymap (kbd "s") #'activities-suspend)
    keymap))

;; define an alias for your keymap
(defalias 'meow-activities-keymap meow-activities-keymap)

(defvar meow-persp-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "s") #'persp-switch)
    (define-key keymap (kbd "b") #'persp-switch-to-buffer)
    (define-key keymap (kbd "k") #'persp-kill)
    (define-key keymap (kbd "r") #'persp-rename)
    keymap))

;; define an alias for your keymap
(defalias 'meow-persp-keymap meow-persp-keymap)

(defvar meow-buffer-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "k") #'kill-buffer)
    (define-key keymap (kbd "r") #'rr/revert-buffer-no-confirm)
    (define-key keymap (kbd "R") #'revert-buffer)
    (define-key keymap (kbd "i") #'ibuffer)
    (define-key keymap (kbd "o") #'centaur-tabs-kill-other-buffers-in-current-group)
    keymap))

;; define an alias for your keymap
(defalias 'meow-buffer-keymap meow-buffer-keymap)

(defvar meow-help-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "f") #'describe-function)
    (define-key keymap (kbd "v") #'describe-variable)
    (define-key keymap (kbd "c") #'describe-key-briefly)
    (define-key keymap (kbd "a") #'apropos-command)
    (define-key keymap (kbd "b") #'describe-bindings)
    keymap))

;; define an alias for your keymap
(defalias 'meow-help-keymap meow-help-keymap)

(defvar meow-dired-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "d") #'dired)
    (define-key keymap (kbd "j") #'dired-jump)
    (define-key keymap (kbd "J") #'dired-jump-other-window)
    (define-key keymap (kbd "n") #'dired-create-empty-file)
    keymap))

;; define an alias for your keymap
(defalias 'meow-dired-keymap meow-dired-keymap)

(defvar meow-window-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "v") #'split-window-right)
    (define-key keymap (kbd "h") #'split-window-below)
    (define-key keymap (kbd "c") #'delete-window)
    (define-key keymap (kbd "w") #'next-window-any-frame)
    keymap))

;; define an alias for your keymap
(defalias 'meow-window-keymap meow-window-keymap)

(defvar meow-file-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "f") #'find-file)
    (define-key keymap (kbd "r") #'consult-recent-file)
    (define-key keymap (kbd "p") #'projectile-find-file)
    keymap))

;; define an alias for your keymap
(defalias 'meow-file-keymap meow-file-keymap)

(defvar meow-org-checklist-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "x") #'org-toggle-checkbox)
    (define-key keymap (kbd "s") #'rr/org-sort-list-by-checkbox-type)
    (define-key keymap (kbd "S") #'org-sort)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-checklist-keymap meow-org-checklist-keymap)

(defvar meow-org-clock-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "i") #'org-clock-in)
    (define-key keymap (kbd "o") #'org-clock-out)
    (define-key keymap (kbd "c") #'org-clock-cancel)
    (define-key keymap (kbd "d") #'org-clock-display)
    (define-key keymap (kbd "g") #'org-clock-goto)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-clock-keymap meow-org-clock-keymap)

(defvar meow-org-narrow-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "s") #'org-narrow-to-subtree)
    (define-key keymap (kbd "b") #'org-narrow-to-block)
    (define-key keymap (kbd "e") #'org-narrow-to-element)
    (define-key keymap (kbd "r") #'org-narrow-to-region)
    (define-key keymap (kbd "w") #'widen)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-narrow-keymap meow-org-narrow-keymap)

(defvar meow-org-deadline-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "s") #'org-schedule)
    (define-key keymap (kbd "d") #'org-deadline)
    (define-key keymap (kbd "t") #'org-time-stamp)
    (define-key keymap (kbd "T") #'org-time-stamp-inactive)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-deadline-keymap meow-org-deadline-keymap)

(defvar meow-org-link-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "l") #'org-insert-link)
    (define-key keymap (kbd "v") #'crux-view-url)
    (define-key keymap (kbd "s") #'org-store-link)
    (define-key keymap (kbd "h") #'rr/org-insert-html-link)
    (define-key keymap (kbd "d") #'rr/org-insert-link-dwim)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-link-keymap meow-org-link-keymap)

(defvar meow-org-toggle-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "h") #'org-toggle-heading)
    (define-key keymap (kbd "i") #'org-toggle-item)
    (define-key keymap (kbd "x") #'org-toggle-checkbox)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-toggle-keymap meow-org-toggle-keymap)

(defvar meow-org-refile-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "r") #'org-refile)
    (define-key keymap (kbd "c") #'org-refile-copy)
    (define-key keymap (kbd ".") #'+org/refile-to-current-file)
    (define-key keymap (kbd "A") #'org-archive-subtree)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-refile-keymap meow-org-refile-keymap)

(defvar meow-org-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "x") #'meow-org-checklist-keymap)
    (define-key keymap (kbd "c") #'meow-org-clock-keymap)
    (define-key keymap (kbd "r") #'meow-org-refile-keymap)
    (define-key keymap (kbd "n") #'meow-org-narrow-keymap)
    (define-key keymap (kbd "d") #'meow-org-deadline-keymap)
    (define-key keymap (kbd "l") #'meow-org-link-keymap)
    (define-key keymap (kbd "t") #'meow-org-toggle-keymap)
    (define-key keymap (kbd "N") #'org-add-note)
    (define-key keymap (kbd "o") #'consult-outline)
    (define-key keymap (kbd "q") #'org-set-tags-command)
    (define-key keymap (kbd "e") #'org-export-dispatch)
    (define-key keymap (kbd "a") #'org-agenda)
    keymap))

;; define an alias for your keymap
(defalias 'meow-org-keymap meow-org-keymap)

(defvar meow-avy-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "j") #'avy-goto-char)
    (define-key keymap (kbd "w") #'avy-goto-word-1)
    (define-key keymap (kbd "l") #'avy-goto-line)
    keymap))

;; define an alias for your keymap
(defalias 'meow-avy-keymap meow-avy-keymap)

(defvar meow-project-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "f") #'consult-project-extra-find)
    (define-key keymap (kbd "D") #'project-find-dir)
    (define-key keymap (kbd "d") #'project-dired)
    (define-key keymap (kbd "m") #'magit-project-status)
    (define-key keymap (kbd "k") #'project-kill-buffers)
    (define-key keymap (kbd "s") #'project-switch-project)
    (define-key keymap (kbd "c") #'consult-project-buffer)
    (define-key keymap (kbd "/") #'consult-ripgrep)
    (define-key keymap (kbd "t") #'eat-project-other-window)
    keymap))

;; define an alias for your keymap
(defalias 'meow-project-keymap meow-project-keymap)

(defvar meow-eglot-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "a") #'eglot-code-actions)
    (define-key keymap (kbd "f") #'project-find-file)
    (define-key keymap (kbd "n") #'flymake-goto-next-error)
    (define-key keymap (kbd "p") #'flymake-goto-prev-error)
    (define-key keymap (kbd "s") #'flymake-show-project-diagnostics)
    (define-key keymap (kbd "r") #'eglot-rename)
    (define-key keymap (kbd "R") #'eglot-reconnect)
    (define-key keymap (kbd "c") #'consult-flymake)
    (define-key keymap (kbd ">") #'diff-hl-next-hunk)
    (define-key keymap (kbd "<") #'diff-hl-previous-hunk)
    keymap))

;; define an alias for your keymap
(defalias 'meow-eglot-keymap meow-eglot-keymap)

(defvar meow-highlight-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "t") #'highlight-symbol-mode)
    (define-key keymap (kbd "n") #'highlight-symbol-next)
    (define-key keymap (kbd "p") #'highlight-symbol-prev)
    (define-key keymap (kbd "r") #'highlight-symbol-remove-all)
    (define-key keymap (kbd "c") #'highlight-symbol-count)
    keymap))

;; define an alias for your keymap
(defalias 'meow-highlight-keymap meow-highlight-keymap)

(defvar meow-util-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "r") #'restart-emacs)
    (define-key keymap (kbd "h") #'meow-highlight-keymap)
    (define-key keymap (kbd "g") #'magit-status)
    (define-key keymap (kbd "G") #'git-link)
    (define-key keymap (kbd "k") #'magit-discard)
    (define-key keymap (kbd "f") #'free-keys)
    (define-key keymap (kbd "w") #'writegood-mode)
    (define-key keymap (kbd "p") #'popper-toggle)
    (define-key keymap (kbd "l") #'consult-goto-line)
    keymap))

;; define an alias for your keymap
(defalias 'meow-util-keymap meow-util-keymap)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (setq meow-selection-command-fallback
        '((meow-change . meow-change-char)
          (meow-kill . meow-c-k)
          ;; (meow-kill . meow-delete)
          ;; (meow-cancel-selection . keyboard-quit)
          (meow-cancel-selection . ignore)
          (meow-pop-selection . meow-pop-grab)
          (meow-beacon-change . meow-beacon-change-char)))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("`" . meow-last-buffer)
   '("RET" . consult-bookmark)
   '("a" . meow-activities-keymap)
   '("b" . meow-buffer-keymap)
   '("h" . meow-help-keymap)  
   '("s" . meow-persp-keymap)
   '("d" . meow-dired-keymap)
   '("j" . meow-avy-keymap)
   '("f" . meow-file-keymap)
   '("l" . meow-eglot-keymap)
   '("p" . meow-project-keymap)
   '("u" . meow-util-keymap)
   '("w" . meow-window-keymap)
   '("o" . meow-org-keymap)
   '("/" . meow-keypad-describe-key)
   '("z" . scratch-buffer)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("/" . consult-line)
   '("M-s i" . consult-info-emacs)
   '("RET" . +org/dwim-at-point)
   ;; '("TAB" . +org-cycle-only-current-subtree-h)
   ;; '("C-n" . rr/org-show-next-heading-tidily)
   ;; '("C-p" . rr/org-show-previous-heading-tidily)
   '("t" . org-todo)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . rr/meow-insert-at-end)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . rr/meow-delete-char-or-region)
   '("D" . meow-backward-delete)
   '("e" . meow-block)
   '("E" . meow-to-block)
   '("f" . meow-find)
   '("F" . eglot-code-actions)
   '("g" . meow-nav-keymap)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . rr/meow-insert-at-start)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-search)
   '("N" . flymake-goto-next-error)
   '("o" . meow-open-below)
   '("O" . meow-open-above)
   '("p" . meow-yank)
   '("P" . rr/meow-paste-before)
   '("Q" . avy-goto-char)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . cua-delete-region)
   '("T" . meow-till)
   '("u" . undo)
   '("U" . undo-redo)
   '("v" . meow-visit)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . meow-line)
   '("X" . org-capture)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<" . beginning-of-buffer)
   '(">" . end-of-buffer)
   '(";" . meow-cancel-selection)
   '(":" . meow-reverse)
   '("%" . meow-query-replace)
   '("&" . meow-query-replace-regex)
   '("<escape>" . meow-cancel-selection)))

(use-package meow
  :custom
  (meow-use-cursor-position-hack t)
  (meow-use-clipboard t)
  (meow-goto-line-function 'consult-goto-line)
  :config
  (setq meow--kbd-delete-char "<deletechar>")
  (add-to-list 'meow-char-thing-table '(?a . angle))
  (meow-global-mode 1)
  (meow-setup))

(global-set-key (kbd "C-<tab>") 'meow-last-buffer)

(defun rr/minibuffer-backward-kill (arg)
  "When minibuffer is completing a file name delete up to parent
folder, otherwise delete a word"
  (interactive "p")
  (if minibuffer-completing-file-name
      ;; Borrowed from https://github.com/raxod502/selectrum/issues/498#issuecomment-803283608
      (if (string-match-p "/." (minibuffer-contents))
          (zap-up-to-char (- arg) ?/)
        (delete-minibuffer-contents))
    (delete-word (- arg))))

(use-package vertico
  :defer t
  :bind (:map minibuffer-local-map
              ("<Backspace>" . rr/minibuffer-backward-kill))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode +1)
  (setq completion-styles '(flex partial-completion)
        completion-ignore-case t
        completion-category-defaults nil
        completion-category-overrides nil))

(define-key vertico-map "?" #'minibuffer-completion-help)
(define-key vertico-map (kbd "M-RET") #'minibuffer-force-complete-and-exit)
(define-key vertico-map (kbd "M-TAB") #'minibuffer-complete)

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  (marginalia-align 'right)
  (marginalia-align-offset -5)
  :init
  (marginalia-mode))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package orderless
  :after vertico
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        orderless-matching-styles '(orderless-regexp orderless-flex)))

(use-package consult
  :defer t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  :config
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key "M-.")
  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")
  )

(use-package corfu
  :defer t
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary 'separator)	;; Never quit at completion boundary
  (corfu-quit-no-match 'separator)      ;; Never quit, even if there is no match
  (corfu-preview-current 'insert)    ;; Disable current candidate preview
  (corfu-preselect-first nil)    ;; Disable candidate preselection
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)
         (typescript-mode . corfu-mode)
         (typescript-ts-mode . corfu-mode)
         (python-ts-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :init
  (global-corfu-mode))

(setq tab-always-indent 'complete)

(defun rr/enable-corfu-in-org-roam ()
  (when (org-roam-file-p (buffer-file-name))
    (setq-local completion-at-point-functions '(org-roam-complete-everywhere org-roam-complete-link-at-point))
    (corfu-mode 1)))

(setq global-corfu-modes '((not org-mode) t))
(add-hook 'org-mode-hook #'rr/enable-corfu-in-org-roam)

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default)
  (kind-icon-blend-background nil)
  (kind-icon-blend-frac 0.08)
  (svg-lib-icons-dir (no-littering-expand-var-file-name "svg-lib/cache/"))
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package helpful
  :defer t
  :commands (helpful-callable helpful-variable helpful-command helpful-key helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package crux
  :defer t)

(use-package free-keys
  :defer t)

(use-package dired
  :demand t
  :ensure nil
  :commands (dired dired-jump)
  :bind (:map dired-mode-map
              ("H" . dired-omit-mode)
              ("h" . dired-single-up-directory)
              ("l" . dired-single-buffer))

  :config
  (setq
   ;; https://github.com/d12frosted/homebrew-emacs-plus/issues/383
   insert-directory-program (expand-file-name ".nix-profile/bin/ls" (getenv "HOME"))
   dired-listing-switches "-tagho --group-directories-first"
   dired-omit-files "^\\.[^.].*"
   dired-omit-verbose nil
   dired-hide-details-hide-symlink-targets nil
   dired-kill-when-opening-new-dired-buffer t
   delete-by-moving-to-trash t)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (dired-omit-mode 1)
              (hl-line-mode 1)
              (diredfl-mode 1)
              (diff-hl-dired-mode 1)))

  (use-package dired-single
    :vc (:url "https://codeberg.org/amano.kenji/dired-single")
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (use-package diredfl
    :defer t)
  )

(define-key dired-mode-map "?" dired-mode-map)

(use-package diff-hl
  :demand t
  :hook ((prog-mode . diff-hl-mode)
         (org-mode . diff-hl-mode))
  :custom
  (setq
   global-diff-hl-mode 1
   diff-hl-flydiff-mode 1
   diff-hl-dired-mode 1
   diff-hl-margin-mode 1)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package git-link
  :defer t
  :custom
  (git-link-default-branch "master"))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package eat
  :defer t)

(setq inhibit-read-only t)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

(setq scroll-conservatively 1000)

(set-face-attribute 'font-lock-function-name-face nil
                    :height 1.1)

(use-package treesit-auto
  ;; :defer t ; uncomment this if you want to run treesit-auto again
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package jsonrpc
  :defer t)

(use-package typescript-ts-mode
  :defer t
  :mode "\\.ts\\'"
  :hook (typescript-ts-mode . eglot-ensure))

(use-package eglot
  :defer t
  :hook (
         ((typescriptreact-mode typescript-ts-mode) . eglot-ensure)
         (go-ts-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (typescriptreact-mode . flymake-popon-mode)
         )
  :config
  (setq eglot-confirm-server-initiated-edits nil)
  (setq eglot-ignored-server-capabilities nil)
  (add-to-list 'eglot-server-programs
         	   '((typescript-ts-mode typescript-mode) . ("typescript-language-server" "--stdio"))
               '((python-mode python-ts-mode) . ("pylsp"))
               ;;                '(nix-ts-mode . ("nil"))
               ))

(use-package eglot-booster
  :vc (:url "https://github.com/jdtsmith/eglot-booster")
  :after eglot
  :custom
  (eglot-booster-no-remote-boost t)
  :config
  (eglot-booster-mode))

(use-package js-pkg-mode
  :vc (:url "https://github.com/ovistoica/js-pkg-mode")
  :hook
  (typescript-ts-mode . js-pkg-mode))

(use-package python
  :ensure t
  :hook ((python-ts-mode . eglot-ensure))
  :mode (("\\.py\\'" . python-ts-mode)))

(use-package pyvenv
  :defer t
  :config
  (pyvenv-mode 1))

(add-hook 'python-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'eglot-format nil t)))

(use-package prettier
  :defer t
  :hook
  (typescript-ts-mode . prettier-mode)
  :custom
  (prettier-mode-sync-config-flag nil))

(use-package jest-test-mode 
  :ensure t 
  :commands jest-test-mode
  :hook (typescript-ts-mode))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown"))

(use-package yaml-ts-mode
  :defer t
  :mode "\\.yaml\\'")

(use-package go-ts-mode
  :defer t
  :mode "\\.go\\'")

(use-package gotest-ts
  :hook
  (go-ts-mode . gotest-ts)
  :bind
  ("<f2>" . gotest-ts-run-dwim))

(use-package nushell-mode
  :defer t
  :mode "\\.nu\\'")

(use-package nix-ts-mode
  :hook ((nix-ts-mode . eglot-ensure))
  :mode "\\.nix\\'")

(use-package apheleia
  :hook (
         (go-ts-mode . apheleia-mode)
         (python-mode . apheleia-mode)))

(use-package verb
  :defer t
  :custom
  (verb-auto-kill-response-buffers t))

;; Install Khoj client from MELPA Stable
(use-package khoj
  :defer t
  :straight (khoj :type git :host github :repo "khoj-ai/khoj" :files (:defaults "src/interface/emacs/khoj.el"))
  :bind ("C-c s" . 'khoj)
  :config (setq khoj-api-key (rr/lookup-password :host "khoj")
                khoj-server-url "http://127.0.0.1:42110"
                khoj-org-directories '(org-roam-directory org-directory)
                khoj-org-files '((expand-file-name "journal.org" org-directory) (expand-file-name "organize.org" org-directory))))

(use-package consult-xref-stack
  :defer t
  :vc (:url "https://github.com/brett-lempereur/consult-xref-stack" :branch "main")
  :bind
  (("M-," . consult-xref-stack-backward)))

(use-package consult-project-extra
  :defer t)

(use-package leetcode
  :defer t)
(add-hook 'leetcode-solution-mode-hook
          (lambda() (flymake-mode 1)))
(setq leetcode-prefer-language "python3")

(use-package activities
  :init
  (activities-mode)
  (activities-tabs-mode)
  ;; Prevent `edebug' default bindings from interfering.
  (setq edebug-inhibit-emacs-lisp-mode-bindings t)

  :bind
  (("C-x C-a C-n" . activities-new)
   ("C-x C-a C-d" . activities-define)
   ("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-s" . activities-suspend)
   ("C-x C-a C-k" . activities-kill)
   ("C-x C-a RET" . activities-switch)
   ("C-x C-a b" . activities-switch-buffer)
   ("C-x C-a g" . activities-revert)
   ("C-x C-a l" . activities-list)))

(with-eval-after-load 'tab-bar
  (setq tab-bar-new-tab-to 'rightmost)
  (setq tab-bar-new-tab-choice "*scratch*")
  ;; Appearance
  (setq tab-bar-separator 'nil)
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator tab-bar-format-align-right))
  (setq tab-bar-close-button-show t)
  (set-face-attribute 'tab-bar nil
                      :height 1.0) ; background behind all tabs on the tab bar
  (set-face-attribute 'tab-bar-tab nil
                      :overline t) ; the selected tab
  (set-face-attribute 'tab-bar-tab-inactive nil 
                      :box nil) ; unselected tabs
  (setq tab-bar-history-limit 100) ; the default is ten. Why not 1,000? LOL
  )
(custom-set-variables '(tab-bar-select-tab-modifiers '(super)))

(defun rr/set-org-capture-templates ()
  `(("o" "Organize")
    ("ot" "Task" entry (file+olp, (rr/org-path "organize.org") "Tasks")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("oe" "Event" entry (file+olp, (rr/org-path "organize.org") "Events")
     "* TODO %?\n%U\n %i")
    ("og" "Guitar" entry (file+olp, (rr/org-path "organize.org") "Goals" "Guitar" "Practice Log")
     "* %u\n%?")
	
    ("w" "Work")
    ("wt" "Work Task" entry (file+olp, (rr/org-path "work-tasks.org") "Tasks")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("wd" "Deep Task" entry (file+olp, (rr/org-path "work-tasks.org") "All Tasks" "Deep")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("ws" "Shallow Task" entry (file+olp, (rr/org-path "work-tasks.org") "All Tasks" "Shallow")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("wi" "Work Inbox" entry (file+olp, (rr/org-path "work-tasks.org") "Inbox")
     "* %?\n%U\n %i")
    ("wm" "Work Meeting" entry (file+headline, (rr/org-path "work-tasks.org") "Meeting Notes")
     "* %?\n%U\n %i")
    ("wa" "Activity Log" entry (file+olp+datetree, (rr/org-path "work-tasks.org") "Activity Log")
     "* %?\n%U\n %i")

	("m" "Meeting")
    ("mm" "1:1 with Max" entry (file+datetree, "~/Documents/roam-notes/meetings/1on1/max.org")
     "* %U\n- %?\n %i" :kill-buffer t)
    ("mr" "1:1 with Rob" entry (file+datetree, "~/Documents/roam-notes/meetings/1on1/rob.org")
     "* %U\n- %?\n %i" :kill-buffer t)
    ("mj" "1:1 with Joseph" entry (file+datetree, "~/Documents/roam-notes/meetings/1on1/joseph.org")
     "* %U\n- %?\n %i" :kill-buffer t)
	
    ("j" "Journal" entry (file+datetree, (rr/org-path "journal.org"))
     "* %?\n")
	
    ("n" "Notes")
    ("nr" "Resource" entry (file+olp, (rr/org-path "refile.org") "Resources")
     "* %?\n%U\n %i")
    ("nc" "Curiosity" entry (file+olp, (rr/org-path "refile.org") "Curiosities")
     "* %?\n%U\n %i")
    ("no" "Other" entry (file+olp, (rr/org-path "refile.org") "Notes")
     "* %?\n%U\n %i")
	
    ("l" "Life")
    ("lj" "Journal" entry (file+olp+datetree, (rr/org-path "life.org") "Journal") "* %?\n%U\n %i")
    )
  )

(defun rr/org-path (path)
  (expand-file-name path org-directory))

(defun rr/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode)
  (setq org-directory rr-org-mode-dir)
  (setq org-agenda-files (append (directory-files org-directory t "\\.org$") (rr/org-roam-list-notes-by-tag "project")))
  (setq org-capture-templates (rr/set-org-capture-templates))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "CODE(c)" "FDBK(f)" "|" "DONE(d!)" "KILL(k!)")
          ))
  (setq org-id-link-to-org-use-id 'use-existing))

(use-package org
  :demand t
  :hook (org-mode . rr/org-mode-setup)
  :config
  ;;    (rr/org-mode-setup)
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map)
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-log-done 'time
        org-log-into-drawer t
        ;; org-adapt-indentation t
        ;; org-element-use-cache nil
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-tags-column -70
        org-agenda-start-with-log-mode t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-tags-column 100
        org-agenda-include-diary t
        org-catch-invisible-edits 'smart
        org-fontify-whole-heading-line t
        org-fontify-quote-and-verse-blocks t
        org-ctrl-k-protect-subtree t
        org-cycle-separator-lines 0
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
		org-tag-alist '(;; Places
						("@home" . ?H)
						("@work" . ?W)
						;; Devices
						("@phone" . ?P)
						("@computer" . ?C)
						;; Activities
						("@writing" . ?w)
						("@errands" . ?r)
						("@email" . ?e)
						("@call" . ?c)
						)
        org-refile-allow-creating-parent-nodes 'confirm
        org-refile-targets
        '((nil :maxlevel . 6)
          (org-agenda-files :maxlevel . 6)))

  (advice-add 'org-refile :after 'org-save-all-org-buffers))

(require 'org-indent)

(use-package ox-gfm
  :after org)

(use-package org-appear
  :after org)
(add-hook 'org-mode-hook 'org-appear-mode)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun echo-area-tooltips ()
  "Show tooltips in the echo area automatically for current buffer."
  (setq-local help-at-pt-display-when-idle t
              help-at-pt-timer-delay 0)
  (help-at-pt-cancel-timer)
  (help-at-pt-set-timer))

(add-hook 'org-mode-hook #'echo-area-tooltips)

(defun rr/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :after org
  :hook (org-mode . rr/org-mode-visual-fill))

(use-package org-super-agenda
  :after org
  :defer t
  :init
  (org-super-agenda-mode))

(setq org-agenda-span 'day)

(setq org-agenda-custom-commands
      `(("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (tags-todo "+PRIORITY=\"A\""
                     ((org-agenda-overriding-header "High Priority")))
          (todo "STRT"
                ((org-agenda-overriding-header "In Progress")
                 (org-agenda-max-todos nil)))
          (todo "TODO"
                ((org-agenda-overriding-header "Unprocessed Inbox Tasks")))))
        ("U" "Unscheduled"
         ((agenda ""
                  ((org-agenda-overriding-header "TODOs")
                   ))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled")
                 (org-agenda-skip-function
                  (quote
                   (org-agenda-skip-entry-if
                    (quote scheduled)))))))
         nil nil)
        
		("r" "Weekly Review"
		 ((agenda ""
				  ((org-agenda-overriding-header "Completed Tasks")
				   (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo 'done))
				   (org-agenda-span 'week)))
		  (agenda ""
				  ((org-agenda-overriding-header "Unfinished Scheduled Tasks")
				   (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				   (org-agenda-span 'week)))))
		("u" "Super View"
		 ((agenda "" ((org-agenda-span 1)
					  (org-super-agenda-groups
					   '(
						 (:name "Today"
								:time-grid t
								:date today
								:scheduled today
								:order 1
								:face 'warning
								)
						 (:name "Overdue"
								:deadline past
								:face 'error
								)
						 (:name "Reschedule"
								:scheduled past
								:face 'error
								)
						 (:name "Projects"
								:tag ("project" "@proj")
								)
						 (:name "Due soon"
								:deadline future
								:scheduled future)
						 ))))))
		))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t))))

(setq org-confirm-babel-evaluate nil)

(with-eval-after-load 'org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

;; This may not be needed
(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; Automatically tangle PrivateConfig.org config file when we save it
(defun rr/org-babel-tangle-config ()
  (when (string-match "dotfiles\/" (buffer-file-name))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'rr/org-babel-tangle-config)))

(use-package org-make-toc
  :after org)

(defun rr/enable-org-make-toc-mode ()
  (if (equal (buffer-name) "PostInitConfig.org")
      (org-make-toc-mode)))

(add-hook 'find-file-hook 'rr/enable-org-make-toc-mode)

(setq org-todo-keyword-faces
      '(("WAIT" . (:foreground "#e6bf85" :weight bold))
        ("TODO" . (:foreground "#a0bc70" :weight bold))
        ("STRT" . (:foreground "#a7a2dc" :weight bold))
        ("HOLD" . (:foreground "#e6bf85" :weight bold))
        ("CODE" . (:foreground "#fdac37" :weight bold))
        ("FDBK" . (:foreground "#e6bf85" :weight bold))
        ("IDEA" . (:foreground "#fdac37" :weight bold))
        ("DONE" . (:foreground "#5c6267" :weight bold))
        ("KILL" . (:foreground "#ee7570" :weight bold))

        ("REACHED-OUT" . (:foreground "#e6bf85" :weight bold))
        ("TO-APPLY" . (:foreground "#a0bc70" :weight bold))
        ("APPLIED" . (:foreground "#a7a2dc" :weight bold))
        ("INFO-SCH" . (:foreground "#fdac37" :weight bold))
        ("INTERVIEW" . (:foreground "#e6bf85" :weight bold))
        ("AWAITING" . (:foreground "#74A8FC" :weight bold))
        ("REJECTED" . (:foreground "#f38ba8" :weight bold))
        ("FOLLOW-UP" . (:foreground "#fdac37" :weight bold))
        ("ACCEPTED" . (:foreground "#5c6267" :weight bold))
        ("ABANDONED" . (:foreground "#ee7570" :weight bold))
        ))

(set-face-attribute 'org-document-title nil :font my-variable-pitch-font :weight 'regular :height 1.5)

(dolist (face '((org-level-1 . 1.3)
                (org-level-2 . 1.2)
                (org-level-3 . 1.15)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font my-variable-pitch-font :weight 'regular :height (cdr face))

  ;; Original background color of org-block: #3B3D4A
  (set-face-attribute 'org-block nil :foreground "unspecified" :background "#2D313B" :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-todo nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-list-dt nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-tag nil :foreground "#5A5D67")
  ;;(set-face-attribute 'hl-line nil :background "#0d3b66")
  (set-face-attribute 'org-column nil :background "unspecified")
  (set-face-attribute 'org-column-title nil :background "unspecified"))

(add-hook 'org-mode-hook 'org-align-all-tags)

(add-hook 'focus-in-hook
          (lambda ()
            (setq org-tags-column (- 5 (window-body-width)))
            (org-align-all-tags)))

(add-hook 'focus-out-hook
          (lambda ()
            (setq org-tags-column (- 5 (window-body-width)))
            (org-align-all-tags)))

(defun +org-get-todo-keywords-for (&optional keyword)
  "Returns the list of todo keywords that KEYWORD belongs to."
  (when keyword
    (cl-loop for (type . keyword-spec)
             in (cl-remove-if-not #'listp org-todo-keywords)
             for keywords =
             (mapcar (lambda (x) (if (string-match "^\\([^(]+\\)(" x)
                                     (match-string 1 x)
                                   x))
                     keyword-spec)
             if (eq type 'sequence)
             if (member keyword keywords)
             return keywords)))

(defun +org/dwim-at-point (&optional arg)
  "Do-what-I-mean at point.

If on a:
- checkbox list item or todo heading: toggle it.
- clock: update its time.
- headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
  subtree; update statistics cookies/checkboxes and ToCs.
- footnote reference: jump to the footnote's definition
- footnote definition: jump to the first reference of this footnote
- table-row or a TBLFM: recalculate the table's formulas
- table-cell: clear it and go into insert mode. If this is a formula cell,
  recaluclate it instead.
- babel-call: execute the source block
- statistics-cookie: update it.
- latex fragment: toggle it.
- link: follow it
- otherwise, refresh all inline images in current tree."
  (interactive "P")
  (if (button-at (point))
      (call-interactively #'push-button)
    (let* ((context (org-element-context))
           (type (org-element-type context)))
      ;; skip over unimportant contexts
      (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
        (setq context (org-element-property :parent context)
              type (org-element-type context)))
      (pcase type
        (`headline
         (cond ((memq (bound-and-true-p org-goto-map)
                      (current-active-maps))
                (org-goto-ret))
               ((and (fboundp 'toc-org-insert-toc)
                     (member "TOC" (org-get-tags)))
                (toc-org-insert-toc)
                (message "Updating table of contents"))
               ((string= "ARCHIVE" (car-safe (org-get-tags)))
                (org-force-cycle-archived))
               ((or (org-element-property :todo-type context)
                    (org-element-property :scheduled context))
                (org-todo
                 (if (eq (org-element-property :todo-type context) 'done)
                     (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
                         'todo)
                   'done))))
         ;; Update any metadata or inline previews in this subtree
         (org-update-checkbox-count)
         (org-update-parent-todo-statistics)
         (when (and (fboundp 'toc-org-insert-toc)
                    (member "TOC" (org-get-tags)))
           (toc-org-insert-toc)
           (message "Updating table of contents"))
         (let* ((beg (if (org-before-first-heading-p)
                         (line-beginning-position)
                       (save-excursion (org-back-to-heading) (point))))
                (end (if (org-before-first-heading-p)
                         (line-end-position)
                       (save-excursion (org-end-of-subtree) (point))))
                (overlays (ignore-errors (overlays-in beg end)))
                (latex-overlays
                 (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
                             overlays))
                (image-overlays
                 (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
                             overlays)))
           (+org--toggle-inline-images-in-subtree beg end)
           (if (or image-overlays latex-overlays)
               (org-clear-latex-preview beg end)
             (org--latex-preview-region beg end))
           ))

        (`clock (org-clock-update-time-maybe))

        (`footnote-reference
         (org-footnote-goto-definition (org-element-property :label context)))

        (`footnote-definition
         (org-footnote-goto-previous-reference (org-element-property :label context)))

        ((or `planning `timestamp)
         (org-follow-timestamp-link))

        ((or `table `table-row)
         (if (org-at-TBLFM-p)
             (org-table-calc-current-TBLFM)
           (ignore-errors
             (save-excursion
               (goto-char (org-element-property :contents-begin context))
               (org-call-with-arg 'org-table-recalculate (or arg t))))))

        (`table-cell
         (org-table-blank-field)
         (org-table-recalculate arg)
         (when (and (string-empty-p (string-trim (org-table-get-field)))
                    (bound-and-true-p evil-local-mode))
           (evil-change-state 'insert)))

        (`babel-call
         (org-babel-lob-execute-maybe))

        (`statistics-cookie
         (save-excursion (org-update-statistics-cookies arg)))

        ((or `src-block `inline-src-block)
         (org-babel-execute-src-block arg))

        ((or `latex-fragment `latex-environment)
         (org-latex-preview arg))

        (`link
         (let* ((lineage (org-element-lineage context '(link) t))
                (path (org-element-property :path lineage)))
           (if (or (equal (org-element-property :type lineage) "img")
                   (and path (image-type-from-file-name path)))
               (+org--toggle-inline-images-in-subtree
                (org-element-property :begin lineage)
                (org-element-property :end lineage))
             (org-open-at-point arg))))

        ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
         (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
           (org-toggle-checkbox (if (equal match "[ ]") '(16)))))

        (_
         (if (or (org-in-regexp org-ts-regexp-both nil t)
                 (org-in-regexp org-tsr-regexp-both nil  t)
                 (org-in-regexp org-link-any-re nil t))
             (call-interactively #'org-open-at-point)
           (+org--toggle-inline-images-in-subtree
            (org-element-property :begin context)
            (org-element-property :end context))))))))

(defun rr/org-insert-link-dwim ()
  "Like `org-insert-link' but with personal dwim preferences."
  (interactive)
  (let* ((point-in-link (org-in-regexp org-link-any-re 1))
         (clipboard-url (when (string-match-p "^http" (current-kill 0))
                          (current-kill 0)))
         (region-content (when (region-active-p)
                           (buffer-substring-no-properties (region-beginning)
                                                           (region-end)))))
    (cond ((and region-content clipboard-url (not point-in-link))
           (delete-region (region-beginning) (region-end))
           (insert (org-make-link-string clipboard-url region-content)))
          ((and clipboard-url (not point-in-link))
           (insert (org-make-link-string
                    clipboard-url
                    (read-string "title: "
                                 (with-current-buffer (url-retrieve-synchronously clipboard-url)
                                   (dom-text (car
                                              (dom-by-tag (libxml-parse-html-region
                                                           (point-min)
                                                           (point-max))
                                                          'title))))))))
          (t
           (call-interactively 'org-insert-link)))))

(defun +org-cycle-only-current-subtree-h (&optional arg)
  "Toggle the local fold at the point, and no deeper.
       `org-cycle's standard behavior is to cycle between three levels: collapsed,
       subtree and whole document. This is slow, especially in larger org buffer. Most
       of the time I just want to peek into the current subtree -- at most, expand
       *only* the current subtree.

       All my (performant) foldings needs are met between this and `org-show-subtree'
       (on zO for evil users), and `org-cycle' on shift-TAB if I need it."
  (interactive "P")
  (unless (eq this-command 'org-shifttab)
    (save-excursion
      (org-beginning-of-line)
      (let (invisible-p)
        (when (and (org-at-heading-p)
                   (or org-cycle-open-archived-trees
                       (not (member org-archive-tag (org-get-tags))))
                   (or (not arg)
                       (setq invisible-p (outline-invisible-p (line-end-position)))))
          (unless invisible-p
            (setq org-cycle-subtree-status 'subtree))
          (org-cycle-internal-local)
          t)))))

(defun +org/refile-to-current-file (arg &optional file)
  "Refile current heading to elsewhere in the current buffer.
If prefix ARG, copy instead of move."
  (interactive "P")
  (let ((org-refile-targets `((,file :maxlevel . 10)))
        (org-refile-use-outline-path nil)
        (org-refile-keep arg)
        current-prefix-arg)
    (call-interactively #'org-refile)))

(defun rr/org-show-next-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-next-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(global-set-key (kbd "M-n") 'rr/org-show-next-heading-tidily)

(defun rr/org-show-previous-heading-tidily ()
  "Show previous entry, keeping other entries closed."
  (interactive)
  (let ((pos (point)))
    (outline-previous-heading)
    (unless (and (< (point) pos) (bolp) (org-on-heading-p))
      (goto-char pos)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(global-set-key (kbd "M-p") 'rr/org-show-previous-heading-tidily)

(defun rr/org-sort-list-by-checkbox-type ()
  "Sort list items according to Checkbox state."
  (interactive)
  (org-sort-list
   nil ?f
   (lambda ()
     (if (looking-at org-list-full-item-re)
         (cdr (assoc (match-string 3)
                     '(("[X]" . 4) ("[-]" . 3) ("[ ]" . 2) (nil . 1))))
       4))))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local electric-pair-inhibit-predicate
                        `(lambda (c)
                           (if (char-equal c ?<) t
                             (,electric-pair-inhibit-predicate c))))))

(eval-after-load 'org-list
  '(add-hook 'org-checkbox-statistics-hook (function rr/checkbox-list-complete)))

(defun rr/checkbox-list-complete ()
  (save-excursion
    (org-back-to-heading t)
    (let ((beg (point)) end)
      (end-of-line)
      (setq end (point))
      (goto-char beg)
      (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]" end t)
          (if (match-end 1)
              (if (equal (match-string 1) "100%")
                  ;; all done - do the state change
                  (org-todo 'done)
                (org-todo 'todo))
            (if (and (> (match-end 2) (match-beginning 2))
                     (equal (match-string 2) (match-string 3)))
                (org-todo 'done)
              (org-todo 'todo)))))))

(use-package org-roam
  :defer 2
  :custom
  (org-roam-directory rr-org-roam-dir)
  (org-roam-dailies-directory "journals/")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "Default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("p" "Project" plain
      (file "~/org-mode/roam/work/templates/projectNoteTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags:project")
      :unnarrowed t)
     
     ("m" "Meeting" plain
      (file "~/org-mode/roam/work/templates/meetingTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags:meeting")
      :unnarrowed t)
     )
   )
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %?\n[%<%I:%M %p>]\n" :target
      (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+filetags:%<%Yw%V>\n")))
   )
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n a" . org-roam-tag-add)
         ("C-c n d" . org-roam-dailies-map)
         )
  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-setup))

(defun rr/org-roam-filter-by-tag (tag-name)
  (lambda (node)
  	(member tag-name (org-roam-node-tags node))))

(defun rr/org-roam-list-notes-by-tag (tag-name)
  (let ((nodes (org-roam-node-list)))
  	(mapcar #'org-roam-node-file
  			(seq-filter
  			 (rr/org-roam-filter-by-tag tag-name)
  			 (org-roam-node-list)))))

(defun rr/org-roam-refresh-agenda-list ()
  (interactive)
  (setq org-agenda-files (rr/org-roam-list-notes-by-tag "project")))

;;  (rr/org-roam-refresh-agenda-list)

(defun rr/org-roam-project-finalize-hook ()
  "Adds the captured project file to `org-agenda-files' if the
  capture was not aborted."
  ;; Remove the hook since it was added temporarily
  (remove-hook 'org-capture-after-finalize-hook #'rr/org-roam-project-finalize-hook)

  ;; Add project file to the agenda list if the capture was confirmed
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
      (add-to-list 'org-agenda-files (buffer-file-name)))))

(defun rr/org-roam-find-project ()
  (interactive)
  ;; Add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'rr/org-roam-project-finalize-hook)

  ;; Select a project file to open, creating it if necessary
  (org-roam-node-find
   nil
   nil
   (rr/org-roam-filter-by-tag "project")
   nil
   :templates
   '(("p" "project" plain
      (file "~/org-mode/roam/work/templates/projectNoteTemplate.org")
  	  :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: project")
  	  :unnarrowed t))))

(global-set-key (kbd "C-c n p") #'rr/org-roam-find-project)

(defun rr/org-roam-capture-task ()
  (interactive)
  ;; Add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'rr/org-roam-project-finalize-hook)

  ;; Capture the new task, creating the project file if necessary
  (org-roam-capture- :node (org-roam-node-read
                            nil
                            (rr/org-roam-filter-by-tag "project"))
                     :templates '(("p" "project" plain "** TODO %?"
                                   :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                          "#+title: ${title}\n#+category: ${title}\n#+filetags: project"
                                                          ("Tasks"))))))
(global-set-key (kbd "C-c n t") #'rr/org-roam-capture-task)

(defun rr/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep t) ;; Set this to nil to delete the original!
        (org-roam-dailies-capture-templates
         '(("t" "tasks" entry "%?"
            :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-roam-dailies--capture (current-time) t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
      (org-refile nil nil (list "Tasks" today-file nil pos)))))

(add-to-list 'org-after-todo-state-change-hook
             (lambda ()
               (when (equal org-state "DONE")
                 (rr/org-roam-copy-todo-to-today))))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates) '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam-ui
  :vc
  (:url "https://github.com/org-roam/org-roam-ui" :branch "main")
  :after org-roam
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package ox-hugo
  :after ox)

(defun rr/enable-hugo-auto-export-mode ()
  (if (equal (buffer-name) "blog.org")
      (org-hugo-auto-export-mode)))

(add-hook 'find-file-hook 'rr/enable-hugo-auto-export-mode)

(defun rr/extract-hugo-post-file-name ()
  "Create a filename out of blog post's title.

This method is expected to be executed on a TODO heading on a an
org file containing blog posts that would be exported using
ox-hugo. Running this interactive command would set an org
property called EXPORT_FILE_NAME that is required by ox-hugo to
generate a Hugo-friendly markdown file in the location specified
in HUGO_BASE_DIR property."
  (interactive)
  (setq-local blog-post-title (nth 4 (org-heading-components)))
  (let* ((file-name (replace-regexp-in-string "_+" "-" (replace-regexp-in-string "\\W" "_" (string-trim (downcase blog-post-title)))))
         (blog-post-file-name (concat file-name ".md")))
    (org-set-property "EXPORT_FILE_NAME" blog-post-file-name)))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(if (file-exists-p "~/bin/additional-config.el")
    (progn
      (message "additional config exists")
      (load "~/bin/additional-config.el")))
