/*

ROS_AuroraBD.sqf - by RickOShay

Description
Creates an Auroa Borealis green backdrop effect in the NW at night (sunOrMoon <1) when rain <0.2. Auroa is visible at night and not during snow fall.

Legal Stuff
Full credit must be given if you use this script in a mission or derivative work
This script is part of the ROS_Snowstorm system. If you want to use it independantly of ROS SnowStorm - please message me on Steam for approval.

Usage:
This script is called by ROS_SnowStorm
[] execvm "ROS_SnowStorm\scripts\ROS_AuroraBD.sqf";

*/

if (!hasInterface) exitwith {};

if (isnil "ROS_auroraRunning") then {ROS_auroraRunning = false};

if (ROS_auroraRunning) exitWith {};

ROS_auroraRunning = true;
ROS_auroraCCrunning = false;

// Start Col Correction
ROS_Fnc_CCstartAurora = {
    ROS_auroraCCrunning = true;
    auroraCC = ppEffectCreate ["colorCorrections", 1550];
    auroraCC ppEffectEnable true;
    auroraCC ppEffectAdjust [1, 1, 0, [0,0.4,0.1,0.2], [0,0.7,0.3,0.8], [0,0.65,0.65,0]];
    auroraCC ppEffectCommit 30;
};

// Reset Col Correction
ROS_Fnc_CCresetAurora = {
    auroraCC ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0.299, 0.587, 0.114, 0], [-1, -1, 0, 0, 0, 0, 0]];
    auroraCC ppEffectCommit 35;
    sleep 35;
    auroraCC ppEffectEnable false;
    ppEffectDestroy auroraCC;
    ROS_auroraCCrunning = false;
};

// Min Aurora length 5m <-> 8m
ROS_auroraLength = selectRandom [120,180,240];
ROS_auroraEndTime = time + ROS_auroraLength;
ROS_auroraEmitter = objnull;

// Set Emitter Position [distance, heading]
_dist = (getObjectViewDistance select 0);
_pos = player getpos [1800, 270];
_h = (getTerrainHeightASL _pos)+200;
_pos set [2,_h];
_lCenter = createCenter sideLogic;
_lGrp = createGroup _lCenter;
ROS_auroraLogic = _lGrp createUnit ["Logic", _pos, [], 0, "NONE"];

// Start Aurora particles
ROS_auroraEmitter = "#particlesource" createVehicleLocal _pos;
ROS_auroraEmitter attachto [ROS_auroraLogic,[0,0,0]];
ROS_auroraEmitter setParticleCircle  [700, [-20,-20,30]];

// Lifetime
_lt = 25;

while {time < ROS_auroraEndTime && rain < ROS_auroraOCMax && alive ROS_auroraEmitter && sunOrMoon <1} do {

    ROS_auroraEmitter setParticleRandom [
    0, // lt
    [0,0,0], // pos
    [0, 0, -5], // vel
    1, // rot
    0, // size
    [0,0,0,0], // col
    1, // rnd dir per
    0 // rnd dir inten
    ];

    ROS_auroraEmitter setParticleParams [
    ["\A3\data_f\kouleSvetlo",1,0,1],
    "",
    "Billboard",
    1, // timer per
    _lt, // lifetime
    [0,0,0], // pos
    [0,0,0], // vel
    0, //rot vel
    9.999, // weight
    7.9, // vol
    0, // rub
    [70,70,70], //size
    [[0,1,0,0], [0,1,0,0.001], [0,1,0,0.4], [0,1,0,0.4],[0,1,0,0.4],[0,1,0,0.4],[0,1,0,0.4], [0,1,0,0.001], [0,1,0,0]], //col over lifetime
    [0], // anim spd
    1, // rnd dir per
    0, // rand dir inten
    "", // on timer script
    "", // before destroy script
    "", // obj
    0, //angle
    false // onSurface
    ];

    ROS_auroraEmitter setDropInterval 0.001;

    // Start CC
    if !(ROS_auroraCCrunning) then {[] spawn ROS_Fnc_CCstartAurora};

    sleep 15;

    // Update emitter pos
    _pos = player getpos [1800, 270];
    _h = (getTerrainHeightASL _pos)+200;
    _pos set [2,_h];
    ROS_auroraLogic setPosATL _pos;
    ROS_auroraEmitter setPosATL _pos;
};

// End Aurora While
if (ROS_SnowDebug) then {hintSilent "Aurora while loop ends"; sleep 2;};

// End Aurora particles
[] spawn {
    sleep 10;
    // Remove Aurora Particle Emitter
    {if (typeOf _x == "#particlesource") then {deleteVehicle _x; sleep 0.1;}} forEach (ROS_auroraEmitter nearObjects 50);
    deleteVehicle ROS_auroraEmitter;
    ROS_auroraRunning = false;
};

// Reset CC and reduce particles
if (ROS_auroraCCrunning) then {call ROS_Fnc_CCresetAurora};

