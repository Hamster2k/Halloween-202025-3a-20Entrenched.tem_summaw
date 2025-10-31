player setVariable ["_spawnLoadout", getUnitLoadout player];

// Post-processing effects for Halloween atmosphere
waitUntil {!isNull (findDisplay 46)};

// Color Corrections - Desaturated and darker 
"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectAdjust [ 
    1.0,    // brightness (keep normal) 
    1.0,    // contrast (keep normal) 
    0.0,    // offset (keep normal) 
    [0.0, 0.0, 0.0, 0.0],  // RGB offset (no change) 
    [0.35, 0.6, 0.45, 0.7],  // RGB multiplier (slight desaturation) 
    [1.0, 1.0, 1.0, 0.0]   // RGB gamma (keep normal) 
]; 
"colorCorrections" ppEffectCommit 0;

// Film Grain effect
"filmGrain" ppEffectEnable true;
"filmGrain" ppEffectAdjust [
    0.15,   // intensity (0.0-1.0)
    1.5,    // sharpness (0.0-20.0)
    0.8,    // grain size (0.0-8.0)
    0.2,    // intensity X
    0.2,    // intensity Y
    true    // monochrome grain
];
"filmGrain" ppEffectCommit 0;
