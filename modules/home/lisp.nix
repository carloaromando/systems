{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sbcl
    lispPackages.quicklisp
    # sbclPackages.quicklisp-slime-helper
  ];

  # TODO: Automate quicklisp installation 

  home.file.".sbclrc".text = ''
    #-quicklisp
    (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                           (user-homedir-pathname))))
      (when (probe-file quicklisp-init)
        (load quicklisp-init)))
  '';

  # ASDF source registry. The :exclude list matters: without it ASDF follows
  # the .direnv/ symlinks into /nix/store and walks ~160k directories on every
  # SBCL start (~50s before anything runs, including M-x slime).
  home.file.".config/common-lisp/source-registry.conf.d/projects.conf".text = ''
    (:exclude ".bzr" ".cdv" "~.ref" ".hg" ".git" ".svn" "_darcs" "{arch}" "CVS"
              ".direnv" "node_modules" "result" ".qlot")
    (:tree (:home "src/projects/"))
  '';
}
