(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages
   (quote
    (web-beautify evil-magit magit-svn magit tidy php-mode auto-complete ac-js2 csharp-mode web-mode less-css-mode jade-mode evil js2-mode)))
 '(safe-local-variable-values
   (quote
    ((web-mode-markup-indent-offset . 2)
     (nxml-child-indent . 2)
     (nxml-child-indent . 4)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-even-diff-B ((t (:background "gray34"))))
 '(ediff-odd-diff-A ((t (:background "gray35"))))
 '(ediff-odd-diff-B ((t (:background "gray35"))))
 '(hl-line ((t (:background "black"))))
 '(js2-function-param ((t (:foreground "yellow green"))))
 '(region ((t (:background "#444444"))))
 '(whitespace-newline ((t (:foreground "dim gray" :weight normal)))))

(require 'evil)
(evil-mode 1)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

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
(global-hl-line-mode t)
(set-face-attribute hl-line-face nil :underline nil)
(set-face-attribute hl-line-face nil :background "black")
(set-face-attribute hl-line-face nil :foreground nil)

(add-hook 'js2-mode-hook 'ac-js2-mode)

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

(setq backup-directory-alist `(("." . "~/.emacs-saves")))

