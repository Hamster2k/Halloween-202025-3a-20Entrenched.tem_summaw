/*
ROS SNOWSTORM V1.0
==================

Author
======
ROS_SnowStorm by RickOShay

Description
===========
The ROS Snow Storm creates realistic snow storm effects based on suitable 'real world' weather conditions.
Just like in the real world, snow fall is directly linked to the overcast, humidity and moisture levels.
This snow storm system creates perpetual 60 minute loops consisting of snow, no snow and limited visibility periods during the mission.
The ROS Snowstorm system controls in game snow particles, overcast, rain, fog, wind, sound effects and related parameters.

Main Features
=============
* Variable fog and overall visibility
* Hyper realistic snow flake textures
* Automated Weather report update via a laptop
* Performance optimized with limited FPS impact
* Variable snow flake size, opacity and emissivity
* Variable wind strength throughout each storm loop
* The ROS Snowstorm script is almost entirely client side
* Occasional white out / blizzard limited visibility conditions
* Ambient wind sound effects dependent on the snow storm strength
* No snow particles when player is under cover, in vehicles or buildings
* Perpetual snow, no snow, reduced visibility loops throughout the mission
* Script Parameters can be changed in the lobby before the mission starts
* The maximum strength of each snow storm varies for each ~60 minute loop
* Variable snow dust strength and opacity - dependent on the wind velocity
* Players will occasionally make cold 'shiver' sounds after standing still
* Consistently variable snow fall loop density within the storm strength limits

Optional Features
=================
* Snow/icy wind can hurt your eyes if no eye protection is worn (optional)
* When conditions are right you will see Aurora Borealis random effects (optional)
* Melted snow water droplets run down your mask or the vehicle windscreen (optional)
* There is a severe weather warning when blizzard conditions are predicted (optional)
* Nearby players and Npc's will breathe out steam when conditions are right (optional)
* You can adjust the mission time multiplier to speed up the weather and the day night cycle (optional)

Legal Stuff
===========
You may use ROS Snowstorm as long as the script header text is not edited or removed and all original files are
kept intactand NOT EDITED and the folder structure is retained. Full credit must be given in any mission or mod
that uses the ROS Snow Storm Script as well on the Steam Workshop page.

Execution
=========
1) Copy the ROS_Snowstorm folder to your mission folder

2) Place the following line in your Description.ext file under CFGSounds:
#include "ROS_SnowStorm\CfgSounds.hpp"

3) Place the following line in the Description.ext file:
#include "ROS_SnowStorm\missionparams.hpp"

4) Place the following command lines into your init.sqf:
[] execvm "ROS_SnowStorm\scripts\ROS_SnowStorm.sqf";

5) Set the mission overcast start value to around 0.45 in Eden Weather settings (see info below)

Add a Weather Report to laptop
==============================
Place the following command into the init field of a laptop or similar device
this addAction["<t color='#3399ff'>WEATHER REPORT</t>", {hint WeatherReport},[], 1, true, false,"","WeatherReport != '' && _this distance _target < 4"];

EDEN Weather Settings
=====================
In 3den Intel settings set the OVERCAST start value at ~0.4 - snow will start falling about 10 minutes after mission start. (0.5 for immediate)
DONT USE MANUAL OVERRRIDE for RAIN or WIND in EDEN weather settings.
NB!  USE MANUAL OVERRIDE for SNOW (if the map has this snow weather setting in Eden) - set current and forecast sliders to 0.
Overcast global weather settings take some time to propagate if set below <0.3 - meaning it will take ~30 minutes for overcast to reach 0.5 (time multipluier 1)
An Overcast value of 0.5 is the threshold for snow.

Overcast START Value
====================
FYI: Snow is linked to the overcast value. Snow is only possible when overcast >=0.5 and <=1
Examples for the Overcast start setting below:
An overcast start value (mission start) of 0 - means clear sky, estimated minimum time before a snow event ~30 mins. (with time multiplier of 1)
An overcast start value (mission start) of 0.4 - a chance of snow in ~20 mins. (with time multiplier of 1) ***DEFAULT***
An overcast start value (mission start) of 0.5 - snow is likely at mission start. (with time multiplier of 1) */

ROS_overcastStart = 0.45;

