%* ---------- ---------- ----------
%* setup_rotflex
%* Description: Sets the necessary parameters to run the SRV02 Rotary Flexible Joint experiment
%* Copyright:   2010 Quanser Consulting Inc
%* History:     03/31/2025 - upload to github
%* ---------- ---------- ----------
clear all;
%% SRV02 Configuration
%* External Gear Configuration: set to 'HIGH' or 'LOW'
EXT_GEAR_CONFIG = 'HIGH';

%* Encoder Type: set to 'E' or 'EHR'
ENCODER_TYPE = 'E';

%* Is SRV02 equipped with Tachometer? (i.e. option T): set to 'YES' or 'NO'
TACH_OPTION = 'YES';

%* Type of Load: set to 'NONE', 'DISC', or 'BAR'
LOAD_TYPE = 'NONE';

%* Amplifier gain used: set to 1, 3, or 5
K_AMP = 1;
% Amplifier type: set to 'UPM_1503', 'UPM_2405', or 'Q3', or 'VoltPaq'
AMP_TYPE = 'VoltPaq';

%% Rotary Flexible Joint Configuration
%* Location of the Short Arm on main arm. 
%* Set to 0 if not connected, 1, 2 or 3 for each other position.
%* If the two holes near the short arm's end are used, set this value to 1.
%* If the short arm is attached to the main arm such that a hole near the
%* end is sticking out, set this value to 2. Otherwise, set it to 3.
ARM_LOAD = 1;

%% Control specifications

%* Natural frequency (rad/s)
%* This is the default value when the two springs are nice and strong.  
%* Speak to the TA to see if you need to re-measure the natural frequency 
wn = 20;

%* Damping ratio
zeta = 0.6;

%* Non-dominant poles
p3 = -30;
p4 = -40;

%% System Parameters
%* Sets model variables according to the user-defined SRV02 configuration
[Rm, kt, km, Kg, eta_g, Beq, Jm, Jeq, eta_m, K_POT, K_TACH, K_ENC, VMAX_AMP, IMAX_AMP]... 
= config_srv02( EXT_GEAR_CONFIG, ENCODER_TYPE, TACH_OPTION, AMP_TYPE, LOAD_TYPE );

%* Sets model variables according to the user-defined ROTFLEX configuration
[Jl, Bl] = config_rotflex( ARM_LOAD );

%* Joint Stiffness
disp ('');
Ks = input('Enter link stiffness (Ks): ');

%* Set Open-loop state-space model


%* Add dc motor dynamics
Ao = A;
Bo = B;
B  = eta_g*Kg*eta_m*kt/Rm*Bo;
A(3,3) = Ao(3,3) - Bo(3)*eta_g*Kg^2*eta_m*kt*km/Rm;
A(4,3) = Ao(4,3) - Bo(4)*eta_g*Kg^2*eta_m*kt*km/Rm;

%% Filter Parameters
%* SRV02 High-pass filter parameters used to compute the load gear angular velocity
% Cutoff frequency (rad/s)
wcf_1 = 2 * pi * 50.0;

%* Damping ratio
zetaf_1 = 0.9;

%* ROTFLEX High-pass filter parameters used to compute arm's deflection angular velocity
%* Cutoff frequency (rad/s)
wcf_2 = 2 * pi * 25.0;

%* Damping ratio
zetaf_2 = 0.9;

%% Calculate Control Parameters
d_pole_placement_student; 

%* Display
disp( ' ' );
K