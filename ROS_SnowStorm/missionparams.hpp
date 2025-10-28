class Params {

    class ROS_overcastStart {
        title = "Set the overcast start value";
        texts[] = { "0.2", "0.3", "0.4 Default", "0.5", "0.6"};
        values[] = {0,1,2,3,4};
        default = 2;
    };
    class ROS_timeMulti {
        title = "Set the mission time multiplier";
        texts[] = {"0 Ignore", "1", "3", "8 Default", "12"};
        values[] = {0,1,3,8,12};
        default = 8;
    };
    class ROS_maxSnowStrength {
        title = "Select the maximum Snow Storm strength";
        texts[] = {"Random (Default)", "Light", "Heavy"};
        values[] = {0,1,2};
        default = 0;
    };
    class ROS_eyewearCheck {
        title = "Player suffers if not wearing eyewear";
        texts[] = { "Off (Default)", "On"};
        values[] = {0,1};
        default = 0;
    };
    class ROS_weatherWarning {
        title = "Radio warning for extreme weather conditons";
        texts[] = { "Off", "On (Default)"};
        values[] = {0,1};
        default = 1;
    };
    class ROS_Shivering {
        title = "Occasional shivering sounds from player";
        texts[] = { "Off", "On (Default)"};
        values[] = {0,1};
        default = 1;
    };
    class ROS_addFB {
        title = "Nearby units breathe out steam";
        texts[] = { "Off", "On (Default)"};
        values[] = {0,1};
        default = 1;
    };
    class ROS_screenWater {
        title = "Water drops occasionally form on windows and goggles";
        texts[] = { "Off", "On (Default)"};
        values[] = {0,1};
        default = 1;
    };
    class ROS_AuroraEnable {
        title = "Aurora Borealis appears at night when conditions are right";
        texts[] = { "Off", "On (Default)"};
        values[] = {0,1};
        default = 1;
    };
    class ROS_snowDebug {
        title = "Enable Debug for testing";
        values[] = {0,1};
        texts[] = { "Off (Default)", "On"};
        default = 0;
    };
};
