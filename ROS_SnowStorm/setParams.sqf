// Part of ROS SnowStorm by RickOShay
// [] execvm "ROS_SnowStorm\setParams.sqf";

params ["_return"];

if (!isMultiplayer) exitWith {};

_bool = true;
_val = 0;

_return = ["ROS_overcastStart", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_val = 0.2};
if (_return ==1) then {_val = 0.3};
if (_return ==2) then {_val = 0.4};
if (_return ==3) then {_val = 0.5};
if (_return ==4) then {_val = 0.6};
if (_return >-1) then {ROS_overcastStart = _val; publicVariable "ROS_overcastStart"};

_return = ["ROS_timeMulti", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_val = -1};
if (_return ==1) then {_val = 1};
if (_return ==3) then {_val = 3};
if (_return ==8) then {_val = 8};
if (_return ==12) then {_val = 12};
if (_return >-1) then {ROS_timeMulti = _val; publicVariable "ROS_timeMulti"};

_return = ["ROS_maxSnowStrength", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_val = 0};
if (_return ==1) then {_val = 1};
if (_return ==2) then {_val = 2};
if (_return >-1) then {ROS_maxSnowStrength = _val; publicVariable "ROS_maxSnowStrength"};

_return = ["ROS_eyewearCheck", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_eyewearCheck = _bool; publicVariable "ROS_eyewearCheck"};

_return = ["ROS_weatherWarning", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_weatherWarning = _bool; publicVariable "ROS_weatherWarning"};

_return = ["ROS_Shivering", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_Shivering = _bool; publicVariable "ROS_Shivering"};

_return = ["ROS_addFB", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_addFB = _bool; publicVariable "ROS_addFB"};

_return = ["ROS_screenWater", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_screenWater = _bool; publicVariable "ROS_screenWater"};

_return = ["ROS_AuroraEnable", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_AuroraEnable = _bool; publicVariable "ROS_AuroraEnable"};

_return = ["ROS_snowDebug", -1] call BIS_fnc_getParamValue;
if (_return ==0) then {_bool = false};
if (_return ==1) then {_bool = true};
if (_return >-1) then {ROS_snowDebug = _bool};

