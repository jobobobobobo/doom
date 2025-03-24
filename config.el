;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Joseph Bozeman"
      user-mail-address "joseph.l.bozeman@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")
(setq org-agenda-files "~/org")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;(use-package! evil-org
;;  :config
;;  (map! :map evil-org-mode-map
;;        :i "C-k" #'evil-insert-digraph))

(setq org-pretty-entities t)
(set-frame-font "-CTDB-FiraCode Nerd Font Mono-bold-normal-normal-*-13-*-*-*-m-0-iso10646-1")
(setq org-hide-emphasis-markers t)
(use-package! org-gnosis
  :ensure t
  :init (define-prefix-command 'nlbg/notes-map)
  (define-prefix-command 'nlbg/journal-map)
  :config (setf org-gnosis-dir "~/org"
                org-gnosis-create-as-gpg nil
                org-gnosis-todo-files org-agenda-files
                org-gnosis-bullet-point-char "+"
                org-gnosis-completing-read-func #'org-completing-read
                org-gnosis-show-tags t)

  (defun example/org-gnosis-book-template ()
    (let ((date (format-time-string "%Y-%m-%d"))
          (book-title (completing-read
                       "Example book: "
                       '("Free Software, Free Society" "How to Take Smart Notes"))))
      (format "#+DATE: %s \n#+BOOK_TITLE: %s\n\n* Main Idea\n* Key Points\n* Own Thoughts"
              date book-title)))

  (add-to-list 'org-gnosis-node-templates
               '("Book Example" example/org-gnosis-book-template))
  :bind (("C-c n" . nlbg/notes-map)
         ("C-c n j" . nlbg/journal-map)
         :map nlbg/notes-map
         ("f" . org-gnosis-find)
         ("i" . org-gnosis-insert)
         ("t" . org-gnosis-find-by-tag)
         :map nlbg/journal-map
         ("j" . org-gnosis-journal)
         ("f" . org-gnosis-journal-find)
         ("i" . org-gnosis-journal-insert)
         :map org-mode-map
         ("C-c C-." . org-gnosis-insert-tag)
         ("C-c i" . org-id-get-create)))
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
;;(add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)
(map!
 :map smartparens-mode-map
 "C-M-f" #'sp-forward-sexp
 "C-M-b" #'sp-backward-sexp
 "C-M-u" #'sp-unwrap-sexp
 "C-M-k" #'sp-kill-sexp
 "C-M-s" #'sp-split-sexp
 "C-M-(" #'sp-wrap-round
 "C-M-[" #'sp-wrap-square
 "C-M-{" #'sp-wrap-curly)
(use-package! magit-gitflow :config
              (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))
