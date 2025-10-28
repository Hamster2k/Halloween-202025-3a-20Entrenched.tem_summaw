// Requires ROS_SnowStorm v1.0 by RickOShay
// This script is part of ROS_SnowStorm.
// [] execvm "ROS_SnowStorm\scripts\ROS_WindLoop.sqf";

ROS_SnowWindRunning = true;

[] spawn {

	if (ROS_snowDebug) then {hintSilent "Wind Intro starts"; sleep 0.5};
	_endtime = (ROS_halfLooptime)*2;

	playsound "SnowWindIntro";
	uisleep 39;

	if (ROS_snowDebug) then {hintSilent "Wind Loop starts"};
	While {time < _endtime} do {
		if (rain <0.75) then {
	    	playsound "SnowlightWindLoop";
	    } else {
	    	playsound "SnowHeavyWindLoop";
	    };
	    uisleep 39;
	};

	// ~40.5 secs for each Intro, L&H loop and Outro segments
	if (ROS_snowDebug) then {hintSilent "Wind Outro starts"};

	playsound "SnowWindoutro";
	uisleep 39;

	ROS_SnowWindRunning = false;
};

