(use-modules
 (guix packages)
 ((guix licenses) #:prefix license:)
 (guix download)
 (guix build-system emacs)
 (gnu packages)
 (gnu packages autotools)
 (gnu packages pkg-config)
 (gnu packages texinfo)
 (gnu packages emacs)
 (guix gexp))

(package
  (name "pseudotaxus-emacs")
  (version "0.0.1")
  (source (local-file (string-append "./"
                                     name
                                     "-"
                                     version
                                     ".tar.bz2")))
  (build-system emacs-build-system)
  (native-inputs (list autoconf automake pkg-config texinfo
                       emacs-minimal guile3))
  (synopsis "A major mode for editing Pseudotaxus files")
  (description
   (string-append
    "This is a major mode for GNU Emacs, to allow for easy and robust editing of"
    " Pseudotaxus pseudocode files."))
  (home-page
   "https://cdr255.com/projects/pseudotaxus/")
  (license license:agpl3+))
;; Local Variables:
;; mode: scheme
;; End:
