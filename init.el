;; Change the filename where the automated configuration lives in

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Package configuration

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Projectile configuration

(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; Ivy configuration

(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

;; Theme configuration

;; (use-package nord-theme
;;   :config (load-theme 'nord t))

;; (use-package tango-plus-theme
;;   :config (load-theme 'tango-plus t))

(use-package modus-themes
  :config (load-theme 'modus-operandi t))

;; Etsyweb development

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package which-key
  :config (which-key-mode))

(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

(use-package expand-region
  :bind (("C-=" . er/expand-region)
	 ("C--" . er/contract-region)))

(use-package php-mode)

(use-package web-mode
  :mode (("\\.js\\'" . web-mode)
	 ("\\.ts\\'" . web-mode)
	 ("\\.tsx\\'" . web-mode)
	 ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  :commands web-mode)

(use-package company
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 1)
  (global-company-mode t))

(use-package lsp-mode
  :hook ((php-mode . lsp-deferred)
	 (web-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp-deferred
  :config
  (setq lsp-log-io nil)
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-enable-snippet nil)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-show-code-actions t))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

;; org-mode configuration

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; Miscellaneous

(use-package smartparens
  :init (require 'smartparens-config)
  :config (add-hook 'prog-mode-hook 'smartparens-mode))
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq inhibit-startup-message t)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
