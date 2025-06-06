(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'ac-js2)
(straight-use-package 'alchemist)
(straight-use-package 'ansi)
(straight-use-package 'async)
(straight-use-package 'auto-complete)
(straight-use-package 'cl-lib)
(straight-use-package 'cmake-mode)
(straight-use-package 'company)
(straight-use-package 'company-flow)
(straight-use-package 'company-box)
(straight-use-package 'csharp-mode)
(straight-use-package 'dash)
(straight-use-package 'dockerfile-mode)
(straight-use-package 'editorconfig)
(straight-use-package 'elixir-mode)
(straight-use-package 'emacs)
(straight-use-package 'epl)
(straight-use-package 'evil)
(straight-use-package 'f)
(straight-use-package 'faceup)
(straight-use-package 'flycheck)
(straight-use-package 'flycheck-flow)
(straight-use-package 'flycheck-haskell)
(straight-use-package
 '(flycheck-xo :type git :host github :repo "alexmurray/flycheck-xo"))
(straight-use-package 'flycheck-kotlin)
(straight-use-package 'flymake-easy)
(straight-use-package 'flymake-jshint)
(straight-use-package 'flymake-json)
(straight-use-package 'go-mode)
(straight-use-package 'goto-chg)
(straight-use-package 'gradle-mode)
(straight-use-package 'haskell-mode)
(straight-use-package 'hcl-mode)
(straight-use-package 'ht)
(straight-use-package 'jade-mode)
(straight-use-package 'js2-mode)
(straight-use-package 'js3-mode)
(straight-use-package 'julia-mode)
(straight-use-package 'kotlin-mode)
(straight-use-package 'less-css-mode)
(straight-use-package 'let-alist)
(straight-use-package 'lsp-mode)
(straight-use-package 'lv)
(straight-use-package 'magit)
(straight-use-package 'magit-popup)
(straight-use-package 'magit-section)
(straight-use-package 'magit-svn)
(straight-use-package 'marginalia)
(straight-use-package 'markdown-mode)
(straight-use-package 'nadvice)
(straight-use-package 'package-build)
(straight-use-package 'php-mode)
(straight-use-package 'pkg-info)
(straight-use-package 'popup)
(straight-use-package 'pos-tip)
(straight-use-package 'protobuf-mode)
(straight-use-package 'purescript-mode)
(straight-use-package 'racket-mode)
(straight-use-package 'rg)
(straight-use-package 'rainbow-mode)
(straight-use-package 'rjsx-mode)
(straight-use-package 'rust-mode)
(straight-use-package 's)
(straight-use-package 'seq)
(straight-use-package 'shut-up)
(straight-use-package 'simple-httpd)
(straight-use-package 'skewer-mode)
(straight-use-package 'spinner)
(straight-use-package 'string-inflection)
(straight-use-package 'tern)
(straight-use-package 'tide)
(straight-use-package 'transient)
(straight-use-package 'transpose-frame)
(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-indent)
(straight-use-package 'tree-sitter-langs)
(straight-use-package 'tsc)
(straight-use-package 'typescript-mode)
(straight-use-package 'undo-tree)
(straight-use-package 'vertico)
(straight-use-package 'web-beautify)
(straight-use-package 'web-mode)
(straight-use-package 'with-editor)
(straight-use-package 'yaml-mode)
(straight-use-package 'swift-mode)
(straight-use-package 'copilot)
(straight-use-package
 '(copilot-chat :host github :repo "chep/copilot-chat.el" :files ("*.el")))
(straight-use-package
 '(prisma-mode :type git :host github :repo "pimeys/emacs-prisma-mode"))

(require 'cl)
(require 'evil)
(require 'editorconfig)
(require 'company)
(require 'flycheck)
(require 'flycheck-flow)
(require 'flycheck-xo)
(require 'web-mode)
(require 'company-box)

(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . rjsx-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(wombat))
 '(evil-undo-system 'undo-tree)
 '(flycheck-javascript-flow-args nil)
 '(glyphless-char-display-control
   '((c0-control . acronym)
     (c1-control . acronym)
     (format-control . acronym)
     (variation-selectors . acronym)
     (no-font . acronym)))
 '(js2-mode-show-parse-errors nil)
 '(js2-mode-show-strict-warnings nil)
 '(js2-strict-cond-assign-warning nil)
 '(js2-strict-inconsistent-return-warning nil)
 '(js2-strict-missing-semi-warning nil)
 '(js2-strict-trailing-comma-warning nil)
 '(js2-strict-var-hides-function-arg-warning nil)
 '(js2-strict-var-redeclaration-warning nil)
 '(ring-bell-function 'ignore)
 '(safe-local-variable-values
   '((web-mode-markup-indent-offset . 2)
     (nxml-child-indent . 2)
     (nxml-child-indent . 4)))
 '(show-trailing-whitespace t)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree")))
 '(undo-tree-visualizer-diff t)
 '(undo-tree-visualizer-relative-timestamps nil)
 '(undo-tree-visualizer-timestamps t)
 '(visible-bell nil)
 '(web-mode-auto-quote-style nil)
 '(x-select-enable-clipboard-manager nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "white"))))
 '(ediff-even-diff-B ((t (:background "gray34"))))
 '(ediff-odd-diff-A ((t (:background "gray35"))))
 '(ediff-odd-diff-B ((t (:background "gray35"))))
 '(hl-line ((t (:background "black"))))
 '(js2-function-param ((t (:foreground "yellow green"))))
 '(region ((t (:background "#444444"))))
 '(smerge-refined-added ((t (:inherit smerge-refined-change :background "#446644"))))
 '(whitespace-newline ((t (:foreground "dim gray" :weight normal)))))

(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp")

(editorconfig-mode 1)

(tool-bar-mode -1)
(menu-bar-mode -1)

(vertico-mode)
(marginalia-mode)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(evil-set-initial-state 'ibuffer-mode 'normal)
(evil-set-initial-state 'bookmark-bmenu-mode 'normal)
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'sunrise-mode 'emacs)

;(global-auto-revert-mode nil)

(global-whitespace-mode t)
(setq whitespace-style
      (quote
       (spaces
        tabs
        newline
        space-mark
        tab-mark
        newline-mark
        trailing
        )))

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(global-hl-line-mode t)
(show-paren-mode 1)
(set-face-attribute hl-line-face nil :underline nil)
(set-face-attribute hl-line-face nil :background "black")
(set-face-attribute hl-line-face nil :foreground nil)

(setq web-mode-enable-current-element-highlight t)

(setq backup-directory-alist `(("." . "~/.emacs.d/backup")))

(setq company-idle-delay 0)

(add-hook 'rjsx-mode-hook
          (lambda ()
            (company-mode-on)))

(add-hook 'elixir-mode-hook
          (lambda ()
            (company-mode-on)
            (alchemist-mode)))

(add-hook 'css-mode-hook
          (lambda ()
            (company-mode-on)))

(add-hook 'company-mode-hook 'company-box-mode)

(defun setup-tide-mode ()
  "Setup tide mode."
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  (company-mode-on)
  (flycheck-add-next-checker 'typescript-tide 'javascript-eslint))

(add-hook 'racket-mode-hook
          (lambda ()
            (company-mode-on)))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
;; tide
(add-hook 'typescript-mode-hook 'setup-tide-mode)

;; company in php-mode
(add-hook 'php-mode-hook
          (lambda ()
            (company-mode-on)))

(add-hook 'rust-mode-hook
          (lambda ()
            (company-mode-on)))

(setq lsp-headerline-breadcrumb-enable nil)
(add-hook 'kotlin-mode-hook 'lsp)

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-tern 'company-flow))

(with-eval-after-load 'company
  ;; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends))

(add-hook 'prog-mode-hook 'copilot-mode)

(defun my/copilot-company-accept-or-indent-or-complete ()
  "Accept copilot or company completion, or indent if no completion is available."
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

(with-eval-after-load 'copilot
  (evil-define-key 'insert copilot-mode-map
    (kbd "<tab>") 'my/copilot-company-accept-or-indent-or-complete
    (kbd "C-<iso-lefttab>") 'copilot-previous-completion
    (kbd "C-<tab>") 'copilot-next-completion))

(with-eval-after-load 'rg
  (advice-add 'wgrep-change-to-wgrep-mode :after
          #'evil-normal-state)
  (advice-add 'wgrep-to-original-mode :after
          #'evil-motion-state)
  (defvar rg-mode-map)
  (add-to-list 'evil-motion-state-modes 'rg-mode)
  (evil-add-hjkl-bindings rg-mode-map 'motion
    "e" #'wgrep-change-to-wgrep-mode
    "g" #'rg-recompile
    "t" #'rg-rerun-change-literal))

(server-start)

(setq mouse-autoselect-window t)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with modes for files
(flycheck-add-mode 'javascript-eslint 'js2-mode)

(flycheck-add-next-checker 'javascript-flow 'javascript-eslint)

;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  "Use local eslint from node_modules before global."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/.bin/eslint"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers '(json-jsonlist)))

(windmove-default-keybindings 'meta)

(desktop-save-mode 1)

(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'intero-mode)

(flycheck-xo-setup)

;; use local xo from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-xo-executable
(defun my/use-xo-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (root2 (locate-dominating-file
                 (file-name-directory
                  (directory-file-name
                   (or root (buffer-file-name) default-directory)))
                 "node_modules"))
         (xo (car (remove-if-not
                   (lambda (x) (and x (file-exists-p x)))
                   (list
                    (and root
                         (expand-file-name "node_modules/.bin/xo"
                                           root))
                    (and root2
                         (expand-file-name "node_modules/.bin/xo"
                                           root2)))))))
    (when (and xo (file-executable-p xo))
      (setq-local flycheck-xo-executable xo))))
(add-hook 'flycheck-mode-hook #'my/use-xo-from-node-modules)

;; pretty symbols
(defun my/prettify-symbols-mode ()
  "Enable prettify symbols mode."
  (prettify-symbols-mode)
  (setq prettify-symbols-alist
        '(("function" . ?λ)
          ("<=" . ?≤)
          (">=" . ?≥))))

(add-hook 'typescript-mode-hook 'my/prettify-symbols-mode)
(add-hook 'rjsx-mode-hook
          (lambda ()
            (add-hook 'before-save-hook
                      (lambda ()
                        (if indent-tabs-mode
                            (tabify (point-min) (point-max))
                          (untabify (point-min) (point-max))
                          ))
                      nil
                      t)
            (my/prettify-symbols-mode)))

(setq create-lockfiles nil)

(add-hook 'racket-mode-hook 'prettify-symbols-mode)
(add-hook 'racket-mode-hook
          (lambda ()
            (setq prettify-symbols-alist
                  '(("lambda" . ?λ)))))

(setq create-lockfiles nil)

(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; provides nothing

