;; PACKAGE MANAGER CONFIGURATION
;; Configure package manager sources
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  )
(package-initialize)

;; USABILITY CONFIGURATION
;; Define a shortcut to edit the this init file
(defun find-user-init-file ()
  "Edit the `user-init-file' in another window"
  (interactive)
  (find-file user-init-file))
(global-set-key (kbd "C-c i") #'find-user-init-file)

;; Define a shortcut to reload this init file
(defun reload-user-init-file ()
  "Reload the `user-init-file'"
  (interactive)
  (load-file user-init-file))
(global-set-key (kbd "C-c r") #'reload-user-init-file)

;; Initialize use-package
(eval-when-compile (require 'use-package))

;; PACKAGE CONFIGURATION
;; Define tide setup function
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (eldoc-mode +1)
  (company-mode +1)
  (flycheck-mode +1)
  (tide-hl-identifier-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(use-package neotree
  :ensure t
  :after (all-the-icons)
  :bind ("<f8>" . 'neotree-toggle)  
  :config (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package magit
  :ensure t
  :bind ("C-x g" . 'magit-status))

(use-package projectile
  :ensure t
  :bind-keymap ("C-c p" . projectile-command-map)
  :config (projectile-mode +1))

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :config (setq js2-basic-offset 2))

(use-package typescript-mode
  :ensure t
  :config (setq typescript-indent-level 2))

(use-package web-mode
  :ensure t
  :after (add-node-modules-path)
  :mode ("\\.jsx\\'" "\\.tsx\\'")
  :hook
  (web-mode . #'add-node-modules-path)
  (web-mode . (lambda ()
		      (when (or (string-equal "tsx" (file-name-extension buffer-file-name))
				(string-equal "jsx" (file-name-extension buffer-file-name)))
			(setup-tide-mode))))
  :config
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2))

(use-package company
  :ensure t
  :config
  (setq company-tooltip-align-annotations t))

(use-package flycheck
  :ensure t
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode))

(use-package tide
  :ensure t
  :after (web-mode typescript-mode js2-mode company flycheck)
  :hook ((typescript-mode . #'setup-tide-mode)
	 (js2-mode . #'setup-tide-mode))
  :config
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append))

;; UI CONFIGURATION
;; Configure theme
(load-theme 'tango-plus t)

;; Configure line numbers
(add-hook 'prog-mode-hook 'linum-mode)

;; Configure autopair
(electric-pair-mode 1)
(show-paren-mode 1)

;; Configure ido
(ido-mode 1)
(setq ido-separator "\n")

;; Remove toolbar
(tool-bar-mode -1)

;; Set font face
(set-face-attribute 'default nil
		    ;; :family "Pragmata Pro"
		    :family "Monaco"		    
		    :height 120
		    :weight 'normal
		    :width 'normal)

;; Set default frame size
(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 120))

;; DO NOT TOUCH
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (add-node-modules-path neotree all-the-icons markdown-mode js2-mode ag tango-plus-theme magit company web-mode tide projectile use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
