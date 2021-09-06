(setq user-full-name "Rajath Ramakrishna"
      user-mail-address "r.rajath@pm.me")

(setq gc-cons-threshold (* 50 1000 1000))

(defun rr/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'rr/display-startup-time)

(message "Trying to maximize frame")
(setq pixel-width (display-pixel-width))
(setq pixel-height (display-pixel-height))

(cond
 ((= pixel-width 1792)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))
 ((= pixel-width 5232)
  (progn
    (add-to-list 'default-frame-alist
                 (cons 'left 1720))
    (add-to-list 'default-frame-alist
                 (cons 'width 214))
    (add-to-list 'default-frame-alist
                 (cons 'height 81))
    )))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Fix an issue accessing the ELPA archive in Termux

;; (package-initialize)
;; (unless package-archive-contents
;;   (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(package-install 'use-package)
(require 'use-package)

;; Uncomment this to get a reading on packages that get loaded at startup
;;(setq use-package-verbose t)

;; On non-Guix systems, "ensure" packages by default
(setq use-package-always-ensure t)
(setq use-package-verbose t)

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

(global-subword-mode 1)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 0)
(menu-bar-mode -1)

(set-face-attribute 'default nil :font "JetBrains Mono" :height 125)

(use-package doom-modeline
  :ensure t
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

(column-number-mode)
(global-display-line-numbers-mode t)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smart-mode-line
  :config
  (setq
   sml/theme 'atom-one-dark
   sml/no-confirm-load-theme t
   sml/mode-width 'right
   sml/name-width 60)
  (sml/setup))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

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

(defun rr/comment-and-newline ()
  (interactive)
  (evilnc-comment-or-uncomment-lines 1)
  (evil-next-line))

(general-define-key
 :states '(normal insert)
 "s-/" 'rr/comment-and-newline)

(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

(use-package smartparens)
(smartparens-global-mode)

(use-package avy
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))

(use-package eros)
(eros-mode 1)

;; Making ESC key work like an ESC key by exiting/canceling stuff
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

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
 "RET" '(counsel-bookmark :which-key "bookmarks")
 "t"   '(vterm-toggle :which-key "vterm-popup")
 ;; commands
 "'"   '(:ignore t :which-key "commands")
 "' e" '(eros-eval-last-sexp :which-key "eros-eval-last-sexp")
 ;; buffer management
 "b"   '(:ignore t :which-key "buffers")
 "b i" '(ibuffer :which-key "ibuffer")
 "b r" '(revert-buffer :which-key "revert-buffer")
 "b k" '(kill-buffer :which-key "kill-buffer")
 ;; perspectives
 "s"   '(:ignore t :which-key "perspectives")
 "s b" '(persp-switch-to-buffer* :which-key "switch-to-buffer")
 "s k" '(persp-kill-buffer :which-key "kill-buffer")
 "s a" '(persp-add-buffer :which-key "add-buffer")
 "s A" '(persp-set-buffer :which-key "set-buffer")
 "s s" '(persp-switch :which-key "persp-switch")
 "s r" '(persp-rename :which-key "persp-rename")
 ;; dired
 "d"   '(:ignore t :which-key "dired")
 "d j" '(dired-jump :which-key "dired-jump")
 "d J" '(dired-jump-other-window :which-key "dired-jump-other-window")
 "d d" '(dired :which-key "dired")
 ;; window management
 "w"   '(:ignore t :which-key "window")
 "w v" '(split-window-right :which-key "split window right")
 "w h" '(split-window-below :which-key "split window below")
 "w c" '(delete-window :which-key "delete-window")
 "w w" '(next-window-any-frame :which-key "next window")
 ;; help for variables, functions, keybindings, etc.
 "h"   '(:ignore t :which-key "help")
 "h a" '(counsel-apropos :which-key "apropos")
 "h v" '(counsel-describe-variable :which-key "variable")
 "h f" '(counsel-describe-function :which-key "function")
 "h k" '(helpful-key :which-key "key")
 "h i" '(info :which-key "info")
 "h c" '(describe-key-briefly :which-key "describy-key-briefly")
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
 "o t" '(org-todo :which-key "org-todo")
 "o x" '(org-toggle-checkbox :which-key "org-toggle-checkbox")
 "o r" '(:ignore t :which-key "refile")
 "o r r" '(org-refile :which-key "org-refile")
 "o r A" '(org-archive-subtree :which-key "org-archive-subtree")
 "o h" '(org-toggle-heading :which-key "heading")
 "o i" '(org-toggle-item :which-key "item")
 "o o" '(counsel-outline :which-key "counsel-outline")
 "o S" '(org-show-todo-tree :which-key "org-show-todo-tree")
 ;; org-mode / date
 "o d" '(:ignore t :which-key "date/deadline")
 "o d s" '(org-schedule :which-key "org-schedule")
 "o d d" '(org-deadline :which-key "org-deadline")
 "o d t" '(org-time-stamp :which-key "org-time-stamp")
 "o d T" '(org-time-stamp-inactive :which-key "org-time-stamp-inactive")
 ;; org-mode / links
 "o l" '(:ignore t :which-key "links")
 "o l l" '(org-insert-link :which-key "org-insert-link")
 ;; projectile
 "p"   '(:ignore t :which-key "projectile")
 "p f" '(projectile-find-file :which-key "projectile-find-file")
 "p /" '(counsel-projectile-rg :which-key "counsel-projectile-rg")
 "p r" '(projectile-recentf :which-key "projectile-recentf")
 "p s" '(counsel-projectile-switch-project :which-key "projectile-switch-project")
 ;; files
 "f"   '(:ignore t :which-key "files")
 "f f" '(counsel-find-file :which-key "find file")
 "f r" '(counsel-recentf :which-key "recent files"))

(general-define-key
 :states '(normal insert)
 "C-e" 'evil-org-end-of-line
 "C-a" 'evil-org-beginning-of-line
 "C-n" 'evil-next-line
 "C-p" 'evil-previous-line)

(general-define-key
 :keymaps 'normal
 "s-]" 'persp-next
 "s-[" 'persp-prev)

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

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-f" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)
  (counsel-mode 1))

(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

(use-package orderless
  :after counsel
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package prescient
  :after counsel
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
  :after prescient
  :config
  (ivy-prescient-mode 1)
  (prescient-persist-mode 1))

(setq ivy-prescient-retain-classic-highlighting t)

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key helpful-function)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package expand-region
  :bind (("M-[" . er/expand-region)
         ("C-(" . er/mark-outside-pairs)))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :config
  (setq ;;dired-listing-switches "-agho --group-directories-first"
   dired-omit-files "^\\.[^.].*"
   dired-omit-verbose nil
   dired-hide-details-hide-symlink-targets nil
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
              (diredfl-mode 1)))

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
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package diff-hl)
(global-diff-hl-mode)
(diff-hl-flydiff-mode 1)
(diff-hl-dired-mode 1)
(diff-hl-margin-mode 1)

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package vterm
  :commands vterm)
(use-package vterm-toggle
  :commands vterm-toggle)

(defun rr/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (setq lsp-restart 'auto-restart)
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . rr/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-ui-sideline-show-code-actions t)
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (setq lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package prettier
  :after lsp)
(setq global-prettier-mode t)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2
        lsp-eslint-auto-fix-on-save t))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package perspective
  :bind (("C-x k" . persp-kill-buffer*))
  :custom
  (persp-initial-frame-name "main")
  :init
  (persp-mode))

(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

(setq persp-state-default-file "~/dotfiles/.emacs.d/persp-auto-save")
(add-hook 'kill-emacs-hook #'persp-state-save)

(defun rr/set-org-capture-templates ()
  `(("o" "Organize")
    ("ot" "Task" entry (file+olp, (rr/org-path "organize.org") "Tasks")
     "* TODO %?\n %U\n %a\n %i" :kill-buffer t)
    ("oe" "Event" entry (file+olp, (rr/org-path "organize.org") "Events")
     "* TODO %?\n %U\n %a\n %i")
    ("w" "Work")
    ("wt" "Work Task" entry (file+olp, (rr/org-path "work-tasks.org") "All Tasks")
     "* TODO %?\n %U\n %a\n %i" :kill-buffer t)
    ("j" "Journal" entry (file+datetree, (rr/org-path "journal.org"))
     "* %?\n")
    ("n" "Notes")
    ("nr" "Resource" entry (file+olp, (rr/org-path "refile.org") "Resources")
     "* %?\n %U\n %a\n %i")
    ("nc" "Curiosity" entry (file+olp, (rr/org-path "refile.org") "Curiosities")
     "* %?\n %U\n %a\n %i")
    ("no" "Other" entry (file+olp, (rr/org-path "refile.org") "Notes")
     "* %?\n %U\n %a\n %i")
    ("nw" "Work" entry (file+olp, (rr/org-path "work-tasks.org") "Inbox")
     "* %?\n %U\n %a\n %i")
    )
  )

(defun rr/org-path (path)
  (expand-file-name path org-directory))

(defun rr/org-mode-setup ()
  (org-indent-mode)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq org-directory "~/Dropbox/org-mode/")
  (setq org-agenda-files (list org-directory))
  (setq org-capture-templates (rr/set-org-capture-templates))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "|" "DONE(d!)" "KILL(k!)")
          ))
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . rr/org-mode-setup)
  :commands (org-capture org-agenda)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-log-done 'time
        org-log-into-drawer t
        org-agenda-start-with-log-mode t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-tags-column 100
        org-agenda-compact-blocks t
        org-catch-invisible-edits t
        org-refile-targets
        '((nil :maxlevel . 3)
          (org-agenda-files :maxlevel . 3)))

  (advice-add 'org-refile :after 'org-save-all-org-buffers))

(require 'org-indent)

(use-package org-appear)
(add-hook 'org-mode-hook 'org-appear-mode)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun rr/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . rr/org-mode-visual-fill))

(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

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
        ))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t))))

(setq org-confirm-babel-evaluate nil)

(with-eval-after-load 'org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

;; This may not be needed
(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; Automatically tangle PrivateConfig.org config file when we save it
(defun rr/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/dotfiles/.emacs.d/PrivateConfig.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'rr/org-babel-tangle-config)))

(setq org-todo-keyword-faces
      '(("WAIT" . (:foreground "#e6bf85" :weight bold))
        ("TODO" . (:foreground "#a0bc70" :weight bold))
        ("STRT" . (:foreground "#a7a2dc" :weight bold))
        ("HOLD" . (:foreground "#e6bf85" :weight bold))
        ("IDEA" . (:foreground "#fdac37" :weight bold))
        ("DONE" . (:foreground "#5c6267" :weight bold))
        ("KILL" . (:foreground "#ee7570" :weight bold))))

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
           ;; (+org--toggle-inline-images-in-subtree beg end)
           ;;(if (or image-overlays latex-overlays)
           ;;   (org-clear-latex-preview beg end)
           ;;(org--latex-preview-region beg end))
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

(general-define-key
 :states 'normal
 :keymaps 'org-mode-map
 "<tab>" '+org-cycle-only-current-subtree-h)

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

(setq gc-cons-threshold (* 2 1000 1000))
