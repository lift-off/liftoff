
Notes on upgrading existing applications from TAdvStringGrid v1.X to v2.x



- Make sure to uninstall the previous version of TAdvStringGrid first. Uninstalling also means removing all TAdvStringGrid related files from the Delphi or C++Builder library path.

- Install TAdvStringGrid preferably into a separate directory and install by opening the ASGDx.DPK file (for Delphi) or ASGCx.BPK file (for C++Builder)

- When compiling applications that used TAdvStringGrid v1.x, take following changes into account ( you loose no functionality, only some reorganizations have been done to make it more logical and more convenient to use the grid) :

1) Warnings about property changes
When opening the project after TAdvStringGrid v2.0 installation, open all forms containing the grid. Delphi or C++Builder will issue warnings about several missing properties. Ignore the warnings and save the form files.

2) goFixedVertLine , goFixedHorzLine when using soft grid look mode
If the grid Look property is set to glSoft, make sure to set goFixedVertLine, goFixedHorzLine under grid.Options to true. 

3) Removed properties 
EnableGraphics : this property has been removed as the grid can under all circumstances support graphics
FlatCheckBox, FlatRadioButton : these settings are now extended and available under ControlLook
Sort related properties : these properties have been reorganized under SortSettings
OLE drag drop related properties : these properties have been reorganized under DragDropSettings

If the application relied on these Sort or Drag & Drop property settings at design time, you need to set the properties again in the new reorganized settings. If you relied on these properties from code, this will be require a small change to refer to the proper property. (Main property names have been preserved)

4) Incompatible OnGetAlignment event parameters
The OnGetAlignment event has an extra parameter to control vertical alignment per cell. This will cause Delphi or C++Builder to show an error message when compiling. Cut the code from this event handler and let Delphi or C++Builder generate the new parameter sequence for you. Paste the code again in this event and change AAlignment in this code by HAlign.