/* Set the Mission Time Multiplier to speed up weather changes and shorten the day night cycle:
===============================================================================================
A time multiplier of 0 = Ignore this time multiplier setting (useful if time multiplier is changed by some other mission script)
A time multiplier of 1 = game day+night cycle lasts 24 hours i.e. real time weather changes (it takes about 10 minutes to increase overcast by 0.1)
A time multiplier of 4 = (24/4) game day+night cycle lasts 6 hours (3 hours day and 3 hours night)
A time multiplier of 6 = (24/6) game day+night cycle lasts 4 hours (2 hours day and 2 hours night)
A time multiplier of 8 = (24/8) game day+night cycle lasts 3 hours (1.5 hours day and 1.5 hours night): ***(Default)***/

ROS_timeMulti = 8;

// Enable radio sound effect for blizzard weather warning (Default true)
ROS_weatherWarning = true;

// Enable periodic shivering SFX if not inside and not in vehicle (Default true)
ROS_Shivering = true;

// Enable random Aurora effect at night time when limited or no snow is falling (Default true)
ROS_AuroraEnable = true;

// Maximum snow fall strength: 0 = Random, 1 = Light snowfall, 2 = Heavy snowfall or blizzard (Default 0)
ROS_MaxSnowStorm = 2;

// Add foggy breath to all nearby units (if you are using another foggy breathe script disable it) (Default true)
ROS_addFB = true;

// Add melted snow drops water effects running down the vehicle windscreen and player glasses during medium+ snowfall (Default true)
ROS_screenWater = true;

// Cold wind and snow hurts your eyes if not wearing eyewear - this enables pain sound sfx and warning prompt if not wearing eyewear (Default false)
ROS_eyewearCheck = false;

// Switch on Debug for testing this script
ROS_snowDebug = false;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////  DO NOT CHANGE ANYTHING BELOW THIS LINE ////////////  DO NOT CHANGE ANYTHING BELOW THIS LINE ///////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

