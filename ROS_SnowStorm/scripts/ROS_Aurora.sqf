/*

ROS_Aurora.sqf - by RickOShay

Description
Creates an Auroa Borealis effect at night (sunOrMoon <1) when rain <0.65. Auroa is visible at night and not during snow fall.

Legal Stuff
Full credit must be given if you use this script in a mission or derivative work
This script is part of the ROS_Snowstorm system. If you want to use it independantly of ROS SnowStorm - please message me on Steam for approval.

Usage:
This script is called by ROS_SnowStorm
[] execvm "ROS_SnowStorm\scripts\ROS_Aurora.sqf";

*/

if (!hasInterface) exitwith {};

if (isnil "ROS_auroraRunning") then {ROS_auroraRunning = false};
if (ROS_auroraRunning) exitWith {};

ROS_auroraRunning = true;
ROS_auroraCCrunning = false;
ROS_auroraOCMax = 0.65;

// CC shades
ROS_Fnc_CCauroraShade = {
    params ["_shade"];

    _factors = []; // blend colorization desat wgt

    if (_shade == "GB") then {
        _factors = [[0,0.3,0.1,0.2], [0,0.7,0.3,0.8], [0,0.65,0.65,0]];
    };
    if (_shade == "LB") then {
        _factors = [[0,0.2,0.3,0.2], [0,0.4,0.5,0.8], [0,0.65,0.65,0]];
    };
    if (_shade == "PB") then {
        _factors = [[0.4,0,0.4,0.2], [0.6,0,0.8,0.8], [0.65,0,0.65,0]];
    };
    if (_shade == "PR") then {
        _factors = [[0.2,0,0.4,0.2], [0.7,0,0.6,0.8], [0.65,0,0.65,0]];
    };
    if (_shade == "YG") then {
        _factors = [[0.2,0.2,0,0.2], [0.4,0.4,0,0.8], [0.65,0.65,0,0]];
    };

    _factors;
};

// Start Col Correction
ROS_Fnc_CCstartAurora = {
    params ["_shade"];

    ROS_auroraCCrunning = true;

    // Match CC shade to aurora
    _factors = ([_shade] call ROS_Fnc_CCauroraShade) params ["_blend","_col","_weight"];
    auroraCC = ppEffectCreate ["colorCorrections", 1550];
    auroraCC ppEffectEnable true;
    auroraCC ppEffectAdjust [1, 1, 0, _blend, _col, _weight];
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

// col over lifetime
_colGB = [[0,1,0,0.02], [0,1,0,0.02], [0,1,0,0.02], [0,1,0,0.02], [0,1,0.4,0.02], [0,1,0.4,0.02], [0,1,0.3,0.005]];
_colLB = [[0,1,0.5,0.02], [0,1,0.7,0.02], [0,1,1,0.02], [0,0.3,1,0.02], [0,0.2,1,0.02], [0,0.1,1,0.02], [0,0.1,1,0.005]];
_colPB = [[1,0,1,0.02], [1,0,1,0.02], [0.4,0,1,0.02], [0.3,0,1,0.02], [0.1,0,0.8,0.02], [0,0,0.8,0.02], [0,0,0.8,0.005]];
_colPR = [[0.1,0,1,0.02], [0.2,0,1,0.02], [0.3,0,1,0.02], [0.5,0,0.3,0.02], [1,0,0.2,0.02], [1,0,0.1,0.02], [1,0,0.1,0.005]];
_colYG = [[1,1,0,0.02], [1,1,0,0.02], [1,1,0,0.02], [0.3,1,0,0.02], [0.1,0.5,0,0.02], [0,0.5,0,0.02], [0,0.5,0,0.005]];

_cols = [_colGB, _colLB, _colPB, _colPR, _colYG]; //, _colYG, _colYG];
_col = selectRandom _cols;
_idx = _cols find _col;
_shade = ["GB", "LB", "PB", "PR", "YG"] select _idx;

AuroraShade = _shade;

// Lifetime
_lt = 25;

_pos = (vehicle player) getpos [1800,300];
_h = (getTerrainHeightASL _pos)+75;
_pos set [2,_h];

// Create Emitter and start Aurora particles
ROS_auroraEmitter = "#particlesource" createVehicleLocal [0,0,0];
ROS_auroraEmitter setposASL _pos;
_arry = selectRandom [[10,-10,0],[-10,20,0],[10,20,0],[10,-20,0],[20,10,0],[20,-10,0],[-20,10,0],[30,10,0],[30,-10,0],[-30,10,0]];
//hint format ["Arry: %1",_arry];
ROS_auroraEmitter setParticleCircle  [500, _arry];

while {time < ROS_auroraEndTime && rain < ROS_auroraOCMax && alive ROS_auroraEmitter && sunOrMoon <1} do {

    ROS_auroraEmitter setParticleRandom [
    0, // lt
    [0,0,0], // pos
    [0, 0, 0], // vel
    0, // rot
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
    [0,0,10], // vel
    0, //rot vel
    9.99, // weight
    8.5, // vol
    0, // rub
    [100,100,100], //size
    _col, // col over lifetime
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

    _pos = (vehicle player) getpos [1800,300];
    _h = (getTerrainHeightASL _pos)+75;
    _pos set [2,_h];

    ROS_auroraEmitter setposASL _pos;

    // Start CC
    if !(ROS_auroraCCrunning) then {[_shade] spawn ROS_Fnc_CCstartAurora};

    sleep 10;
}; // End Aurora While

if (ROS_SnowDebug) then {hintSilent "Aurora while loop ends"; sleep 2;};

// End Aurora particles
[] spawn {
    sleep 10;
    // Remove Aurora Particle Emitter
    {if (typeOf _x == "#particlesource") then {deleteVehicle _x; sleep 0.1;}} forEach (ROS_auroraEmitter nearObjects 50);
    deleteVehicle ROS_auroraEmitter;
    ROS_auroraRunning = false;
};

// Reset CC
if (ROS_auroraCCrunning) then {call ROS_Fnc_CCresetAurora};


