{ stdenv, fetchurl, makeWrapper, patchelf
, alsaLib, dbus, fontconfig, freetype, glib, libuuid, libX11, libxcb, libxml2
, libxslt, mesa, nspr, nss, qt5, sqlite, xcbutil, xcbutilimage, xcbutilkeysyms
, xlibs, xorg, zlib
}:

let version = "2.0.91373.0502"; in

stdenv.mkDerivation {
  name = "zoom-${version}";
  src = fetchurl {
    url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
    sha256 = "0gcbfsvybkvnyklm82irgz19x3jl0hz9bwf2l9jga188057pfj7a";
  };
  buildInputs = [ makeWrapper patchelf ];
  installPhase =
    let
      dataDir = "$out/share/zoom";
      interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
      rpath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc.lib alsaLib dbus fontconfig freetype glib libuuid libX11
        libxcb libxml2 libxslt mesa nspr nss qt5.full sqlite xcbutil
        xcbutilimage xcbutilkeysyms xlibs.libXcomposite xlibs.libXcursor
        xlibs.libXdamage xlibs.libXext xlibs.libXi xlibs.libXrender
        xlibs.libXtst xorg.libXfixes zlib
      ];
    in
    ''
      mkdir -pv "${dataDir}"
      cp -R * "${dataDir}"
      patchelf --set-interpreter "${interpreter}" "${dataDir}/zoom"
      patchelf --set-interpreter "${interpreter}" "${dataDir}/ZoomLauncher"
      wrapProgram "${dataDir}/zoom" \
        --prefix LD_LIBRARY_PATH : "${rpath}:${dataDir}" \
        --set QT_QPA_PLATFORM_PLUGIN_PATH "${dataDir}"
      wrapProgram "${dataDir}/ZoomLauncher" \
        --prefix LD_LIBRARY_PATH : "${rpath}:${dataDir}" \
        --set QT_QPA_PLATFORM_PLUGIN_PATH "${dataDir}"
      mkdir -pv $out/bin
      makeWrapper "${dataDir}/ZoomLauncher" "$out/bin/ZoomLauncher"
    ''
  ;
  meta = with stdenv.lib; {
    description = "Allows you to start or join Zoom meetings";
    homepage = https://zoom.us/;
    license = licenses.unfree;
  };
}
