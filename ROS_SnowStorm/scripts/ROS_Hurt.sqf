// Requires ROS_SnowStorm.sqf v1.0 by RickOShay

params ["_unit","_endtime"];

_sounds = ["hurt1","hurt2","hurt3","hurt4","hurt5","hurt6","hurt7"];

sleep 21;

if (vehicle player == player && goggles player == "") then {hint "Put on protective eyewear or get under cover";};

sleep 2;

if (ROS_snowDebug) then {hint "Start Hurt loop"; sleep 3;};

While {time < _endtime} do {

	// Is player inside a building and is door open/closed?
    ROS_underCover = player call ROS_Fnc_UnderCover;

   	// not in vehicle - or building and near blizzard conditions.
	if (vehicle player == player && !ROS_underCover && rain > 0.85) then {
		// not wearing goggles => hurt
		if (goggles player == "") then {
			_hurt = selectRandom _sounds;
	   		player say3d _hurt;
			sleep 10 + random 5;
			_damage = damage player;
			player setDamage (_damage + 0.01);
			hintSilent "Put on protective eyewear or get under cover";
		};
	};

	sleep 1;

};

