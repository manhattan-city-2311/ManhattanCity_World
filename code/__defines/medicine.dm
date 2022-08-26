#define BLOOD_PERFUSION_SAFE    0.85
#define BLOOD_PERFUSION_OKAY    0.75
#define BLOOD_PERFUSION_BAD     0.60
#define BLOOD_PERFUSION_SURVIVE 0.40

#define BLOOD_PRESSURE_LCRITICAL 50
#define BLOOD_PRESSURE_L2BAD 65
#define BLOOD_PRESSURE_LBAD 80
#define BLOOD_PRESSURE_NORMAL 93
#define BLOOD_PRESSURE_HBAD 130
#define BLOOD_PRESSURE_H2BAD 180
#define BLOOD_PRESSURE_HCRITICAL 200

#define GLUCOSE_LEVEL_LCRITICAL 16.8
#define GLUCOSE_LEVEL_L2BAD 25.6
#define GLUCOSE_LEVEL_LBAD 31.2
#define GLUCOSE_LEVEL_NORMAL_LOW 32
#define GLUCOSE_LEVEL_NORMAL 50
#define GLUCOSE_LEVEL_HBAD 65.6
#define GLUCOSE_LEVEL_H2BAD 88
#define GLUCOSE_LEVEL_HCRITICAL 136
#define GLUCOSE_LEVEL_H2CRITICAL 264

#define POTASSIUM_LEVEL_HBAD 30.5
#define POTASSIUM_LEVEL_HCRITICAL 50

// in ml
#define MAX_MCV 30000
#define NORMAL_MCV 3700

#define MAX_PRESSURE 283
#define ARRYTHMIA_SEVERITY_OVERWRITING 5

#define ARRYTHMIA_AFIB "afib"
#define ARRYTHMIA_AFLAUNT "aflaunt"
#define ARRYTHMIA_VFIB "vfib"
#define ARRYTHMIA_TACHYCARDIA "tachycardia"
#define ARRYTHMIA_VFLAUNT "vflaunt"
#define ARRYTHMIA_ASYSTOLE "asystole"
#define ARRYTHMIA_EXTRASYSTOLIC "extrasystolic"

#define HUMAN_MAX_OXYLOSS 1

// We dont care about too low CO2 levels.
// ml/L
#define CO2_LEVEL_NORMAL 25

#define OXYGEN_LEVEL_NORMAL 750

#define SHOCK_STAGE_PAIN_MESSAGE 10
#define SHOCK_STAGE_SCREAM 30
#define SHOCK_STAGE_STUN 60
#define SHOCK_STAGE_AGONY 110 
#define SHOCK_STAGE_MAX 160
#define SHOCK_EMOTE_PERIOD 100
#define SHOCK_MESSAGE_PERIOD 300

#define SHOCK_PAIN_MESSAGES "The pain is excruciating!", "Please, just end the pain!", "It hurts so much!", "You really need some painkillers!"
#define SHOCK_PAIN_MESSAGES_SEVERE "FUCKING STOP THIS!!", "You feel like you are dying right now!", "You are losing consciousness!", "The pain is driving you insane!", "OH-H GODNESS, PAIN IS INSANE!", "Pain is depriving you of consciousness!"

#define REST_OXYGEN_CONSUMING 2
#define WALK_OXYGEN_CONSUMING (2/WALK_DELAY)
#define RUN_OXYGEN_CONSUMING  (5)
