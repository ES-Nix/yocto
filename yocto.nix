{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "yocto-env";

  # Packages Yocto is expecting on the host system by default
  targetPkgs = pkgs: (with pkgs; let
    sh = (pkgs.runCommand "sh" {} ''
      mkdir -p $out/bin
      cat > $out/bin/bash <<'EOF'
      #!${bashInteractive}/bin/bash
      export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
      export LOCALEARCHIVE=/usr/lib/locale/locale-archive
      exec -a /bin/bash ${bashInteractive}/bin/bash "$@"
      EOF
      chmod +x $out/bin/bash
      ln -s $out/bin/bash $out/bin/sh
    '');
    in [
    which gcc glibc glibcLocales shadow gnumake python27 gawk wget
    gitFull diffstat diffutils unzip texinfo bzip2 gzip perl patch chrpath file
    cpio utillinux nettools iproute procps openssh xterm SDL findutils
    socat gnutar ccache cmake vim binutils gitRepo
    (pkgs.runCommand "python3" {} ''
      mkdir -p $out/bin
      cat > $out/bin/python3 <<'EOF'
      #!${runtimeShell}
      export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
      export LOCALEARCHIVE=/usr/lib/locale/locale-archive
      exec -a /usr/bin/python3 ${python3}/bin/python "$@"
      EOF
      chmod +x $out/bin/python3
    '')
    (hiPrio sh)
  ]);

  # Headers are required to build
  extraOutputsToInstall = [ "dev" ];

  # Force install locale from "glibcLocales" since there are collisions
  extraBuildCommands = ''
    ln -sf ${pkgs.glibcLocales}/lib/locale/locale-archive $out/usr/lib/locale
  '';

  profile = ''
    export hardeningDisable=all
    export CC=gcc
    export LD=ld
    export EDITOR=vim
    export STRIP=strip
    export OBJCOPY=objcopy
    export RANLIB=ranlib
    export OBJDUMP=objdump
    export AS=as
    export AR=ar
    export NM=nm
    export CXX=g++
    export SIZE=size
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export SHELL=/bin/bash
  '';

  multiPkgs = pkgs: (with pkgs; []);
  runScript = "bash";
}).env

