;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq doom-localleader-key "'")

;; (advice-add #'doom-load-session :ignore)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font
      (font-spec :family "CaskaydiaCove Nerd Font" :size 12)
      doom-big-font
      (font-spec :family "JetBrainsMono Nerd Font" :size 22)
      doom-variable-pitch-font
      (font-spec :family "Overpass" :size 12))

(advice-add 'doom/load-session :override #'ignore)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-wilmersdorf)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type nil)
(setq-default truncate-lines t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;
;;
;;
;;
;;

;; don't ask for risky variables in dir-locals
(progn (advice-add 'risky-local-variable-p :override #'ignore)
       (setq enable-local-variables t enable-local-eval t))

(after! evil-collection (setq evil-collection-mode-list (delete 'lispy evil-collection-mode-list)))





;; deactived for now (dont need)
;; (add-hook! window-setup #'doom/quickload-session)
;; (add-hook! kill-emacs #'doom/quicksave-session)

(after! magit
  (map! :leader :n "ag" #'magit-status)
  (magit-auto-revert-mode +1)
  (global-auto-revert-mode +1)
  (setq magit-git-global-arguments
        '("--no-pager" "-c" "core.preloadindex=true" "-c" "log.showSignature=false" "-c" "color.ui=false" "-c" "color.diff=false"))
  (magit-wip-mode +1)
  (map! :map magit-mode-map :n "RET" #'magit-diff-visit-worktree-file)
  (defun qleguennec/commit-to-wip ()
    (interactive)
    (magit-with-toplevel
      (dolist (file (magit-unstaged-files))
        (magit-stage-file file))
      (magit-run-git "commit" (concat "--message=[wip " (format-time-string "%Y-%m-%d %H:%M") "]")))))

(map! :leader :n "h." #'helpful-at-point)

(map! :leader :n "o e" #'projectile-run-shell)

(map! :n "gp" #'profiler-start
      :n "gP" #'profiler-stop)

(setq evil-vsplit-window-right t evil-split-window-below t evil-escape-key-sequence nil)

(defun insert-random-uuid ()
  "Insert a UUID.
This commands calls “uuidgen” on MacOS, Linux, and calls PowelShell on Microsoft Windows.
URL `http://ergoemacs.org/emacs/elisp_generate_uuid.html'
Version 2020-06-04"
  (interactive)
  (let ((uuid (string-trim-right (shell-command-to-string "uuidgen"))))
    (kill-new (concat ":" uuid))
    (insert uuid)))

(setq warning-suppress-types '((yasnippet backquote-change)))

(defun recenter-and-blink (&rest _ignore) (doom-recenter-a) (+nav-flash-blink-cursor))
(advice-add #'+lookup/definition :after #'recenter-and-blink)

(defun join-lines-after-delete (&rest _ignore) (interactive) (delete-blank-lines))

(after! lispy
  (advice-add #'lispy-up :after #'doom-recenter-a)
  (advice-add #'lispy-down :after #'doom-recenter-a)
  (advice-add #'lispy-move-down :after #'doom-recenter-a)
  (advice-add #'lispy-move-up :after #'doom-recenter-a)
  (setq lispy-eval-display-style 'overlay)
  (map! :map lispy-mode-map :i "[" #'lispy-brackets :i "{" #'lispy-braces))

(after! lispyville
  :config
  (add-hook 'lispyville-delete #'join-lines-after-delete)
  (add-hook 'lispyville-delete-whole-line #'join-lines-after-delete)
  (add-hook 'lispyville-delete-line #'join-lines-after-delete))

(after! projectile
  (setq projectile-project-name-function
        (lambda (project-root)
          (let ((project-root (projectile-project-root))
                (wp-split (split-string project-root "wp/")))
            (if (= 2 (length wp-split))
                (replace-regexp-in-string "/$" "" (cadr wp-split))
              (projectile-default-project-name project-root)))))
  (setq projectile-use-git-grep t)
  (setq projectile-enable-caching nil)
  (setq projectile-indexing-method 'alien)
  (setq projectile-project-root-functions
        #'(projectile-root-top-down projectile-root-top-down-recurring
                                    projectile-root-bottom-up
                                    projectile-root-local)))

(advice-add 'evil-window-up
            :after
            (lambda (arg)
              (when (string-equal " *NeoTree*" (buffer-name (current-buffer)))
                (evil-window-right 1))))

(after! flycheck :config (advice-add #'flycheck-next-error :after #'recenter-and-blink))

(after! evil
  (require 'evil-textobj-anyblock)
  (evil-define-text-object my-evil-textobj-anyblock-inner-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'") ("\"" . "\"") ("`" . "`") ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count nil)))
  (evil-define-text-object my-evil-textobj-anyblock-a-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'") ("\"" . "\"") ("`" . "`") ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count t)))
  (define-key evil-inner-text-objects-map "q" 'my-evil-textobj-anyblock-inner-quote)
  (define-key evil-outer-text-objects-map "q" 'my-evil-textobj-anyblock-a-quote)
  (advice-add 'evil-scroll-line-to-center :after #'recenter-and-blink)
  (advice-add 'evil-backward-paragraph :after #'recenter-and-blink)
  (advice-add 'evil-forward-paragraph :after #'recenter-and-blink)
  (advice-add 'evil-ex-search-next :after #'recenter-and-blink)
  (advice-add 'evil-ex-search-previous :after #'recenter-and-blink)
  (advice-add 'evil-goto-line :after #'recenter-and-blink)
  (advice-add 'evil-goto-line :after #'recenter-and-blink)
  (advice-add 'evil-forward-section-begin :after #'recenter-and-blink)
  (advice-add 'evil-forward-section-end :after #'recenter-and-blink)
  (advice-add 'evil-backward-section-begin :after #'recenter-and-blink)
  (advice-add 'evil-backward-section-end :after #'recenter-and-blink)
  (map! :n
        "'"
        #'evil-use-register
        :n
        "{"
        #'evil-backward-section-begin
        :n
        "}"
        #'evil-forward-section-begin
        :nvi
        "C-/"
        #'evil-search-forward
        :nvi
        "C-j"
        (cmd! () (save-excursion (evil-beginning-of-line)))))

(after! evil-snipe :config (setq evil-snipe-scope 'whole-buffer))

(after! lsp-mode
  (remove-hook 'lsp-mode-hook #'lsp-ui-mode)
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\resources\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\target\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\node-modules\\'")
  (map! :n
        "C-/" #'lsp-find-references))

(after! cider
  ;; (add-hook 'company-completion-started-hook 'ans/set-company-maps)
  ;; (add-hook 'company-completion-finished-hook 'ans/unset-company-maps)
  ;; (add-hook 'company-completion-cancelled-hook 'ans/unset-company-maps)
  (remove-hook 'cider-mode-hook #'rainbow-delimiters-mode)
  (remove-hook 'clojure-mode-hook #'rainbow-delimiters-mode)

  ;; (add-hook 'clojure-mode-hook #'lsp)
  ;; (add-hook 'clojurescript-mode-hook #'lsp)

  (setq clojure-toplevel-inside-comment-form t)
  (setq cider-show-error-buffer nil)
  (map! :map lsp-mode-map
        :nv "gd" #'lsp-find-definition
        :nv "C-/" #'lsp-find-references)

  (defun qleguennec/avoid-compiled (filename)
    (if (s-matches? ".*/resources/public/cljs-out/dev.*" filename)
        (s-replace "/resources/public/cljs-out/dev"
                   "/src/cljs"
                   filename)
      filename))

  ;; (defadvice! lsp-xrefs-no-compiled (oldfunc locations)
  ;;   :around #'lsp--locations-to-xref-items
  ;;   (let* ((uri (gethash "uri" locations)))
  ;;     (remhash "uri" locations)
  ;;     (puthash "uri" (qleguennec/avoid-compiled uri)
  ;;              locations)
  ;;     (funcall oldfunc locations)))
  ;; (advice-remove 'lsp--locations-to-xref-items #'lsp-xrefs-no-compiled)

  (defun clojure-before-save-hook (&rest _args)
    (when (and (fboundp #'alix-controller/zprint-file)
               (or
                (equal major-mode 'clojure-mode)
                (equal major-mode 'clojurescript-mode)))
      ;; (alix-controller/zprint-file)
      ))

  (add-hook 'before-save-hook
            #'clojure-before-save-hook)

  (setq cljr-auto-clean-ns nil cljr-auto-sort-ns nil)
  ;; (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  ;; (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
  (set-popup-rules! '(("^\\*cider-inspect" :vslot 2 :ttl nil :quit nil)
                      ("^\\*cider-result*" :slot 1 :vslot 1 :quit nil :select t)))
  ;; (remove-hook 'before-save-hook #'cider/indent-before-save)
  (defun indent-after-paste
      (&rest _ignore)
    (call-interactively #'+evil/reselect-paste)
    (call-interactively #'evil-indent-line)
    (call-interactively #'evil-indent)
    (call-interactively #'evil-first-non-blank)
    (when cider-mode (call-interactively #'clojure-align)))
  (advice-add 'evil-paste-after :after #'indent-after-paste)
  (advice-add 'evil-paste-before :after #'indent-after-paste)
  (setq cider-font-lock-reader-conditionals
        nil
        cider-font-lock-dynamically
        '(macro core)
        cider-inspector-auto-select-buffer
        nil
        cider-save-file-on-load
        t
        cider-prompt-for-symbol
        nil)
  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
  (defun ans/unset-company-maps
      (&rest unused)
    "Set default mappings (outside of company).
    Arguments (UNUSED) are ignored."
    (general-def :states
      'insert
      :keymaps
      'override
      "<up>"
      nil
      "<down>"
      nil
      "C-j"
      nil
      "C-k"
      nil
      "RET"
      nil
      "*"
      nil
      [return]
      nil))

  (defun ans/set-company-maps
      (&rest unused)
    "Set maps for when you're inside company completion.
    Arguments (UNUSED) are ignored."
    (general-def :states
      'insert
      :keymaps
      'override
      "<down>"
      'company-select-next
      "<up>"
      'company-select-previous
      "C-j"
      'company-select-next
      "C-k"
      'company-select-previous
      "RET"
      'company-complete
      "*"
      'counsel-company
      [return]
      'company-complete))
  (setq nrepl-log-messages t)
  (map! :map
        cider-repl-mode-map
        :ni
        "<down>"
        #'cider-repl-forward-input
        :ni
        "<up>"
        #'cider-repl-backward-input)
  (map! :map cider-inspector-mode-map :ni "<mouse-8>" #'cider-inspector-pop)
  (map! :map cider-mode-map :localleader "e D" #'cider-debug-defun-at-point)
  (remove-hook 'cider-connected-hook #'+clojure--cider-dump-nrepl-server-log-h))

(defun qleguennec/set-frame-transparency (&optional frame)
  (interactive)
  (let ((frame (or frame (selected-frame))))
    (set-frame-parameter frame 'alpha-background 80)))

(dolist (frame (visible-frame-list))
  (qleguennec/set-frame-transparency frame))

(add-to-list 'after-make-frame-functions
             #'qleguennec/set-frame-transparency)

;; (map! :n "C-l" #'+workspace/switch-right :n "C-h" #'+workspace/switch-left)

(map! :map emacs-lisp-mode-map :localleader "e D" #'edebug-defun)
(map! :leader
      :nv "w v" (lambda! ()
                         (call-process "i3-msg" nil 0 nil "split" "h")
                         (make-frame))
      :nv "w s" (lambda! ()
                    (call-process "i3-msg" nil 0 nil "split" "v")
                    (make-frame)))

(after! company
  :config
  (setq company-echo-last-msg 't)
  (map!
   :map company-active-map
   "`"
   #'counsel-company))

;; (use-package wgrep :config (setq wgrep-change-readonly-file t))

(use-package marginalia
  :config
  (marginalia-mode +1)
  (setq marginalia-annotators '(marginalia-annotators-heavy))
  :bind
  (:map minibuffer-local-map ("M-a" . marginalia-cycle)))

(use-package embark
  :bind   (("C-S-a" . embark-act) ;; pick some comfortable binding
           ("C-h B" . embark-bindings) ;; alternative for `describe-bindings'
           ("C-e" . embark-export))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :after  (embark consult)
  :demand t        ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook   (embark-collect-mode . embark-consult-preview-minor-mode))

(use-package consult
  :demand t
  :init
  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0 register-preview-function #'consult-register-format)
  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)
  :config
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'xref--show-xref-buffer xref-show-definitions-function #'xref-show-definitions-buffer)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root)
  (setq consult-git-grep-command
        (concat
         "git --no-pager grep --null --color=always --extended-regexp   --line-number -I -e ARG OPTS"
         " -- :!orientdb-community-importers-2.2.37"))
  (map! :vn
        "?"
        #'consult-git-grep
        :n
        "/"
        #'consult-line
        :n
        "SPC '"
        #'selectrum-repeat
        :leader
        "i m"
        #'consult-global-mark
        :leader
        "i i"
        #'consult-imenu-multi))



(use-package orderless
  :init   (icomplete-mode)                ; optional but recommended!
  :custom (completion-styles '(orderless)))





(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project)
  (map!
   :map centaur-tabs-mode-map
   "C-l" #'centaur-tabs-forward
   "C-h" #'centaur-tabs-backward))

(defun qleguennec/put-file-name-on-clipboard ()
  "Put the current file name on the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode) default-directory (buffer-file-name))))
    (when filename
      (with-temp-buffer (insert filename) (clipboard-kill-region (point-min) (point-max)))
      (message filename))))



(advice-add #'evil-next-line :after #'doom-recenter-a)
(advice-add #'evil-previous-line :after #'doom-recenter-a)

(setq frame-title-format
      '((:eval (if (equal major-mode 'dired-mode)
                   default-directory
                 (buffer-file-name)))
        " – Doom Emacs"))

(defun qleguennec/cycle-themes ()
  (interactive)
  (let* ((sorted-themes (->> (custom-available-themes)
                             (-filter (lambda (theme)
                                        (and (not (-contains?
                                                   '(doom-tomorrow-day
                                                     doom-flatwhite
                                                     doom-homage-white)
                                                   theme))
                                             (let ((theme (symbol-name theme)))
                                               (and (s-starts-with? "doom" theme)
                                                    (not (s-ends-with? "light" theme)))))))
                             (-sort #'string< )))
         (themes-from-current (-drop-while (lambda (theme) (not (eq doom-theme theme))) sorted-themes))
         (next-theme (cadr (append themes-from-current sorted-themes))))
    (message (symbol-name next-theme))
    (setq doom-theme next-theme)
    (load-theme next-theme t)
    (doom/reload-theme)))

(defun qleguennec/toggle-transparency (&optional frame)
  (interactive)
  (let* ((frame (or frame (selected-frame)))
         (alpha (frame-parameter frame 'alpha)))
    (set-frame-parameter
     frame 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))

(map!
 :leader
 :nvi "h h" #'qleguennec/cycle-themes)

(defun qleguennec/prettier-parens:fontify-search (limit)
  (let ((result nil)
        (finish nil)
        (bound (+ (point) limit)))
    (while (not finish)
      (if (re-search-forward "\\s)" bound t)
          (when (and (= 0 (string-match-p "\\s)*$" (buffer-substring-no-properties (point) (line-end-position))))
                     (not (eq (char-before (1- (point))) 92)))
            (setq result (match-data)
                  finish t))
        (setq finish t)))
    result))

(defface qleguennec/prettier-parens:dim-paren-face
  '((((class color) (background dark))
     (:foreground "grey30"))
    (((class color) (background light))
     (:foreground "grey60")))
  "Prettier parens"
  :group 'prettier-parens)


(define-minor-mode prettier-parens-mode
  "Prettier parens mode."
  :init-value nil
  (if prettier-parens-mode
      (progn (rainbow-delimiters-mode-disable)
             (font-lock-add-keywords
              nil '((qleguennec/prettier-parens:fontify-search . 'qleguennec/prettier-parens:dim-paren-face)))
             (if (fboundp 'font-lock-flush)
                 (font-lock-flush)
               (when font-lock-mode
                 (with-no-warnings
                   (font-lock-fontify-buffer)))))
    (progn
      (font-lock-remove-keywords nil
                                 '((qleguennec/prettier-parens:fontify-search . 'qleguennec/prettier-parens:dim-paren-face)))
      (if (fboundp 'font-lock-flush)
          (font-lock-flush)
        (when font-lock-mode
          (with-no-warnings
            (font-lock-fontify-buffer)))))))

(add-hook! '(clojure-mode-hook clojurescript-mode-hook emacs-lisp-mode-hook)
  (defun enable-lisp-modes (&rest args)
    (prettier-parens-mode)))
