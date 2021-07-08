clc;
clear all
close all

dp = [0.1:0.1:20]; %diameter
%% Force model (Habchi et al. 2016)

a1 = 5e-9; %fitting coeff.
b1 = -8*10^-7; %fitting coeff.
r1 = a1*dp.^3 - b1*dp;
r1=r1.*3600; %converting to hr-1

%% Box model (Qian and Ferro, 2008)
L = 0.065; %mean free path of air
Cc = 1 + 2*L./dp.*(1.257+0.4*exp(-1.1*dp/(2*L))); %slip correction
 a2 =   6.689e-07; %fitting coeff.
 b2 =   1.133e-07; %fitting coeff.
r2 = a2*sqrt(dp)+b2*dp.^2.*coth(dp.^2.*sqrt(dp));
r2=r2.*3600; %converting to hr-1

%% Linear (Khare & Marr, 2015) 

p1 =    0.004351;
p2 =   -0.003468;  
r3_linear = p1*dp + p2;


%% Experimental data from https://nvlpubs.nist.gov/nistpubs/TechnicalNotes/NIST.TN.1841.pdf. 
%Need to use more exp data to validate above resusp vs. diameter models

d_val=[7.5
3.5
1.5
0.9];

r_val=[0.029
0.0125
0.00165
0.00128];

%% Figures
figure()
loglog(dp,r1)
hold on
plot(dp,r2)
hold on
loglog(dp,r3_linear)
hold on
loglog(d_val,r_val, 'o-')
legend('Force model','Box model','Linear','Exp data','Location','SouthEast')
xlabel('Particle diameter (\mum)')
ylabel('Resuspension rate (1/hr)')