(require 'package) ;; You might already have this line
;(add-to-list 'package-archives
;             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize) ;; You might already have this line
(setq package-list '(org-bullets magit company company-auctex company-coq company-flx company-c-headers flycheck flycheck-color-mode-line langtool monokai-theme org auctex-latexmk biblio company-math projectile helm-core helm flyspell flyspell-correct flyspell-correct-helm auto-dictionary ace-flyspell helm-projectile helm-flx helm-flycheck helm-bibtex helm-company magit-annex magit-gitflow diff-hl auto-package-update cmake-mode rtags flycheck-rtags helm-rtags bnfc markdown-mode))
; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'cmake-mode)

;;; helm
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)
(helm-flx-mode +1)
(eval-after-load 'flycheck
   '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (global-set-key (kbd "M-y") 'helm-show-kill-ring)
     (global-set-key (kbd "C-x C-f") 'helm-find-files)
     ))


;;; C++
(require 'company)
;(add-to-list 'company-backends 'company-c-headers)
;(add-to-list 'company-c-headers-path-system "/usr/include/c++/6.3.1/")

(require 'flycheck-rtags)
;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun my-flycheck-rtags-setup ()
  (interactive)
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

;; c-mode-common-hook is also called by c++-mode
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)
(add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)

(add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-common-hook 'rtags-start-process-unless-running)

(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)
(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
(rtags-enable-standard-keybindings)
(require 'helm-rtags)
(setq rtags-use-helm t)

(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))


(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;;; flyspell
(dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
    (dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))
  (add-hook 'c++-mode-hook
          (lambda ()
            (flyspell-prog-mode)
            ; ...
          ))

(require 'flyspell-correct-helm)
(define-key flyspell-mode-map (kbd "C-;") 'flyspell-correct-previous-word-generic)

(require 'auto-dictionary)
(add-hook 'flyspell-mode-hook (lambda () (auto-dictionary-mode 1)))

(require 'ace-flyspell)
(ace-flyspell-setup)

;;;; org mode
;; nice bullet points
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))



;(autoload 'latex-math-preview-expression "latex-math-preview" nil t)
;  (autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
;  (autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
;(autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coq-unicode-tokens-enable t)
 '(markdown-asymmetric-header t)
 '(markdown-coding-system (quote utf-8))
 '(markdown-command "cmark")
 '(package-selected-packages
   (quote
    (org langtool ace-jump-mode flycheck-color-mode-line flycheck company-flx company-coq company-auctex company markdown-mode paradox monokai-theme paradox)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'monokai t)
;;(load "~/.emacs.d/lisp/PG/generic/proof-site")
;;(setq auto-mode-alist (cons '("\\.v$" . unicode-tokens-mode) auto-mode-alist))

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(require 'tex-site)
(setq-default TeX-master nil) ; Query for master file.
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.
(setq TeX-PDF-mode t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
;(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(add-hook 'LaTeX-mode-hook 'turn-on-font-lock)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(global-visual-line-mode 1)
(require 'reftex)
 (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
; (add-hook 'latex-mode-hook 'turn-on-reftex)
 (setq reftex-plug-into-AUCTeX t)
 (setq reftex-external-file-finders
       '(("tex" . "kpsewhich -format=.tex %f")
        ("bib" . "kpsewhich -format=.bib %f")))

; (add-hook 'LaTeX-mode-hook 'latex-preview-pane-mode)
; (require 'langtool)
;    (setq langtool-language-tool-jar "/path/to/languagetool-commandline.jar")
(add-hook 'after-init-hook 'global-company-mode)
(require 'company-auctex)
(company-auctex-init)
(with-eval-after-load 'company
      (company-flx-mode +1))
;; global activation of the unicode symbol completion 
(add-to-list 'company-backends 'company-math-symbols-unicode)

;flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
;;; mark the whole line
;(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
(require 'flycheck-color-mode-line)
(eval-after-load "flycheck"
  '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))


;;; ace jump
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)



;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)


;; languagetool
;;(add-to-list 'load-path "~/")
 (require 'langtool)
(setq langtool-language-tool-jar "/home/mschledjewski/LanguageTool/languagetool-commandline.jar")
    (global-set-key "\C-x4w" 'langtool-check)
    (global-set-key "\C-x4W" 'langtool-check-done)
    (global-set-key "\C-x4l" 'langtool-switch-default-language)
    (global-set-key "\C-x44" 'langtool-show-message-at-point)
    (global-set-key "\C-x4c" 'langtool-correct-buffer)

(setq langtool-default-language "en-GB")

(require 'magit-gitflow)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)


(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

(global-diff-hl-mode)
(diff-hl-flydiff-mode)

(setq auto-package-update-delete-old-versions t)
(auto-package-update-maybe)

