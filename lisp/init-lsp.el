;;; init-lsp --- lsp settings

;;; Commentary:
;;; (c)Cabins, github.com/cabins/.emacs.d

;;; Code:

(use-package lsp-mode
  ;; add prog-mode to lsp instead of adding one by one
  ;; :hook ((prog-mode . (lsp-deferred))
  :commands (lsp lsp-deferred)
  :hook ((lsp-mode . lsp-enable-which-key-integration)
	     (python-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (go-mode . lsp-deferred)
         (java-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (vue-mode . lsp-deferred)
         (html-mode . lsp-deferred))
  :init (setq lsp-keep-workspace-alive nil ;; Auto kill LSP server
              lsp-enable-indentation t
              lsp-enable-on-type-formatting t
              lsp-auto-guess-root nil
              lsp-enable-snippet t
              lsp-modeline-diagnostics-enable t
              lsp-idle-delay 0.500
              lsp-completion-provider :capf)
  :config
  ;; Configure LSP Clients
  (use-package lsp-clients
    :ensure nil
    :functions (lsp-format-buffer lsp-organize-imports)))

;;; Optionally: lsp-ui, company-lsp
(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :init (setq lsp-ui-doc-enable t
              lsp-ui-doc-use-webkit nil
              lsp-ui-doc-delay .3
              lsp-ui-doc-include-signature t
              lsp-ui-doc-position 'bottom ;; top/bottom/at-point
              lsp-eldoc-enable-hover nil ;; Disable eldoc displays in minibuffer
              lsp-ui-sideline-enable t
              lsp-ui-sideline-show-hover t
              lsp-ui-sideline-show-code-actions t
              lsp-ui-sideline-show-diagnostics t
              lsp-ui-sideline-ignore-duplicate t
              lsp-headerline-breadcrumb-enable t)
  :config
  (setq lsp-ui-flycheck-enable nil)
  (treemacs-resize-icons 14))


(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :init (treemacs-resize-icons 14))

(use-package dap-mode
  :diminish
  :hook ((lsp-mode . dap-mode)
         (dap-mode . dap-ui-mode)
	     (dap-mode . dap-tooltip-mode)
         (python-mode . (lambda() (require 'dap-python)))
         (go-mode . (lambda() (require 'dap-go)))
         (java-mode . (lambda() (require 'dap-java)))))


;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :interpreter
    ("scala" . scala-mode))

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
)

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode . lsp)
         (lsp-mode . lsp-lens-mode)
  :config (setq lsp-prefer-flymake nil))

;; Add metals backend for lsp-mode
(use-package lsp-metals
  :config (setq lsp-metals-treeview-show-when-views-received t))

;; Enable nice rendering of documentation on hover
(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Add company-lsp backend for metals
(use-package company-lsp)

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package posframe
  ;; Posframe is a pop-up tool that must be manually installed for dap-mode
  )
(use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
  )

(provide 'init-lsp)

;;; init-lsp.el ends here
