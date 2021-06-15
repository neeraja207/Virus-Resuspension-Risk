
clear()
clc()
%% Code gets indoor air dust/virus associated dust concentrations over time by resuspension
%% Parameters

Ar=25;         %Resuspension area, m2
B=1;           %Overall particle loss rate from air, 1/hr
V=222;         %Volume of the room, m3
L_0=1.2*10^6;  %Initial floor dust/virus associated dust concentration, ug/m2
C_0=0;         %Initial indoor air dust/virus associated dust concentration, ug/m3
k=B;           %Deposition loss rate from air, 1/hr (assumed as the only loss process here)
A=66;          %Floor surface area, m2
k_surf=0.11;   %Virus inactivation rate, 1/hr (values from Nastasi, Nicholas, et al. "Viability of MS2 and Phi6 Bacteriophages on Carpet and Dust." bioRxiv (2021))

t1=0:0.001:0.5; %Time period for resuspension, hr (time step:0.001 hr)

r=1.4*10^-3;   %Resuspension rate, 1/hr (depends on particle size; this value is from Qian et al 2012 for PM10)

%% Equations for resuspension period to get indoor air concentration C(t)and surface concentration L(t)vs time, t:
% term1, term2 and term3 are obtained by substituting L(t) from Eqn V into Eqn III.

term1= (r.*Ar.*(1-exp(-B.*t1)).*L_0.*exp(-(r+k_surf).*t1))./(V.*B);
term2=C_0.*exp(-B.*t1);
term3=(Ar.*(1-exp(-B.*t1)).*k.*(1-exp(-(r+k_surf).*t1)))./(A*B);

C1=(term1+term2)./(1-term3); %%indoor conc.
L1=(((k.*V.*C1).*(1-exp(-(r+k_surf).*t1)))./((r+k_surf).*A))+(L_0*exp(-(r+k_surf).*t1)); %%surface conc.


%% Equations for a period of no resuspension to get indoor air concentration C(t)and surface concentration L(t)vs time, t:

t2=0:0.001:2;                   %Time period for no resuspension, hr
C2=C1(end).*exp(-B.*t2);        %no resuspension
L2=L1(end)+(k.*V.*C2.*t2./A);   %no resuspension

L=horzcat(L1,L2);               %combining resuspension and no resuspension data for surface conc.
C=horzcat(C1,C2);               %combining resuspension and no resuspension data for indoor air conc.

t2_real=t1(end)+t2;             %fixing time period of the no resuspension (that follows the resuspension period) to start from the end of resuspension period and not 0.
t=horzcat(t1,t2_real);          %combining resuspension and no resuspension times into a single matrix.

%% figures

%C1, L1 and t1 are resuspension period; C2, L2 and t2 are no resuspension
%period; C, L and t are both combined.

figure()                       %only resuspension period indoor air concentrations vs time
plot(t1,C1,'LineWidth',1.2);
xlabel('Time (hr)')
ylabel('Air conc. (ug/m3)')

figure()                       %only resuspension period surface concentrations vs time
plot(t1,L1,'LineWidth',1.2);
xlabel('Time (hr)')
ylabel('Surface conc. (ug/m2)')