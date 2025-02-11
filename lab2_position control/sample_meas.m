%* ---------- ---------- ----------
%* SAMPLE_MEAS_ESS
%* Description: Plots the position and input voltage response found in the data_pos 
%               and data_vm variables. 
%               This script then measureds the associate steady-state error 
%               of the saved position ramp response.
%* Copyright:   Quanser Consulting Inc
%* History:     02/10/2025 - upload to github
%* ---------- ---------- ----------

%% Setup variables
% Load from variables set in workspace after running a Simulink model or
% from the previously saved response saved in the MAT files above.
t  = data_pos(:,1);
yd = data_pos(:,2);
y  = data_pos(:,3);
u  = data_vm(:,2);

%% Plot response
subplot(2,1,1);
plot(t,yd,'b:',t,y,'r-');
ylabel('\theta_l (rad)');

subplot(2,1,2);
plot(t,u,'r-');
ylabel('V_m (V)');
xlabel('time (s)');
