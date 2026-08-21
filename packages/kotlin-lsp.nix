{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  e2fsprogs,
  fontconfig,
  libGL,
  libgbm,
  libnotify,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxtst,
  nspr,
  nss,
  pango,
  udev,
  wayland,
}:

let
  version = "262.9593.0";
  platform =
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      {
        archive = "kotlin-server-${version}-aarch64.sit";
        hash = "sha256-a6YCGnBrIeZM7zP34refGHwJEDIHIrstPtBa0RFexD8=";
      }
    else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 then
      {
        archive = "kotlin-server-${version}-aarch64.tar.gz";
        hash = "sha256-IxeDHG5WB9BbfrwdplUzASXODj1m+/JFF9/ORC3rwU4=";
      }
    else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
      {
        archive = "kotlin-server-${version}.tar.gz";
        hash = "sha256-LZnY4Zj75KqPRIHjd5lyTOlIA7TqEqYLQWBA4/zXzF4=";
      }
    else
      throw "kotlin-lsp is not packaged for ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "kotlin-lsp";
  inherit version;

  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${version}/${platform.archive}";
    inherit (platform) hash;
  };

  sourceRoot = "kotlin-server-${version}";

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unzip ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    e2fsprogs
    fontconfig
    libGL
    libgbm
    libnotify
    libsecret
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxtst
    nspr
    nss
    pango
    udev
    wayland
  ];

  unpackCmd = lib.optionalString stdenv.hostPlatform.isDarwin "unzip $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/kotlin-lsp" "$out/bin"
    cp -a . "$out/libexec/kotlin-lsp"

    makeWrapper \
      "$out/libexec/kotlin-lsp/bin/intellij-server" \
      "$out/bin/intellij-server"
    ln -s intellij-server "$out/bin/kotlin-lsp"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$("$out/bin/kotlin-lsp" --version)" = "LS-${version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Official IntelliJ-based language server for Kotlin";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = lib.licenses.unfree;
    mainProgram = "kotlin-lsp";
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
