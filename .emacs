
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(require 'cl)

(require 'cask)
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(wombat))
 '(evil-undo-system 'undo-tree)
 '(js2-mode-show-parse-errors nil)
 '(js2-mode-show-strict-warnings nil)
 '(js2-strict-cond-assign-warning nil)
 '(js2-strict-inconsistent-return-warning nil)
 '(js2-strict-missing-semi-warning nil)
 '(js2-strict-trailing-comma-warning nil)
 '(js2-strict-var-hides-function-arg-warning nil)
 '(js2-strict-var-redeclaration-warning nil)
 '(linum-relative-current-symbol "")
 '(safe-local-variable-values
   (quote
    ((web-mode-markup-indent-offset . 2)
     (nxml-child-indent . 2)
     (nxml-child-indent . 4))))
 '(show-trailing-whitespace t))
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

(require 'evil)
(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'editorconfig)
(editorconfig-mode 1)

(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

(tool-bar-mode -1)
(menu-bar-mode -1)

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

(global-linum-mode 1)
(linum-relative-global-mode 1)
(global-hl-line-mode t)
(show-paren-mode 1)
(set-face-attribute hl-line-face nil :underline nil)
(set-face-attribute hl-line-face nil :background "black")
(set-face-attribute hl-line-face nil :foreground nil)

(setq web-mode-enable-current-element-highlight t)

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

(setq backup-directory-alist `(("." . "~/.emacs.d/backup")))

(require 'company)
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

;; tide
(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode +1)
            ;; company is an optional dependency. You have to
            ;; install it separately via package-install
            (company-mode-on)))

;; company in php-mode
(add-hook 'php-mode-hook
          (lambda ()
            (company-mode-on)))

(add-hook 'rust-mode-hook
          (lambda ()
            (company-mode-on)))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-tern 'company-flow))

(server-start)

(setq mouse-autoselect-window t)

;; flycheck
;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with modes for files
(flycheck-add-mode 'javascript-eslint 'js2-mode)

(require 'flycheck-flow)
(flycheck-add-next-checker 'javascript-flow 'javascript-eslint)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers '(json-jsonlist)))

(windmove-default-keybindings 'meta)

(desktop-save-mode 1)

(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'intero-mode)

(require 'flycheck-xo)
(flycheck-xo-setup)

;; pretty symbols
(add-hook 'rjsx-mode-hook 'prettify-symbols-mode)
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
            (setq prettify-symbols-alist
                  '(("function" . ?λ)
                    ("<=" . ?≤)
                    (">=" . ?≥)))))

;; provides nothing

