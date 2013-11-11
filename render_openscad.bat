@ECHO OFF

SET PAGES_PATH=..\gh-pages\cardstand

ECHO Generating images
openscad.exe -o img\cardstand.png --render CardStand.scad

ECHO Generating STL files
openscad.exe -o stl\cardstand.stl --render CardStand.scad

ECHO Updating Pages
COPY img\cardstand.png %PAGES_PATH%\images\cardstand.png
COPY stl\cardstand.stl %PAGES_PATH%\stl\cardstand.stl
