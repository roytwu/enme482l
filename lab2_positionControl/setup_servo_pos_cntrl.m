%* ---------- ---------- ----------
%* SETUP_SERVO_POS_CNTRL
%* Description: Sets the necessary parameters to run the position control laboratory 
%* Copyright:   Quanser
%* History:     02/10/2025 - upload to github
%* ---------- ---------- ----------
clear all;
%% SRV02 Configuration
% External Gear Configuration: set to 'HIGH' or 'LOW'
EXT_GEAR_CONFIG = 'HIGH';

% Type of Load: set to 'NONE', 'DISC', or 'BAR'
LOAD_TYPE = 'DISC';

% Amplifier Gain: set VoltPAQ amplifier gain to 1
K_AMP = 1;

% Power Amplifier Type: set to 'VoltPAQ', 'UPM_1503', or 'UPM_2405'
AMP_TYPE = 'VoltPAQ';

% Is servo equipped with tachometer?: set to 'YES' or 'NO'
TACH_OPTION = 'NO';

%% Lab Configuration
% Type of controller: set it to 'AUTO', 'MANUAL'
CONTROL_TYPE = 'AUTO_PD';   
% CONTROL_TYPE = 'AUTO_PID';   
% CONTROL_TYPE = 'MANUAL';

%% Control specifications
% Peak time (s)
tp = 0.20;

% Percentage overshoot (%)
PO = 5.0;

% Slope of ramp reference (rad/s)
R0 = 2*pi/3 / (1/0.8/2);

% Integral time to find integral gain (s)
ti = 1.0;

%% System Parameters
%* Load servo system parameters.
[ Rm, kt, km, Kg, eta_g, Beq, Jm, Jeq, eta_m, K_POT, K_ENC, VMAX_AMP, IMAX_AMP ]...
  = config_servo( EXT_GEAR_CONFIG, TACH_OPTION, AMP_TYPE, LOAD_TYPE );

%% Calculate PIV Control Gains
if strcmp ( CONTROL_TYPE , 'MANUAL' )
    %* Load model parameters based on servo configuration.    
    K = 10;    % enter correct value
    tau = 0.1; % enter correct value
    %* PIV control gains
    kp = 0;
    kd = 0;
    ki = 0;
elseif strcmp ( CONTROL_TYPE , 'AUTO_PD' )
    %* Load model parameters 
    [K,tau] = d_model_param(Rm, kt, km, Kg, eta_g, Beq, Jeq, eta_m);

    %* Calculate PV control gains given specifications.
    [ kp, kd ] = d_pd_design( K, tau, PO, tp );
    
    %* Integral gain (V/rad/s)
    ki = 0; 
elseif strcmp ( CONTROL_TYPE , 'AUTO_PID' )
    %* Load model parameters 
    [K,tau] = d_model_param(Rm, kt, km, Kg, eta_g, Beq, Jeq, eta_m);
    
    %* Calculate PV control gains given specifications.
    [ kp, kd ] = d_pd_design( K, tau, PO, tp );
    
    %* Ramp steady-state error when using PV control.
    [ e_ss ] = d_e_ss_ramp_pd (R0, kp, kd, K); 
    
    %* Calculate integral gain
    VmaxOut = 10; % max output voltage
    [ ki ] = d_i_design( VmaxOut, kp, e_ss, ti);     
end
%% Display
disp( ' ' );
disp( 'Servo model parameters: ' );
disp( [ '   K = ' num2str( K, 3 ) ' rad/s/V' ] );
disp( [ '   tau = ' num2str( tau, 3 ) ' s' ] );
disp( 'Specifications: ' );
disp( [ '   tp = ' num2str( tp, 3 ) ' s' ] );
disp( [ '   PO = ' num2str( PO, 3 ) ' %' ] );
disp( 'Calculated PD control gains: ' );
disp( [ '   kp = ' num2str( kp, 3 ) ' V/rad' ] );
disp( [ '   kd = ' num2str( kd, 3 ) ' V.s/rad' ] );
disp( 'Integral control gain for triangle tracking: ' );
disp( [ '   ki = ' num2str( ki, 3 ) ' V/rad/s' ] );

%%* 