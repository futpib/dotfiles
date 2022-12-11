
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))


(require 'cl)
(require 'cask)
(cask-initialize)
(require 'evil)
(require 'editorconfig)
(require 'company)
(require 'flycheck)
(require 'flycheck-flow)
(require 'flycheck-xo)
(require 'web-mode)

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
 '(safe-local-variable-values
   '((web-mode-markup-indent-offset . 2)
     (nxml-child-indent . 2)
     (nxml-child-indent . 4)))
 '(show-trailing-whitespace t)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree")))
 '(undo-tree-visualizer-diff t)
 '(undo-tree-visualizer-relative-timestamps nil)
 '(undo-tree-visualizer-timestamps t)
 '(web-mode-auto-quote-style nil))
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


(defun setup-tide-mode ()
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

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
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

