// Foggy breath by RickOShay
// Desynchronized breathing steam for winter maps at start
// No breath steam indoors or in vehicles

// Part of ROS_SnowStorm but can be used independently.
// If you are not running ROS_SnowStorm place the following line in your init.sqf:
// [] execvm "ROS_SnowStorm\scripts\ROS_FoggyBreath.sqf";

if !(hasinterface) exitWith {};

ROS_FoggyBreath = {
	params ["_unit"];

	sleep random 3;

	_emitter = "#ParticleSource" createVehicleLocal [0,0,0];
	_emitter attachto [_unit,[0,0.13,-0.02],"neck"];
	_emitter setParticleparams [
	["\A3\data_f\cl_basic", 1, 0, 1],
	"",
	"Billboard",
	0.5, // timer
	0.5, // lt
	[0,0,0], // pos
	[0, 0.2, -0.2], //vel
	1, // rot vel
	1.275, //weight
	1, //vol
	0.1, //rub
	[0, 0.2, 0],//size
	[[1, 1, 1, 0.01], [1, 1, 1, 0.01], [1, 1, 1, 0.0003]], //col
	[1000], //anim spd
	1, //rnd dir per
	0.04, //rnd dir inten
	"",
	"",
	""];

	_emitter setParticlerandom [
	2, // lt
	[0, 0, 0], //pos
	[0.25, 0.25, 0.25], // vel
	0, // rot
	0.5, // size
	[0, 0, 0, 0.1], // col
	0, // rnd dir per
	0, // rnd dir inten
	10 // angle
	];

	_emitter setDropinterval 0.001;
	sleep 0.7;
	deleteVehicle _emitter;
};

[] spawn {
	while {true} do {

		ROS_underCover = player call ROS_Fnc_UnderCover;

		if (!ROS_underCover) then {
			_nearMen = nearestObjects [player, ["CAManBase"], 35];
			{
				if ((alive _x) && !surfaceIsWater position player && (isNull objectParent _x) && time > (_x getVariable ["lastbreath", -1])) then {
					_x setVariable ["lastbreath",(floor time + 5)];
	                _x spawn ROS_FoggyBreath;
				};
			} forEach _nearMen;
		};

		sleep 5;
	};
};
