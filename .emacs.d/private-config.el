(setq user-full-name "Rajath Ramakrishna"
      user-mail-address "r.rajath@pm.me")

(setq gc-cons-threshold (* 50 1000 1000))

(defun rr/display-startup-time ()
  "Displays startup time in the echo buffer and Messages buffer as
soon as Emacs loads."
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'rr/display-startup-time)

(setq pixel-width (display-pixel-width))
(setq pixel-height (display-pixel-height))
(setq display-mode "")

(cond
 ((= pixel-width 1792)
  (setq display-mode "laptop"))
 ((= pixel-width 5232)
  (setq display-mode "desktop")))
(message "Display Mode: %s" display-mode)

(message "Setting frame size and position based on display size")

(cond
 ((equal display-mode "laptop")
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))
 ((equal display-mode "desktop")
  (progn
    (add-to-list 'default-frame-alist
                 (cons 'left 1720))
    (add-to-list 'default-frame-alist
                 (cons 'width 214))
    (add-to-list 'default-frame-alist
                 (cons 'height 83))
    )))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

(use-package gcmh
  :init
  (gcmh-mode 1))

(use-package no-littering)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

(setq-default
 delete-by-moving-to-trash t
 evil-want-fine-undo t
 auto-save-default t)

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(global-subword-mode 1)

(setq confirm-kill-emacs #'y-or-n-p)

(add-to-list 'completion-ignored-extensions ".DS_Store")

(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 0)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(set-face-attribute 'default nil :font "JetBrains Mono" :height 125)

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme
  ;; (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package all-the-icons)

;; Set modeline's background to something lighter
(set-face-attribute 'mode-line nil
                    :background "#2c323b")

(column-number-mode)
(global-display-line-numbers-mode t)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                ;; treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package paren
  :defer t
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(global-hl-line-mode)

(use-package beacon
  :defer t
  :config
  (push 'vterm-mode beacon-dont-blink-major-modes)
  :init
  (beacon-mode))

(use-package general
  :config
  (general-evil-setup t))

(general-define-key
 :states 'normal
 :keymaps 'override
 :prefix "SPC"
 "SPC" '(counsel-M-x :which-key "M-x")
 "X"   '(org-capture :which-key "org-capture")
 "`"   '(evil-switch-to-windows-last-buffer :which-key "last window")
 "RET" '(consult-bookmark :which-key "bookmarks")
 "t"   '(vterm-toggle :which-key "vterm-popup")
 ;; commands
 "e"   '(:ignore t :which-key "eval")
 "e e" '(eros-eval-last-sexp :which-key "eros-eval-last-sexp")
 "e r" '(eval-region :which-key "eval-region")
 "e b" '(eval-buffer :which-key "eval-buffer")
 ;; buffer management
 "b"   '(:ignore t :which-key "buffers")
 "b i" '(ibuffer :which-key "ibuffer")
 "b r" '(rr/revert-buffer-no-confirm :which-key "rr/revert-buffer-no-confirm")
 "b R" '(revert-buffer :which-key "revert-buffer")
 "b k" '(kill-buffer :which-key "kill-buffer")
 ;; perspectives
 "s"   '(:ignore t :which-key "perspectives")
 "s b" '(persp-switch-to-buffer* :which-key "switch-to-buffer")
 "s k" '(persp-kill-buffer :which-key "kill-buffer")
 "s a" '(persp-add-buffer :which-key "add-buffer")
 "s A" '(persp-set-buffer :which-key "set-buffer")
 "s s" '(persp-switch :which-key "persp-switch")
 "s r" '(persp-rename :which-key "persp-rename")
 "s k" '(persp-kill :which-key "persp-kill")
 ;; dired
 "d"   '(:ignore t :which-key "dired")
 "d j" '(dired-jump :which-key "dired-jump")
 "d J" '(dired-jump-other-window :which-key "dired-jump-other-window")
 "d d" '(dired :which-key "dired")
 "d n" '(dired-create-empty-file :which-key "dired-create-empty-file")
 ;; window management
 "w"   '(:ignore t :which-key "window")
 "w v" '(split-window-right :which-key "split window right")
 "w h" '(split-window-below :which-key "split window below")
 "w c" '(delete-window :which-key "delete-window")
 "w w" '(next-window-any-frame :which-key "next window")
 ;; help for variables, functions, keybindings, etc.
 "h"   '(:ignore t :which-key "help")
 "h a" '(consult-apropos :which-key "apropos")
 "h v" '(describe-variable :which-key "variable")
 "h f" '(describe-function :which-key "function")
 "h k" '(helpful-key :which-key "key")
 "h i" '(info :which-key "info")
 "h c" '(describe-key-briefly :which-key "describe-key-briefly")
 ;; jump with avy
 "j"   '(:ignore t :which-key "jump")
 "j j" '(avy-goto-char :which-key "avy-goto-char")
 "j w" '(avy-goto-word-1 :which-key "avy-goto-word-1")
 "j l" '(avy-goto-line :which-key "avy-goto-line")
 ;; magit status
 "g"   '(:ignore t :which-key "magit")
 "g g" '(magit-status :which-key "magit status")
 ;; org-mode
 "o"   '(:ignore t :which-key "org-mode")
 ;; org-mode
 "o a" '(org-agenda :which-key "org-agenda")
 "o e" '(org-export-dispatch :which-key "org-export-dispatch")
 "o t" '(org-todo :which-key "org-todo")
 "o h" '(org-toggle-heading :which-key "heading")
 "o i" '(org-toggle-item :which-key "item")
 "o o" '(consult-outline :which-key "consult-outline")
 "o S" '(org-show-todo-tree :which-key "org-show-todo-tree")
 "o q" '(org-set-tags-command :which-key "org-set-tags-command")
 "o N" '(org-add-note :which-key "org-add-note")
 ;; org-mode / checkbox
 "o x"   '(:ignore t :which-key "checkbox")
 "o x x" '(org-toggle-checkbox :which-key "org-toggle-checkbox")
 "o x s" '(rr/org-sort-list-by-checkbox-type :which-key "org-sort-checklist")
 ;; org-mode / clock
 "o c"   '(:ignore t :which-key "clock")
 "o c i" '(org-clock-in :which-key "org-clock-in")
 "o c o" '(org-clock-out :which-key "org-clock-out")
 "o c c" '(org-clock-cancel :which-key "org-clock-cancel")
 "o c d" '(org-clock-display :which-key "org-clock-display")
 "o c g" '(org-clock-goto :which-key "org-clock-goto")
 ;; org-mode / narrow
 "o n"   '(:ignore t :which-key "narrow")
 "o n s" '(org-narrow-to-subtree :which-key "org-narrow-to-subtree")
 "o n b" '(org-narrow-to-block :which-key "org-narrow-to-block")
 "o n e" '(org-narrow-to-element :which-key "org-narrow-to-element")
 "o n r" '(org-narrow-to-region :which-key "org-narrow-to-region")
 "o n w" '(widen :which-key "widen")
 ;; org-mode / refile
 "o r"   '(:ignore t :which-key "refile")
 "o r r" '(org-refile :which-key "org-refile")
 "o r c" '(org-refile-copy :which-key "org-refile-copy")
 "o r ." '(+org/refile-to-current-file :which-key "+org/refile-to-current-file")
 "o r A" '(org-archive-subtree :which-key "org-archive-subtree")
 ;; org-mode / date
 "o d"   '(:ignore t :which-key "date/deadline")
 "o d s" '(org-schedule :which-key "org-schedule")
 "o d d" '(org-deadline :which-key "org-deadline")
 "o d t" '(org-time-stamp :which-key "org-time-stamp")
 "o d T" '(org-time-stamp-inactive :which-key "org-time-stamp-inactive")
 ;; org-mode / links
 "o l"   '(:ignore t :which-key "links")
 "o l l" '(org-insert-link :which-key "org-insert-link")
 "o l v" '(crux-view-url :which-key "crux-view-url")
 "o l s" '(org-store-link :which-key "org-store-link")
 "o l h" '(rr/org-insert-html-link :which-key "org-insert-link-with-title")
 ;; projectile
 "p"   '(:ignore t :which-key "projectile")
 "p f" '(projectile-find-file :which-key "projectile-find-file")
 "p /" '(consult-ripgrep :which-key "consult-ripgrep")
 "p r" '(projectile-recentf :which-key "projectile-recentf")
 "p s" '(counsel-projectile-switch-project :which-key "projectile-switch-project")
 "p t" '(rr/projectile-run-vterm :which-key "rr/projectile-run-vterm")
 "p k" '(projectile-kill-buffers :which-key "projectile-kill-buffers")
 ;; files
 "f"   '(:ignore t :which-key "files")
 "f f" '(find-file :which-key "find-file")
 "f r" '(consult-recent-file :which-key "recent files")
 ;; consult
 "c"   '(:ignore t :which-key "consult")
 "c m" '(consult-mark :which-key "consult-mark")
 "c M" '(consult-global-mark :which-key "consult-global-mark")
 )

(general-define-key
 :states '(normal insert)
 "C-e" 'end-of-line
 "C-a" 'beginning-of-line
 "C-n" 'evil-next-visual-line
 "C-p" 'evil-previous-visual-line
 "C-S-o" 'evil-jump-forward
 "C-o" 'evil-jump-backward
 "C-s" 'consult-line)

(general-define-key
 :keymaps '(normal insert)
 "s-]" 'persp-next
 "s-[" 'persp-prev)

(server-start)

(use-package super-save
  :defer 1
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

(use-package evil-nerd-commenter
  :after evil)

(defun rr/comment-and-nextline ()
  "Comment the current line and move the point to the next line"
  (interactive)
  (evilnc-comment-or-uncomment-lines 1)
  (evil-next-line))

(general-define-key
 :states '(normal insert)
 "s-/" 'rr/comment-and-nextline)

(use-package avy
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))

(use-package eros
  :defer t)
(eros-mode 1)

(use-package hungry-delete
  :defer 2
  :config
  (setq hungry-delete-join-reluctantly t))
(global-hungry-delete-mode)

(use-package goto-last-change)

(defun rr/revert-buffer-no-confirm ()
  "Revert the buffer, but don't ask for confirmation"
  (interactive)
  (revert-buffer nil t nil))

(use-package popper
  :after projectile
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
          "\\*vterm\\*"
          "\\*Excorporate\\*"
          "\\*xref\\*"
          help-mode
          helpful-mode
          compilation-mode
          org-roam-mode
          term-mode
          vterm-mode)
        popper-group-function #'popper-group-by-projectile)
  (popper-mode +1))

(general-define-key
 :keymaps '(normal insert)
 "C-;" 'popper-toggle-latest
 "C-:" 'popper-cycle)

(use-package undo-tree)

(global-undo-tree-mode)

(recentf-mode)

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

;; Making ESC key work like an ESC key by exiting/canceling stuff
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-j") 'consult-buffer)

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-model 'normal))

(evil-mode 1)

;; Evil Collection for predictable Vim keybindings in a lot of modes
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(general-define-key
 :states 'normal
 :keymaps 'org-mode-map
 "t" 'org-todo)

(general-define-key
 :states 'normal
 "C-S-u" 'universal-argument)

(use-package hydra
  :defer t)

(defhydra hydra-window-resize (global-map "C->")
  "resize"
  ("l" enlarge-window-horizontally "enlarge-horizontal")
  ("h" shrink-window-horizontally "shrink-horizontal")
  ("j" enlarge-window "enlarge-vertical")
  ("k" shrink-window "shrink-vertical"))

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
  :bind (:map minibuffer-local-map
              ("<Backspace>" . rr/minibuffer-backward-kill))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(define-key vertico-map "?" #'minibuffer-completion-help)
(define-key vertico-map (kbd "M-RET") #'minibuffer-force-complete-and-exit)
(define-key vertico-map (kbd "M-TAB") #'minibuffer-complete)

(use-package savehist
  :custom
  (history-length 25)
  :init
  (savehist-mode))

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
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package consult
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
   :preview-key (kbd "M-."))
  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")
  )

(defun rr/get-project-root ()
  (when (fboundp 'projectile-project-root)
    (projectile-project-root)))

(setq consult-project-root-function #'rr/get-project-root)

(use-package corfu
  :general
  (:keymaps 'corfu-map
            :states 'insert
            "M-n" #'corfu-next
            "M-p" #'corfu-previous
            "SPC" #'corfu-insert-separator
            "C-M-s-d" #'corfu-show-documentation
            "C-M-s-l" #'corfu-show-location)
  :custom
  (corfu-auto nil)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.25)
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle nil)
  (corfu-quit-at-boundary separator)
  (corfu-separator ?\s)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current 'insert)
  (corfu-preselect-first t)
  (corfu-echo-documentation t)
  (tab-always-indent 'complete)
  (completion-cycle-threshold nil)
  :config
  (corfu-global-mode))

(setq tab-always-indent 'complete)

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

(use-package corfu-doc
  :straight (corfu-doc :type git :host github :repo "galeo/corfu-doc")
  :after corfu
  :hook (corfu-mode . corfu-doc-mode)
  :general (:keymaps 'corfu-map
                     [remap corfu-show-documentation] #'corfu-doc-toggle
                     "M-n" #'corfu-doc-scroll-up
                     "M-p" #'corfu-doc-scroll-down)
  :custom
  (corfu-doc-delay 0.5)
  (corfu-doc-max-width 70)
  (corfu-doc-max-height 20)
  (corfu-echo-documentation nil))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package expand-region
  :bind (("M-[" . er/expand-region)
         ("C-(" . er/mark-outside-pairs)))

(use-package focus
  :defer 2)

(use-package crux
  :defer 2)

(use-package dired
  :straight nil
  :commands (dired dired-jump)
  :config
  (setq ;;dired-listing-switches "-agho --group-directories-first"
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
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (use-package diredfl
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
                              "h" 'dired-single-up-directory
                              "l" 'dired-single-buffer
                              "H" 'dired-omit-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :init
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

;; (use-package counsel-projectile
;; :after projectile
;; :config (counsel-projectile-mode))

(general-define-key
 :states 'normal
 :prefix "C-c"
 "p" 'projectile-command-map)

(general-define-key
 :states '(normal insert)
 "s-." 'flymake-goto-next-error
 "s->" 'flymake-goto-prev-error)

(use-package diff-hl)
(global-diff-hl-mode)
(diff-hl-flydiff-mode 1)
(diff-hl-dired-mode 1)
(diff-hl-margin-mode 1)

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package blamer
  ;;    :hook ((js2-mode . blamer-mode)
  ;;           (typescript-mode . blamer-mode))
  :custom
  (blamer-idle-time 0.1)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                   :background nil
                   :height 140
                   :italic t))))

(use-package vterm
  :commands vterm)
(use-package vterm-toggle
  :commands vterm-toggle)

(defun rr/projectile-run-vterm ()
  "Invoke `vterm' in the project's root."

  (interactive)
  (cond ((and
          (equal nil (projectile-project-root))
          (equal t (projectile-mode)))
         (vterm-toggle))
        (t (projectile-with-default-dir (projectile-acquire-root)
             (vterm-toggle)))))

(use-package graphql-mode
  :defer t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(use-package flycheck)

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(use-package web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(add-hook 'js2-mode-hook #'setup-tide-mode)
;; configure javascript-tide checker to run after your default javascript checker
;; (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)

(use-package web-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; configure jsx-tide checker to run after your default jsx checker
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
(add-hook 'js2-mode-hook #'setup-tide-mode)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(use-package tree-sitter)
(use-package tree-sitter-langs)

(add-hook 'typescript-mode-hook #'tree-sitter-hl-mode)

(use-package perspective
  :bind (("C-x k" . persp-kill-buffer*))
  :custom
  (persp-initial-frame-name "main")
  (persp-sort 'created)
  :init
  (persp-mode))

(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

(setq persp-state-default-file (concat user-emacs-directory "var/persp-auto-save"))
(add-hook 'kill-emacs-hook #'persp-state-save)

(defun rr/set-org-capture-templates ()
  `(("o" "Organize")
    ("ot" "Task" entry (file+olp, (rr/org-path "organize.org") "Tasks")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("oe" "Event" entry (file+olp, (rr/org-path "organize.org") "Events")
     "* TODO %?\n%U\n %i")
    ("og" "Guitar" entry (file+olp, (rr/org-path "organize.org") "Goals" "Guitar" "Practice Log")
     "* %u\n%?")
    ("w" "Work")
    ("wt" "Work Task" entry (file+olp, (rr/org-path "work-tasks.org") "All Tasks" "Overflow Tasks")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("wd" "Deep Task" entry (file+olp, (rr/org-path "work-tasks.org") "All Tasks" "Deep")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("ws" "Shallow Task" entry (file+olp, (rr/org-path "work-tasks.org") "All Tasks" "Shallow")
     "* TODO %?\n%U\n %i" :kill-buffer t)
    ("wi" "Work Inbox" entry (file+olp, (rr/org-path "work-tasks.org") "Inbox")
     "* %?\n%U\n %i")
    ("wm" "Work Meeting" entry (file+headline, (rr/org-path "work-tasks.org") "Meeting Notes")
     "* %?\n%U\n %i")
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
  (visual-line-mode 1)
  (setq org-directory "~/Library/CloudStorage/Dropbox/org-mode/")
  (setq org-agenda-files (list org-directory))
  (setq org-capture-templates (rr/set-org-capture-templates))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "CODE(c)" "FDBK(f)" "|" "DONE(d!)" "KILL(k!)")
          ))
  (setq org-id-link-to-org-use-id 'use-existing)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . rr/org-mode-setup)
  :commands (org-capture org-agenda)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-log-done 'time
        org-log-into-drawer t
        ;; org-adapt-indentation t
        org-element-use-cache nil
        org-agenda-start-with-log-mode t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-tags-column 100
        org-agenda-compact-blocks t
        org-agenda-include-diary t
        org-catch-invisible-edits 'smart
        org-fontify-whole-heading-line t
        org-ctrl-k-protect-subtree t
        org-cycle-separator-lines 0
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm
        org-refile-targets
        '((nil :maxlevel . 6)
          (org-agenda-files :maxlevel . 6)))

  (advice-add 'org-refile :after 'org-save-all-org-buffers))

(require 'org-indent)

(use-package ox-gfm
  :after org)

(use-package org-appear)
(add-hook 'org-mode-hook 'org-appear-mode)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun rr/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . rr/org-mode-visual-fill))

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
        ("w" "Work Tasks"
         ((agenda "" ((org-deadline-warning-days 7)))
          (tags-todo "+work-meeting"
                     ((org-agenda-overriding-header "Work Tasks")))
          ))
        ("%" "Appointments" agenda* "Today's appointments"
         ((org-agenda-span 1)
          (org-agenda-max-entries 3)))
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
  (if (equal (buffer-name) "PrivateConfig.org")
      (org-make-toc-mode)))

(add-hook 'find-file-hook 'rr/enable-org-make-toc-mode)

(setq org-todo-keyword-faces
      '(("WAIT" . (:foreground "#e6bf85" :weight bold))
        ("TODO" . (:foreground "#a0bc70" :weight bold))
        ("STRT" . (:foreground "#a7a2dc" :weight bold))
        ("HOLD" . (:foreground "#e6bf85" :weight bold))
        ("CODE" . (:foreground "#e6bf85" :weight bold))
        ("FDBK" . (:foreground "#e6bf85" :weight bold))
        ("IDEA" . (:foreground "#fdac37" :weight bold))
        ("DONE" . (:foreground "#5c6267" :weight bold))
        ("KILL" . (:foreground "#ee7570" :weight bold))))

(setq my-fixed-pitch-font "JetBrains Mono")
(setq my-variable-pitch-font "Raleway")

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil
                    :font my-fixed-pitch-font
                    :height 160
                    :weight 'light)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil
                    :font my-variable-pitch-font
                    :height 150
                    :weight 'regular)

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

  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
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
  (set-face-attribute 'org-column nil :background nil)
  (set-face-attribute 'org-column-title nil :background nil))

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

(general-define-key
 :states 'normal
 :keymaps 'org-mode-map
 "RET" '+org/dwim-at-point)

(general-define-key
 :states 'normal
 :keymaps 'org-mode-map
 "<tab>" 'evil-toggle-fold)

(defun +org--insert-item (direction)
  (let ((context (org-element-lineage
                  (org-element-context)
                  '(table table-row headline inlinetask item plain-list)
                  t)))
    (pcase (org-element-type context)
      ;; Add a new list item (carrying over checkboxes if necessary)
      ((or `item `plain-list)
       ;; Position determines where org-insert-todo-heading and org-insert-item
       ;; insert the new list item.
       (if (eq direction 'above)
           (org-beginning-of-item)
         (org-end-of-item)
         (backward-char))
       (org-insert-item (org-element-property :checkbox context))
       ;; Handle edge case where current item is empty and bottom of list is
       ;; flush against a new heading.
       (when (and (eq direction 'below)
                  (eq (org-element-property :contents-begin context)
                      (org-element-property :contents-end context)))
         (org-end-of-item)
         (org-end-of-line)))

      ;; Add a new table row
      ((or `table `table-row)
       (pcase direction
         ('below (save-excursion (org-table-insert-row t))
                 (org-table-next-row))
         ('above (save-excursion (org-shiftmetadown))
                 (+org/table-previous-row))))

      ;; Otherwise, add a new heading, carrying over any todo state, if
      ;; necessary.
      (_
       (let ((level (or (org-current-level) 1)))
         ;; I intentionally avoid `org-insert-heading' and the like because they
         ;; impose unpredictable whitespace rules depending on the cursor
         ;; position. It's simpler to express this command's responsibility at a
         ;; lower level than work around all the quirks in org's API.
         (pcase direction
           (`below
            (let (org-insert-heading-respect-content)
              (goto-char (line-end-position))
              (org-end-of-subtree)
              (insert "\n" (make-string level ?*) " ")))
           (`above
            (org-back-to-heading)
            (insert (make-string level ?*) " ")
            (save-excursion (insert "\n"))))
         (when-let* ((todo-keyword (org-element-property :todo-keyword context))
                     (todo-type    (org-element-property :todo-type context)))
           (org-todo
            (cond ((eq todo-type 'done)
                   ;; Doesn't make sense to create more "DONE" headings
                   (car (+org-get-todo-keywords-for todo-keyword)))
                  (todo-keyword)
                  ('todo)))))))

    (when (org-invisible-p)
      (org-show-hidden-entry))
    (when (and (bound-and-true-p evil-local-mode)
               (not (evil-emacs-state-p)))
      (evil-insert 1))))

(defun +org/insert-item-below (count)
  "Inserts a new heading, table cell or item below the current one."
  (interactive "p")
  (dotimes (_ count) (+org--insert-item 'below)))

(general-define-key
 :states '(normal insert)
 :keymaps 'org-mode-map
 "<C-return>" '+org/insert-item-below)

(defun +org/insert-item-above (count)
  "Inserts a new heading, table cell or item above the current one."
  (interactive "p")
  (dotimes (_ count) (+org--insert-item 'above)))

(general-define-key
 :states '(normal insert)
 :keymaps 'org-mode-map
 "<C-S-return>" '+org/insert-item-above)

(defun +org/refile-to-current-file (arg &optional file)
  "Refile current heading to elsewhere in the current buffer.
If prefix ARG, copy instead of move."
  (interactive "P")
  (let ((org-refile-targets `((,file :maxlevel . 10)))
        (org-refile-use-outline-path nil)
        (org-refile-keep arg)
        current-prefix-arg)
    (call-interactively #'org-refile)))

(general-define-key
 :states '(normal)
 :keymaps 'org-mode-map
 :prefix "z"
 "x" 'org-hide-drawer-toggle)

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

(general-define-key
 :states 'normal
 :keymaps 'org-mode-map
 "C-n" 'rr/org-show-next-heading-tidily
 "C-p" 'rr/org-show-previous-heading-tidily)

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
  :straight t
  :custom
  (org-roam-directory "~/Library/CloudStorage/Dropbox/roam-notes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n t" . org-roam-tag-add)
         )
  :config
  (org-roam-setup))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates) '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam-ui
  :straight
    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
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
    (setq-local title-line (thing-at-point 'line t))
    (unless (not (string-match "TODO " title-line))
      (let* ((lines (split-string title-line "TODO "))
             (blog-post-title (nth 1 lines))
             (file-name (replace-regexp-in-string "_+" "-" (replace-regexp-in-string "\\W" "_" (string-trim (downcase blog-post-title)))))
             (blog-post-file-name (concat file-name ".md")))
        (org-set-property "EXPORT_FILE_NAME" blog-post-file-name))))

(use-package excorporate
  :defer t
  :config
  (setq excorporate-diary-today-file
        (concat user-emacs-directory "var/excorporate/diary-excorporate-today")
        excorporate-diary-transient-file
        (concat user-emacs-directory "var/excorporate/diary-excorporate-transient")))
(excorporate-diary-enable)

(defun rr/show-work-cal-for-current-day ()
  "Show meetings for current day."
  (interactive)
  (exco-org-show-day
   (nth 0 (calendar-current-date))
   (nth 1 (calendar-current-date))
   (nth 2 (calendar-current-date)))
  (other-window 1)
  (sleep-for 1)
  (org-shifttab)
  (evil-toggle-fold))

(setq gc-cons-threshold (* 2 1000 1000))
