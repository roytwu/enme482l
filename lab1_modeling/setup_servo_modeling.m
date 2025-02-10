%* ---------- ---------- ----------
%* SETUP_SERVO_MODELING
%* Description: Sets the necessary parameters to run the Servo Modeling laboratory 
%* Copyright:   2010 Quanser Consulting Inc
%* History:     02/10/2025 - upload to github
%* ---------- ---------- ----------

clear all;
%% Rotary Servo Configuration
% External Gear Configuration: set to 'HIGH' or 'LOW'
EXT_GEAR_CONFIG = 'HIGH';

% Type of Load: set to 'NONE', 'DISC', or 'BAR'
LOAD_TYPE = 'DISC';

% Amplifier Gain: set VoltPAQ amplifier gain to 1
K_AMP = 1;

% Power Amplifier Type: set to 'VoltPAQ', 'UPM_1503', or 'UPM_2405'
AMP_TYPE = 'VoltPaq';

% Is servo equipped with tachometer?: set to 'YES' or 'NO'
TACH_OPTION = 'NO';

%% Lab Configuration
% Type of Controller: set it to 'AUTO', 'MANUAL'
% MODELING_TYPE = 'AUTO';   
MODELING_TYPE = 'MANUAL';

%% System Parameters
% Load servo system parameters.
[ Rm, kt, km, Kg, eta_g, Beq, Jm, Jeq, eta_m, K_POT, K_ENC, VMAX_AMP, IMAX_AMP ] = ...
  config_servo( EXT_GEAR_CONFIG, TACH_OPTION, AMP_TYPE, LOAD_TYPE );


% Load Model Parameters
if strcmp ( MODELING_TYPE , 'MANUAL' )
    K = 1;
    tau = 0.1;    
else    
    [K,tau] = d_model_param(Rm, kt, km, Kg, eta_g, Beq, Jeq, eta_m);
end
%% Display
disp( 'Calculated servo model parameter: ' )
disp( [ '   K = ' num2str( K, 3 ) ' rad/s/V' ] )
disp( [ '   tau = ' num2str( tau, 3 ) ' s' ] )


