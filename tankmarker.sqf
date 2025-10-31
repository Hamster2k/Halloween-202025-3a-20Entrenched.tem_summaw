_tankmarkerpos = getMarkerPos "tankmarker";

_tankmarker1 = createMarker ["tankmarker1", _tankmarkerpos];
_tankmarker1 setMarkerType "Unknown";
_tankmarker1 setMarkerColor "ColorBlack";

_tankmarker2 = createMarker ["tankmarker2", _tankmarkerpos];
_tankmarker2 setMarkerShape "ELLIPSE";
_tankmarker2 setMarkerSize [420, 420];
_tankmarker2 setMarkerColor "ColorGrey";
_tankmarker2 setMarkerAlpha 0.5;