params [];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if (isnil "ROS_SnowCreditAdded") then {
    #define ROS_script "ROS Snow Storm"
    #define ROS_subject "ROS Snow Storm Script"
    #define ROS_description "ROS SNOW STORM by RickOShay<br/><br/>DESCRIPTION<br/>* Creates realistic snow effects when conditions are suitable<br/>* Snow is linked to overcast, humidity and rain conditions.<br/>* Snow will only occur when mission overcast >= 0.5 / 50%<br/><br/>FEATURES<br/>* No snow flake particles whilst under cover, in vehicles or in buildings<br/>* Hyper realistic snow flake textures<br/>* Variable snow flake size<br/>* Variable snow fall density (~25% chance of white out or blizzard)<br/>* Variable snow storm density<br/>* Variable fog and visibility<br/>* Variable wind strength and direction<br/>* White out or blizzard condition<br/>* Perpetual random snow / no snow loops throughout the mission<br/>* Melted snow droplets run down the mask and windscreen (optional)<br/>* Nearby players and NPCs will breathe out steam (optional)<br/>* Adjusted mission time multiplier to speed up weather change (optional)<br/>* Aurora Borealis random effect at night (optional)<br/>* Weather warning using real voices when heavy snow fall predicted (optional)<br/>* Snow and icy wind can hurt your eyes if not wearing goggles (optional)<br/>* Wind and other ambient Sfx<br/>* Perpetual snow (24 hours) loops for persistent missions<br/>* Client side script and particles<br/>* High performance limited FPS impact<br/>Script Paramaters can be changed in the lobby before mission start<br/>* Easy to install"

    #define ROS_image "<img image='ROS_SnowStorm\images\ROSsnowStorm.jpg' width='400' height='200'/>"

    // person createDiarySubject [subject, displayName, picture] - page in log
    player createDiarySubject [ROS_script, ROS_script];
    // unitName createDiaryRecord [subject, text, task, taskState, showTitle] - diary entry
    player createDiaryRecord [ROS_script, [ROS_subject, ROS_description]];
    player createDiaryRecord [ROS_script, [ROS_subject, ROS_image]];

    ROS_SnowCreditAdded = true;
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// wait for players
waituntil {sleep 1; (count allplayers >=1)};

// No rainbows
0 setrainbow 0;

// No snakes etc
enableEnvironment [false, false, 1];

ROS_SnowStormRunning = true;
ROS_SnowWarningDone = false;
ROS_SnowWindRunning = false;
ROS_auroraCCrunning = false;
ROS_auroraRunning = false;
ROS_auroraOCMax = 0.65;
ROS_SnowStrength = 0.1;
ROS_endtime = 86400;
targetWindSpeed = 25;

ROS_Fnc_Aurora = compile preprocessFileLineNumbers "ROS_SnowStorm\scripts\ROS_Aurora.sqf";

// Update params
[] execvm "ROS_SnowStorm\setParams.sqf";

// Cap overcast start to 0.6 max
if (ROS_overcastStart >0.6) then {ROS_overcastStart = 0.6};

// Force fog >0
if (fog <0.001) then {
	[10, 0.001] remoteExec ["setfog",2];
};

// Forced weather synch if current local overcast > ROS_overcastStart i.e. set in Eden but not in script
if ((parseNumber (overcast tofixed 2) > ROS_overcastStart) or didJip) then {
		// Conditionally force weather change and synch
	if (isServer) then {
		if (ROS_snowDebug) then {
			hint "Forced weather synch";
			sleep 1;
		};
		skipTime -24;
		86400 setOvercast ROS_overcastStart;
		0 setrain ROS_overcastStart;
		skipTime 24;
		// No dust
		setHumidity 0.2;
	};
};

// Increase Wind velocity
if (isServer) then {
	[] spawn {

		targetWindSpeed = (15 + random 10);
	    _rate = 3.6;
	    while {(vectorMagnitude wind)*_rate <= targetWindSpeed} do {
	        _wx = wind select 0;
	        _wy = wind select 1;
	        _wSpeed = [_wx, _wy, 0] vectorMultiply _rate;
	        setWind [(_wSpeed select 0), (_wSpeed select 1), false];
	        sleep 1;
	        // kill loop - gusting - wind speed fluctuates significantly
	        if ((vectorMagnitude wind)*_rate > targetWindSpeed) then {break};
	    };
	    if (ROS_snowDebug) then {
	    	["Wind speed increased"] remoteExec ["hintSilent",0];
	    	sleep 3;
	    };
	};
};

// Add goggles and try to put into player inventory - add default eyewear here
if (hasInterface) then {
    if (ROS_eyewearCheck) then {
        if (goggles player == "") then {
            if (player canAdd "G_Tactical_Clear") then {
                player addItem "G_Tactical_Clear";
                player unassignItem "G_Tactical_Clear";
            };
        };
    };
};


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// FUNCTIONS ////////////////////// FUNCTIONS ////////////////////// FUNCTIONS ///////////////////////

// Unit or Object in building or undercover (not vehicle) >> bool
ROS_Fnc_UnderCover = {
    params ["_unit"];
    _building = objNull;
    _pos = AGLToASL (player modelToWorld [0,0,1]);
    (lineIntersectsSurfaces [_pos, (_pos vectorAdd [0, 0, 50]), _unit, objNull, true, 1, "VIEW", "GEOM"]) select 0 params ["","","","_building"];
	if (_building isKindOf "Building" or insideBuilding _unit >0) exitWith {true};
    false;
};


// Snow Particles
S_dropW = 0.08;
S_dropH = 0.08;
S_alpha = 0.5;
S_dropSpeed = 2.5;

ROS_Fnc_Snow = {
	[
		"a3\data_f\snowflake4_ca.paa", // rainDropTexture
		4, // texDropCount
		0.05, // minRainDensity
		20, // effectRadius
		1, // windCoef higher more effect on part
		S_dropSpeed, // dropSpeed higher faster - maximum 4
		0.7, // rndSpeed higher more random
		0.5, // rndDir
		S_dropW, // dropWidth
		S_dropH, // dropHeight
		[1, 1, 1, S_alpha],  // dropColor
		1, // lumSunFront increase part vis during day
		1, // lumSunBack increase part vis during day
		0.5, // refractCoef
		0.5, // refractSaturation
		true, // snow
		false // dropColorStrong emmissive brighter part day and night
	] call BIS_Fnc_SetRain;
};


// Snow Post Processing color changes
ROS_Fnc_SnowPPE = {
	_snowPPE = ppEffectCreate ["colorCorrections", 1501];
	_snowPPE ppEffectEnable true;

	// with increasing fog and rain part
	if (fog <0.6) then {
		_snowPPE ppEffectAdjust // default
		[
		 1,
		 1,
		 0,
		 [0, 0, 0, 0],
		 [1, 1, 1, 1],
		 [0.299, 0.587, 0.114, 0]
		];
	};
	if (fog >=0.6 && fog <0.75) then {
		_snowPPE ppEffectAdjust
		[1, // bright
		1.0, // contrast
		0.0, // offset
		[0.1, 0, 0.1, 0.1], // col blending
		[1, 1, 1, 1], // col
		[0.1, 0.1, 0.1, 0.1]]; // desat weight
	};
	if (fog >=0.75 && fog <0.9) then {
		_snowPPE ppEffectAdjust
		[0.95, // bright
		1.0, // contrast
		0.0, // offset
		[0.15, 0.15, 0.15, 0.15], // col blend
		[0.95, 0.95, 0.95, 0.95], // col
		[0.12, 0.12, 0.12, 0.12]]; // desat weight
	};
	if (fog >=0.9 && rain >=0.9) then {
		if (ROS_snowDebug) then {hintSilent format ["Whiteout\nFog %1\nRain %2\nFPS %3", fog, rain, diag_fps]; sleep 1;};
		_snowPPE ppEffectAdjust
		[0.9, // bright
		1.0, // contrast
		0.0, // offset
		[0.2, 0.2, 0.2, 0.2], // col blend
		[0.9, 0.9, 0.9, 0.9], // col
		[0.15, 0.15, 0.15, 0.15]]; // desat weight
	};

	_snowPPE ppEffectCommit 30;
};


// Increase Fog [fogStrength, fogDensity, fogAlt]
ROS_Fnc_FogIncrease = {
	[] spawn {
		_z = getTerrainHeight (getPosWorld player);
		while {fog < ROS_fogLimit} do {
			if (!ROS_auroraRunning) then {
				[1, [((fog+0.01) min ROS_fogLimit),0,_z]] remoteExec ["setfog",0];
			};
			sleep 30;
		};
	};
};


// Decrease Fog [fogStrength, fogDensity, fogAlt]
ROS_Fnc_FogDecrease = {
	[] spawn {
		_z = getTerrainHeight (getPosWorld player);
		while {fog > 0.1} do {
			if (!ROS_auroraRunning) then {
				[1, [((fog-0.01) min ROS_fogLimit),0,_z]] remoteExec ["setfog",0];
			};
			sleep 30;
		};
	};
};


// Water drop screen effect
ROS_Fnc_ScreenWaterEffects = {

	// Cover check
	ROS_underCover = player call ROS_Fnc_UnderCover;

	// Water particles must appear on vehicles windscreens and goggles. If player in a building or under an overhang or no goggles then >> exit
 	if (ROS_underCover or (isNull objectParent player && goggles player == "")) exitWith {};

	_int = 0.5;
	_rub = 0.001,
	_dSize = 0.01;

	_int = 0.5;

	if (rain >0.1) then {
		_int = (1/rain)/16;
	} else {
		_int = 0.5;
	};

	_emitter = "#particlesource" createVehicleLocal [0,0,0];
	_logic = "logic" createVehicleLocal [0,0,0];

	// Vehicle check
	if (!isnull objectParent player) then {
		_dSize = 0.01;
		_int = _int-0.01;
		_rub = 0,
		_logic attachto [player, [0,0.5,0.4],"head"];
	} else {
		_dSize = 0.01;
		_logic attachto [player, [0,0,0.4],"head"];
	};

	_emitter attachto [_logic,[0,0,0]];
	_emitter setParticleCircle [0, [0, 0, 0]];

	_emitter setParticleRandom  [
	0, // lt
	[0.5,0.5,0], // pos
	[0,0,0.1], //vel
	0, // rot
	0.5, // size
	[0, 0, 0, 4], //col
	1, //rnddir per
	0.001]; // rnd dir inten

	_emitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1],
	"",
	"Billboard", // type
	1, // timer per
	7, // lt
	[0,0,0], // pos
	[0,0,0], // vel
	0, //rot vel
	0.62348, // weight
	0.485, // vol
	_rub, // rub
	[_dSize], // size
	[[0, 0, 0, 1]], // col
	[0.1], // anim spd
	0, // rnd dir per
	0, // rnd dir inten
	"",
	"",
	_logic
	];

	_emitter setDropInterval _int;
	sleep 7;
	deletevehicle _emitter;
	deletevehicle _logic;

}; // End ROS_Fnc_ScreenWaterEffects


