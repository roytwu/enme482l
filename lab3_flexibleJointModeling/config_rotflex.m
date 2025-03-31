%* ---------- ---------- ----------
%* conflig_retflex
%* Description: Find the moment of inertia and stiffness parameters of 
%               the SRV02 Rotary Flexible Joint plant.
%* Copyright:   2010 Quanser Consulting Inc
%* History:     03/31/2025 - upload to github
%* ---------- ---------- ----------
% ************************************************************************
% Input parameters:
% ARM_LOAD          Location of short arm on main arm (set to 0 if not 
%                   connected, 1, 2 or 3 for each other position).
%
% ************************************************************************
% Output parameters:
% Jl                Moment of inertia of flexible joint   (kg.m^2)
% Bl                Viscous damping of flexible link      (N.m/(rad/s))

%%
function [ Jl, Bl  ] = config_rotflex ( ARM_LOAD )
%* Arm Mass and Length Constants
% Main Arm (bottom arm that is attached to base)
m1= 0.064; % 64 grams
L1 = 11.75 * 0.0254; % 11 3/4 inches

% Short Arm (attached to main arm)
m2 = 0.03; % 30 grams
L2 = 6.125 * 0.0254; % 6 1/8 inches
%
% Distance from rotation axis to middle of short arm
d12(1) = (5+3/16)*0.0254 + L2/2; % 8 1/4 inch
d12(2) = (6+3/16)*0.0254 + L2/2; % 9 1/4 inch
d12(3) = (7+3/16)*0.0254 + L2/2; % 10 1/4 inch


%* Moment of Inertia
% Main arm moment of inertia (kg.m^2)
J1 = m1*L1^2 / 3; % J = m*l^2 / 3
% Short arm moment of inertia about CM (kg.m^2)
% NOTE: This is the moment of inertia about its center of gravity (i.e not the pivot).
J2_cog = m2*L2^2 / 12; % J = m*l^2 / 12 
%
% Complete arm moment of inertia (kg.m^2)
% note: found using parallel axis theorem: J = J_cog + M*D^2
if ARM_LOAD == 0
    Jl = J1; % if short arm not attached, only main arm
else
    Jl = J1 + J2_cog + m2 * d12(ARM_LOAD)^2;
end
%
% Arm equivalent viscous damping (N.m/(rad/s))
Bl = 0; % assume it is negligible
