% Author: Yue Qiu 
% Date: 2024-08-13
% Calculate the T-dependent thermodynamic data (Cp/R, h/RT, s/R) from thermo.dat.
% The calculation equation is given as:
% Cp/R = a1 + a2T + a3T^2 + a4T^3 + a5T^4.
% h/RT = a1 + a2/2*T + a3/3*T^2 + a4/4*T^3 + a5/5*T^4 + a6/T.
% s/R = a1lnT + a2*T +a3/2*T^2 + a4/3*T^3 + a5/4*T^4 + a7.
% Function instruction: 
% Step 1: Add chemkin thermo data to 'thermo_test.dat' 
% Step 2: You can choose between Cp, H, and S. The result cell contains: 1. x_var [K] y_var[Cp, H, S] y_diff[relative ratio];
% 2. peak: min / max T_point and y_point.

clc; clear;
close all;
[result] = fun_plot('thermo_test.dat',["Cp", "H","S"]);%["Cp", "H","S"]
