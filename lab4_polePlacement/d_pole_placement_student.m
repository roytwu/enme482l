%* IMPORTANT: Make sure you run setup_rotflex.m first

%% Find Tranformation Matrix W
%* Characteristic equation: s^4 + a_4*s^3 + a_3*s^2 + a_2*s + a_1
a = poly(A);


%* Companion matrices Ac & Bc (Phase Variable Form) 
Ac = [ 0 1 0 0;
       0 0 1 0;
       0 0 0 1;
       -a(5) -a(4) -a(3) -a(2)];

Bc = [0; 0; 0; 1];

%* Controllability matrix of A
T = 0;

%* Controllability matrix of Ac
Tc = 0;

%* Transformation matrices (matrix P in the prompt)
W = 0;

%% Find Control Gain
%* Gain for the companion form (K in the pormpt)
Kc = [0 0 0 0];

%* Gain for the original non-PVF system (K' in the prompt)
K = [0 0 0 0]

%% Closed-loop System Poles
%* Find poles of closed-loop system. 
%* Verify that they are the same as the desired poles.
cls_poles = [0 0 0 0]