// Snow Dust Particles
ROS_Fnc_SnowDust = {
	if (vectorMagnitude wind <5 or currentVisionMode player != 0) exitWith {};
	if (player call ROS_Fnc_UnderCover) exitWith {
		{if (typeOf _x == "#particlesource") then {deleteVehicle _x}} forEach (player nearObjects 10);
	};

	_dustDropInt = 0.05;
	_curRain = (parseNumber (rain tofixed 2));

	// Adjust drop interval based on snow strength
	switch true do {
		case (_curRain <=0.1): {_dustDropInt = 0.09};
		case (_curRain >0.1 && _curRain <0.6): {_dustDropInt = 0.07};
		case (_curRain >=0.6 && _curRain <0.7): {_dustDropInt = 0.05};
		case (_curRain >=0.7 && _curRain <0.8): {_dustDropInt = 0.03};
		case (_curRain >=0.8 && _curRain <0.9): {_dustDropInt = 0.01};
		case (_curRain >=0.9 && _curRain <= 1): {_dustDropInt = 0.008};
	};

	_radius = 15;

	// adjust part circle based on object parent
	if (isNull objectParent player) then {_radius = 15} else {_radius = 40};

	_pos = (vehicle player) modelToWorld [0,0,0];
	_posH = (getTerrainHeightASL _pos);
	_pos set [2,_posH];

	_snowDust = objNull;
	_snowDust = "#particlesource" createVehicleLocal (ASLToAGL _pos);

	// Opacity factor
	_opF = 1;

	// Accentuate whiteness (see emissive param)
	_emissive = [[4,4,4,0]];

	// Night or Day
	if ((apertureParams select 0) <9 && currentVisionMode player == 0) then {
		// Night
		_opF = 0.3+(fog/2);
		_emissive = [[0.5,0.5,0.5,0]];
	} else {
		// Day
		_opF = 0.3;
		_emissive = [[100,100,100,0]];
	};

	_snowDust setParticleCircle [_radius, [10, 0, 0]];

	_snowDust setParticleRandom [
	0, //lt
	[15, 15, 0], //pos
	[0, 0, 0], //vel
	3, // rotvel
	0.1, // size
	[0,0,0,0], //col
	0,
	0];

	_snowDust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], //["A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 1],
	"",
	"Billboard",
	1, // timer per
	10, // lt
	[0, 0, 0], //pos
	[1, 0, -0.1], // vel
	3, // rot vel
	0.3, // weight
	0.232, //vol
	0.1, //rub
	[2, 10, 15], //size
	[[1,1,1, 0.001],[1,1,1, 0.01],[1,1,1, _opf], [1, 1, 1, _opf],[1, 1, 1, _opf/2],[1,1,1, 0.05],[1,1,1, 0.01],[1,1,1, 0]], //col
	[3], // anim speed
	1, // rand dir per
	0, // rnd dir intens
	"", // on timer sccript
	"", // before destroy script
	"", // obj
	0,  // angle
	true, // on surface
	-1, // bounceOnSurface
	_emissive // emissive col for daylight effect
	];

	_snowDust setDropInterval _dustDropInt;

	sleep 1;

	deletevehicle _snowDust;
};


