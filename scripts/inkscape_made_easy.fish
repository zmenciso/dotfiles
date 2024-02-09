#!/usr/bin/env fish

set EXT_DIR ~/.config/inkscape/extensions
mkdir -p $EXT_DIR

set TEMP_DIR (mktemp -d)

cd $TEMP_DIR
git clone git@github.com:textext/textext.git
python textext/setup.py

git clone git@github.com:fsmMLK/inkscapeMadeEasy.git
mkdir $EXT_DIR/inkscapeMadeEasy
cp inkscapeMadeEasy/latest/* $EXT_DIR/inkscapeMadeEasy

git clone git@github.com:fsmMLK/inkscapeCircuitSymbols.git
mkdir $EXT_DIR/circuitSymbols
cp inkscapeCircuitSymbols/latest/* $EXT_DIR/circuitSymbols

git clone git@github.com:fsmMLK/inkscapeLogicGates.git
mkdir $EXT_DIR/logicGates
cp inkscapeLogicGates/latest/* $EXT_DIR/logicGates

git clone git@github.com:fsmMLK/wavedromScape.git
mkdir $EXT_DIR/wavedromScape
cp wavedromScape/latest/* $EXT_DIR/wavedromScape

git clone git@github.com:fsmMLK/inkscapeCartesianPlotData2D.git
mkdir $EXT_DIR/cartesianPlotData2D
cp inkscapeCartesianPlotData2D/latest/* $EXT_DIR/cartesianPlotData2D

git clone git@github.com:fsmMLK/inkscapeCartesianAxes2D.git
mkdir $EXT_DIR/cartesianAxes2D
cp inkscapeCartesianAxes2D/latest/* $EXT_DIR/cartesianAxes2D

git clone git@github.com:fsmMLK/inkscapeCartesianPlotFunction2D.git
mkdir $EXT_DIR/cartesianPlotFunction2D
cp inkscapeCartesianPlotFunction2D/latest/* $EXT_DIR/cartesianPlotFunction2D

git clone git@github.com:fsmMLK/inkscapeSlopeField.git
mkdir $EXT_DIR/slopeField
cp inkscapeSlopeField/latest/* $EXT_DIR/slopeField

cd -
rm -rf $TEMP_DIR
