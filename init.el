;;; init.el --- Emacs configuration of kalashnikov66p -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; encoding
(prefer-coding-system 'utf-8-unix)
(set-language-environment "UTF-8")
(setq iso-transl-char-map nil)

;; debug
(setq debug-on-error t)

;; enable SPC inside minibuffer
(define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)

;; directories
(defvar user-cache-directory (expand-file-name ".cache" user-emacs-directory))
(defvar user-backup-directory (expand-file-name "backup" user-emacs-directory))
(defvar user-autosave-directory (expand-file-name "autosave" user-emacs-directory))

;; create directories
(make-directory user-cache-directory t)
(make-directory user-backup-directory t)
(make-directory user-autosave-directory t)

;; backup and autosave directories - https://emacs.stackexchange.com/a/36
(setq backup-directory-alist `(("." . ,user-backup-directory))
      auto-save-filename-transforms `(("." ,user-autosave-directory t))
      auto-save-list-file-prefix (concat user-autosave-directory ".saves-")
      tramp-backup-directory-alist `((".*" . ,user-backup-directory))
      tramp-auto-save-directory user-autosave-directory)

;; backup options
(setq backup-by-copying t
      delete-old-versions t
      version-control t
      kept-new-versions 5
      kept-old-versions 2)

;; custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(ignore-errors (load custom-file))

;; don't load outdated byte code
(setq load-prefer-newer t)

;; display line numbers
(global-display-line-numbers-mode 1)

;; disable home screen, scroll bar, menu bar and tool bar
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; repositories
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)

;; bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; use-package package
(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t
	use-package-always-ensure t))

;; doom-themes package
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-one-light t)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; doom-modeline package
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; smartparens package
(use-package smartparens
  :ensure t
  :hook (emacs-lisp-mode . smartparens-mode)
  :config
  (require 'smartparens-config))

;; company package
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; company-box package
(use-package company-box
  :ensure t
  :after (company)
  :hook (company-mode . company-box-mode))

;; flycheck package
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode))

;; flycheck-popup-tip package
(use-package flycheck-popup-tip
  :ensure t
  :after (flycheck)
  :hook (flycheck-mode . flycheck-popup-tip-mode)
  :config
  (setq flycheck-popup-tip-error-prefix "X "))

;; flycheck-posframe package
(use-package flycheck-posframe
  :ensure t
  :after (flycheck)
  :hook (flycheck-mode . flycheck-posframe-mode))

;; ivy package
(use-package ivy
  :ensure t
  :init
  (ivy-mode)
  :config
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)
	 ("C-c C-r" . ivy-resume)
	 ("<f6>" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("<f1> f" . counsel-describe-function)
	 ("<f1> v" . counsel-describe-variable)
	 ("<f1> o" . counsel-describe-symbol)
	 ("<f1> l" . counsel-find-library)
	 ("<f2> i" . counsel-info-lookup-symbol)
	 ("<f2> u" . counsel-unicode-char)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c k" . counsel-ag)
	 ("C-x l" . counsel-locate)
	 ("C-S-o" . counsel-rhythmbox)))

;; magit package
(use-package magit
  :ensure t)

;; projectile package
(use-package projectile
  :ensure t
  :init
  (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; treemacs package
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;; treemacs-projectile package
(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

;; treemacs-magit package
(use-package treemacs-magit
  :ensure t
  :after (treemacs magit))

;; which-key package
(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-bottom))

;; org package
(use-package org
  :config
  (setq org-directory (file-truename "~/org/")))

;; org-roam package
(use-package org-roam
  :ensure t
  :after (org)
  :custom
  (org-roam-directory (file-truename "~/org/"))
  (org-roam-dailies-directory "daily/")
  (org-roam-complete-everywhere t)
  (org-adapt-indentation t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "${slug}.org" "#+title: ${title}\n#+date: %<%Y-%m-%d>\n")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n g" . org-roam-graph)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n j" . org-roam-dailies-capture-today)
	 ("C-c n u" . org-roam-ui-mode))
  :bind-keymap ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-enable))

;; org-roam-ui package
(use-package org-roam-ui
  :ensure t
  :after (org-roam)
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t
	org-roam-ui-open-on-start t))

;; org-bullets package
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

;; deft package
(use-package deft
  :ensure t
  :after (org org-roam)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-roam-directory)
  :bind ("C-c n d" . deft))

;; ivy-bibtex package
(use-package ivy-bibtex
  :ensure t
  :init
  (setq bibtex-completion-bibliography '("~/bib/kalashnikovLib.bib")
	bibtex-completion-notes-path "~/org/notes/"
	bibtex-completion-pdf-field "file"
	bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"
	bibtex-completion-additional-search-fields '(keywords)
	bibtex-completion-display-formats
	'((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	  (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	  (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
	bibtex-completion-pdf-open-function
	(lambda (fpath)
	  (call-process "open" nil 0 nil fpath))))

;; org-ref package
(use-package org-ref
  :ensure t
  :init
  (require 'bibtex)
  (setq bibtex-autokey-year-length 4
	bibtex-autokey-name-year-separator "-"
	bibtex-autokey-year-title-separator "-"
	bibtex-autokey-titleword-separator "-"
	bibtex-autokey-titlewords 2
	bibtex-autokey-titlewords-stretch 1
	bibtex-autokey-titleword-length 5)
  (define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)
  (define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)
  (define-key org-mode-map (kbd "s-[") 'org-ref-insert-link-hydra/body)
  (require 'org-ref-ivy)
  (require 'org-ref-arxiv)
  (require 'org-ref-scopus)
  (require 'org-ref-wos)
  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
	org-ref-insert-cite-function 'org-ref-cite-insert-ivy
	org-ref-insert-label-function 'org-ref-insert-label-link
	org-ref-insert-ref-function 'org-ref-insert-ref-link
	org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))

;; centaur-tabs package
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :init
  (setq centaur-tabs-set-icons t
	centaur-tabs-style "bar"
	centaur-tabs-height 32
	centaur-tabs-gray-out-icons 'buffer
	centaur-tabs-set-bar 'left
	centaur-tabs-set-modified-marker t
	centaur-tabs-close-button "✕"
	centaur-tabs-modified-marker "•"
	centaur-tabs-cycle-scope 'tabs)
  :bind (("C-<prior>" . centaur-tabs-backward)
	 ("C-<next>" . centaur-tabs-forward)))

;;; init.el ends here