// Adjust Alpha with density (dropcolorstrong)
ROS_Fnc_S_Alpha = {
	_curRain = (parseNumber (rain tofixed 2));

	// DAY
	if (sunormoon ==1) then {
		switch true do {
			case (_curRain <0.6): {S_alpha = 0.25};
			case (_curRain >=0.6 && _curRain <0.7): {S_alpha = 0.23};
			case (_curRain >=0.7 && _curRain <0.8): {S_alpha = 0.21};
			case (_curRain >=0.8 && _curRain <0.9): {S_alpha = 0.19};
			case (_curRain >=0.9 && _curRain <= 1): {S_alpha = 0.17};
		};
	} else {
		// NIGHT
		switch true do {
			case (_curRain <0.6): {S_alpha = 0.38};
			case (_curRain >=0.6 && _curRain <0.7): {S_alpha = 0.36};
			case (_curRain >=0.7 && _curRain <0.8): {S_alpha = 0.34};
			case (_curRain >=0.8 && _curRain <0.9): {S_alpha = 0.32};
			case (_curRain >=0.9 && _curRain <= 1): {S_alpha = 0.3};
		};
	};
};


// Create Weather Report
ROS_Fnc_SnowWeatherReport = {
	WeatherReport = "";
	_WethDesc = "";
	_AmbTemp = "";
	_windDir = round winddir;
	_windSpd = round (vectorMagnitude wind)*3.6;

	if (ROS_SnowStrength == 0) then {ROS_SnowStrength = 0.1};

	// Update weather report
	if (ROS_SnowStrength ==0.1) then {_WethDesc = "SUMMARY\nCold with light winds and snowfall"; _AmbTemp = "Temperature:\nMinimum -1C\nMaximum 4C"};
	if (ROS_SnowStrength ==0.2) then {_WethDesc = "SUMMARY\nCold with light winds and snowfall"; _AmbTemp = "Temperature:\nMinimum -3C\nMaximum 3C"};
	if (ROS_SnowStrength ==0.3) then {_WethDesc = "SUMMARY\nVery cold with variable medium strength winds and snowfall\nVisibility <50m"; _AmbTemp = "Temperature:\nMinimum -7C\nMaximum 0 degrees"};
	if (ROS_SnowStrength ==0.4 && ROS_fogLimit <1) then {_WethDesc = "SUMMARY\nBlizzard Warning. Extremely cold. Variable winds and snowfall\nVisibility <40m"; _AmbTemp = "Temperature:\nMinimum -15C\nMaximum -5C"};
	if (ROS_SnowStrength ==0.4 && ROS_fogLimit ==1) then {_WethDesc = "SUMMARY\nBlizzard Warning. Extremely cold. Variable winds and snowfall\nVisibility <20m"; _AmbTemp = "Temperature:\nMinimum -20C\nMaximum -7C"};

	_windSpd = (vectorMagnitude wind * 3.6) tofixed 1;

	WeatherReport = format ["WEATHER REPORT\nfor the:\n %1 operational area:\n\n%2\n\n%3\n\nWind Direction: %4 deg.\nWind Speed: Gusting to: %5 kph\n Predicted Storm strength: %6%7", (toUpper worldName), _WethDesc, _AmbTemp, _windDir, _windSpd, ((ROS_SnowStrength/0.4)*100) tofixed 0, '%'];
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Increase timemultiplier to speed up weather change - see options
_origTM = timeMultiplier;
if (ROS_timeMulti >= 1) then {setTimeMultiplier ROS_timeMulti};


// Start foggy breath
if (ROS_addFB && hasinterface) then {
	[] execvm "ROS_SnowStorm\scripts\ROS_FoggyBreath.sqf";
};


// Is player wearing eye protection?
if (hasInterface) then {
	if (isnil "ROS_eyewearCheck") then {ROS_eyewearCheck = false};

	if (ROS_eyewearCheck) then {
	    if (hasinterface) then {[player, ROS_endtime] execvm "ROS_SnowStorm\scripts\ROS_Hurt.sqf"};
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////// SNOW CYCLE /////////////////// SNOW CYCLE /////////////////// SNOW CYCLE ///////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Lowest OC value loop cap
_min_OC = 0.4;

// Dust mod
_mod = 5;

// No dust
setHumidity 0.2;

// Get constant loop length - dependent on time multiplier
ROS_loopLength = 3600; // 1 hour: 30 min Increase 30 min Decrease + 10 min Interval

// Shivering sfx
_shiverSFX = ["shiver1","shiver2","shiver3","shiver4","shiver5","shiver6","shiver7","shiver8"];

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// PERPETUAL: STORM INCREASE - STORM DECREASE - STORM INTERVAL /// PERPETUAL: STORM INCREASE - STORM DECREASE - STORM INTERVAL ///
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

while {true} do {

	// Snow Storm Strength Selection for Loop

	// Random strength
	if (ROS_MaxSnowStorm ==0) then {
		ROS_SnowStrength = selectRandom [0.1,0.2,0.3,0.4];
	};
	// Light strength
	if (ROS_MaxSnowStorm ==1) then {
		ROS_SnowStrength = selectRandom [0.1,0.2];
	};
	// Heavy strength
	if (ROS_MaxSnowStorm ==2) then {
		ROS_SnowStrength = selectRandom [0.3,0.4];
	};

	// Max Storm Density = max OC at start + strength
	ROS_maxOvercast = (0.60 + ROS_SnowStrength) min 1;

	// Max fog for loop
	switch true do {
		case (ROS_SnowStrength ==0.1): {ROS_fogLimit = 0.2};
		case (ROS_SnowStrength ==0.2): {ROS_fogLimit = 0.4};
		case (ROS_SnowStrength ==0.3): {ROS_fogLimit = 0.7};
		case (ROS_SnowStrength ==0.4): {ROS_fogLimit = selectRandom [0.85,1]};
	};

	// Increase - Decrease Loop Lengths
	ROS_halfLooptime = (ROS_loopLength/2) + time;

	// Start WindLoop sounds
	if (!ROS_SnowWindRunning && hasInterface) then {
		if (ROS_snowDebug) then {hintSilent "Starting windloop"};
		[] execvm "ROS_Snowstorm\scripts\ROS_WindLoop.sqf";
	};

	// Update the weather report
	[] spawn ROS_Fnc_SnowWeatherReport;

	// Run Aurora if conditions are right
	if (!isdedicated && ROS_AuroraEnable && !ROS_auroraRunning && (sunormoon <1) && rain <ROS_auroraOCMax) then {
		if (ROS_snowDebug) then {hintSilent "Aurora started"; sleep 3;};
		[] spawn ROS_Fnc_Aurora;
	};

	sleep 5;

	// Increase Fog to limit (ROS_fogLimit - windStr)
	if (isServer) then {[] spawn ROS_Fnc_FogIncrease};

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////  SNOW PROBABILITY INCREASING  ////  SNOW PROBABILITY INCREASING  ////  SNOW PROBABILITY INCREASING  ////  SNOW PROBABILITY INCREASING  ////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	while {time < ROS_halfLooptime && overcast < ROS_maxOvercast-0.01} do {

		if (ROS_snowDebug && !ROS_auroraRunning) then {hintSilent format ["Inc OC: %1\nRain: %2\nFog: %3\nHTend: %4\nST: %5\nFPS: %6", overcast, rain, fog, floor ((ROS_halfLooptime-time)/60), ROS_SnowStrength, round diag_fps]};

		// Update the weather report
		if (round time mod 15 ==0) then {[] spawn ROS_Fnc_SnowWeatherReport};

		// Weather warning - delayed
		if (hasinterface && ROS_weatherWarning && !ROS_SnowWarningDone && ROS_SnowStrength == 0.4) then {
		    _randWarning = selectRandom ["sswarning1","sswarning2"];
		    [_randWarning] spawn {
		    	params ["_randWarning"];
		    	sleep 120;
		    	playsound [_randWarning, 2];
			};
			ROS_SnowWarningDone = true;
		};

		// Shiver sfx if not inside or in vehicle and not moving fast
		if (ROS_Shivering && (isnull objectParent player) && !(player call ROS_Fnc_UnderCover) && speed player <2 && round time mod 70 == 0) then {
			_shiver = selectRandom _shiverSFX;
			playsound _shiver;
		};

		// Inc overcast
		(ROS_loopLength/2) setOvercast ROS_maxOvercast;

		// Periodically reduce rain
		if (random 1<0.02) then {
			if (rain <0.75) then {
				while {rain >=0.3} do {0 setrain (rain -0.05); sleep 1};
			};
		} else {
			0 setrain ((rain+0.01) min ROS_maxOvercast);
		};

		if (hasInterface) then {

			// Increase part size with higher rain intensity > whiteout and inc drop speed
			if (rain >=0.85) then {
				S_dropW = (S_dropW+0.001) min 0.17;
				S_dropH = (S_dropH+0.001) min 0.17;
				S_dropSpeed = (S_dropSpeed+0.1) min 4;
			};

			// Adjust alpha with density
			call ROS_Fnc_S_Alpha;

			// Water drops
			if (ROS_screenWater && rain >0.3 && cameraView == "Internal") then {
				if (random 1 <0.1) then {
					[] spawn ROS_Fnc_ScreenWaterEffects;
				};
			};

			// Start snow fnc and adjust PPE
			[] spawn ROS_Fnc_Snow;
			[] spawn ROS_Fnc_SnowPPE;

			// Snow Dust
			if (!(player call ROS_Fnc_UnderCover) && !ROS_auroraRunning && isnull objectParent player && nearestBuilding (vehicle player) distance (vehicle player) >35 && random 1<0.3) then {
				[] call ROS_Fnc_SnowDust;
			};
		}; // End if hasinterface

		sleep 1;

	}; // while time < ROS_halfLooptime && overcast < ROS_maxOvercast-0.02 INCREASING

	// Decrease Fog to 0.1
	if (isServer) then {call ROS_Fnc_FogDecrease};

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//// SNOW PROBABILITY DECREASE //// SNOW PROBABILITY DECREASE //// SNOW PROBABILITY DECREASE //// SNOW PROBABILITY DECREASE ////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ROS_halfLooptime = (ROS_loopLength/2) + time;
	while {time < ROS_halfLooptime && overcast >= _min_OC} do {

		if (ROS_snowDebug && !ROS_auroraRunning) then {hintSilent format ["Dec OC: %1\nRain: %2\nFog: %3\nHTend: %4\nST: %5\nFPS: %6", overcast, rain, fog, floor ((ROS_halfLooptime-time)/60), ROS_SnowStrength, round diag_fps]};

		// Reduce overcast and Rain more rapidly
		(ROS_loopLength/3) setOvercast _min_OC;

		// Shiver sfx
		if (ROS_Shivering && (isnull objectParent player) && !(player call ROS_Fnc_UnderCover) && speed player <2 && round time mod 60 == 0) then {
			_shiver = selectRandom _shiverSFX;
			playsound _shiver;
		};

		if (hasInterface) then {
			// Reduce part size once rain reduces and reduce drop speed
			if (rain<0.85) then {
				S_dropW = (S_dropW-0.001) max 0.08;
				S_dropH = (S_dropH-0.001) max 0.08;
				S_dropSpeed = (S_dropSpeed-0.1) max 2.5;
			};

			// Adjust alpha with density
			call ROS_Fnc_S_Alpha;

			// Water drops
			if (ROS_screenWater && rain >0.3 && cameraView == "Internal") then {
				if (random 1 <0.1) then {
					[] spawn ROS_Fnc_ScreenWaterEffects;
				};
			};

			// Start snow Fnc and adjust PPE
			[] spawn ROS_Fnc_Snow;
			[] spawn ROS_Fnc_SnowPPE;

			// Snow Dust
			if (!(player call ROS_Fnc_UnderCover) && !ROS_auroraRunning && isnull objectParent player && nearestBuilding (vehicle player) distance (vehicle player) >30 && random 1<0.3) then {
				[] call ROS_Fnc_SnowDust;
			};
		};

		sleep 1;
	}; // END while DECREASING

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//// NO SNOW INTERVAL //// NO SNOW INTERVAL //// NO SNOW INTERVAL //// NO SNOW INTERVAL //// NO SNOW INTERVAL ////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Delay after snow storm (increase decrease loop)
	ROS_auroraRunning == false;
	_delay =  (600 + time);
	_counter = 0;

	// Decrease Fog to 0.1
	if (isServer) then {call ROS_Fnc_FogDecrease};

	while {overcast tofixed 2 >_min_OC && time < _delay} do {

		if (ROS_snowDebug) then {hintSilent format ["Interval\nDelay: %1", round (_delay - time)]};

		_delay setOvercast _min_OC;

		// Shiver sfx
		if (ROS_Shivering && (isnull objectParent player) && !(player call ROS_Fnc_UnderCover) && speed player <2 && round time mod 60 == 0) then {
			_shiver = selectRandom _shiverSFX;
			playsound _shiver;
		};

		// Snow Dust occasional
		if (!(player call ROS_Fnc_UnderCover) && !ROS_auroraRunning && isnull objectParent player && nearestBuilding (vehicle player) distance (vehicle player) >30 && random 1 < 0.1) then {
			[] call ROS_Fnc_SnowDust;
		};

		sleep 1;

	}; /// END NO SNOW INTERVAL /// END NO SNOW INTERVAL /// END NO SNOW INTERVAL /// END NO SNOW INTERVAL ///

}; // while true

