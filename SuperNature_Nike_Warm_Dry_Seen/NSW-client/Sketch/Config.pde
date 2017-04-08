
@Parameter(min = 3, max = 10) float CFG_SWITCH_MENU_SECONDS = 5;
@Parameter(min = 3, max = 10) float CFG_SWITCH_IDLE_SECONDS = 3;

@Parameter(min = 0.00001, max = 0.001) float CFG_WARM_DRAGGING = 0.0001;
@Parameter(min = 0.0001, max = 0.01) float CFG_DRY_DRAGGING = 0.001;
@Parameter(min = 0.01, max = 1) float CFG_DRY_DAMPING = 0.2;

float MENU_FADEIN_SECONDS = 0.5;
float MENU_FADEOUT_SECONDS = 0.5;
// float TRANSITION_FADEOUT_SECONDS = 1.3;
float INTERACTOIN_FADEIN_SECONDS = 1.5;
float INTERACTOIN_FADEOUT_SECONDS = 0.5;

boolean SHOW_GUI = true;

float TARGET_WIDTH = 1440;
float TARGET_HEIGHT = 2160;

float PSD_WIDTH = TARGET_WIDTH;
float PSD_HEIGHT = TARGET_HEIGHT;

float outerX[] = {80, 1360, 720};
float outerY[] = {671 - 90, 671 - 90, 1779 - 90};
float innerX[] = {603, 837, 720};
float innerY[] = {994 - 90, 994 - 90, 1198 - 90};

// Menu

// for button && glow
int SEEN_MENU_X = 946, SEEN_MENU_Y = 1755;
int WARM_MENU_X = 120, WARM_MENU_Y = 1755;
int DRY_MENU_X = 533, DRY_MENU_Y = 1755;
int SEEN_MENU2_X = 891, SEEN_MENU2_Y = 1705;
int WARM_MENU2_X = 65, WARM_MENU2_Y = 1705;
int DRY_MENU2_X = 478, DRY_MENU2_Y = 1705;

int SEEN_TIPS_X = 490, SEEN_TIPS_Y = 1829;
int WARM_TIPS_X = 382, WARM_TIPS_Y = 1829;
int DRY_TIPS_X = 382, DRY_TIPS_Y = 1829;
int tipsX[] = {WARM_TIPS_X, DRY_TIPS_X, SEEN_TIPS_X};
int tipsY[] = {WARM_TIPS_Y, DRY_TIPS_Y, SEEN_TIPS_Y};

float MENU_BUTTON_RADIUS = 90;
int LOGO_X = 470, LOGO_Y = 130;

// Transition
int TRANS_X = 0, TRANS_Y = 446;

// Warm
int WARM_CENTER_X = 720, WARM_CENTER_Y = 1135;

// Dry

// Seen
float SEEN_TRIANGLE_FADE_SECONDS = 3;

// Interaction Scenes
int TITLE_X = 420, TITLE_Y = 170;
int HOME_X = 1050, HOME_Y = 1975;
int HELP_X = 1210, HELP_Y = 1975;
int URL_X = 516, URL_Y = 2069;

//
int POP_WARM_X = 125, POP_WARM_Y = 1463;
int POP_WARM_COLOR_X = 127, POP_WARM_COLOR_Y = 1506;

int POP_DRY_X = 144, POP_DRY_Y = 1505;
int POP_DRY_COLOR_X = 132, POP_DRY_COLOR_Y = 1562;

int POP_SEEN_X = 147, POP_SEEN_Y = 1470;
int POP_SEEN_COLOR_X = 266, POP_SEEN_COLOR_Y = 1576;
int popX[] = { POP_WARM_X, POP_WARM_COLOR_X, POP_DRY_X, POP_DRY_COLOR_X, POP_SEEN_X, POP_SEEN_COLOR_X};
int popY[] = { POP_WARM_Y, POP_WARM_COLOR_Y, POP_DRY_Y, POP_DRY_COLOR_Y, POP_SEEN_Y, POP_SEEN_COLOR_Y};

float POP_SIN_TIME_SECONDS = 1;