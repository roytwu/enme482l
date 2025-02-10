%* ---------- ---------- ----------
%* Description:    Creating Polots from experiment data 
%* History:        02/10/2025 - upload to github
%* ---------- ---------- ----------

% Save variables
t       = wl(:,1);
wl_meas = wl(:,2);
wl_sim  = wl(:,3);
vm      = Vm(:,2);
% 

% Plot response
subplot(2,1,1)
plot(t,wl_meas,t,wl_sim);
ylabel('\omega_l (rad/s)');

subplot(2,1,2)
plot(t,vm);
ylabel('V_m (V)');
xlabel('time (s)')
%