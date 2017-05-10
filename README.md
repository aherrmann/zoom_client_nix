# Nix Package for [Zoom Client](https://zoom.us)

Build with

``` sh
nix-build pkg.nix
```

and run with

``` sh
./result/bin/ZoomLauncher
```

Tested with NixOS version 17.03.994.67c6638b08 (Gorilla).

Known to fail with nixpkgs revision e338485
(nixpkgs-unstable at the time of writing)
with the following error message:

```
ZoomLauncher started.
cmd line:
$HOME = /home/me
/nix/store/rsxh2kwchh8ycbkaxmbcf00ba8mkk7i1-zoom-2.0.91373.0502/share/zoom/zoom: relocation error
: /nix/store/rsxh2kwchh8ycbkaxmbcf00ba8mkk7i1-zoom-2.0.91373.0502/share/zoom/libQt5WebEngineCore.
so.5: symbol _ZSt24__throw_out_of_range_fmtPKcz, version Qt_5 not defined in file libQt5Qml.so.5
with link time reference
success to create child process,status is 32512.
zoom exited normally.
Something went wrong while running zoom,exit code is 127.
ZoomLauncher exit.
```
