deleteMarker "tankmarker1";
deleteMarker "tankmarker2";

uiSleep 0.1;

_fuelmarkerpos = getMarkerPos "fuelmarker";

_fuelmarker1 = createMarker ["fuelmarker1", _fuelmarkerpos];
_fuelmarker1 setMarkerType "Unknown";
_fuelmarker1 setMarkerColor "ColorBlack";

_fuelmarker2 = createMarker ["fuelmarker2", _fuelmarkerpos];
_fuelmarker2 setMarkerShape "ELLIPSE";
_fuelmarker2 setMarkerSize [150, 150];
_fuelmarker2 setMarkerColor "ColorGrey";
_fuelmarker2 setMarkerAlpha 0.5;
