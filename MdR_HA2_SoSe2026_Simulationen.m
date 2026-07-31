%% Projektteilaufgabe e
clear;
clc;
close all;
model = "radioteleskop";
load_system(model);
reglerBlock = model + "/Regler";
set_param(model,"SolverType", "Fixed-step","Solver", "ode4","FixedStep", "0.1","FastRestart", "off");

%% Parameter der Regelstrecke 
% wie in teilaufgaben berechnet
Js = 2.16e6;
kR = 0.1;
w_dot_0 = deg2rad(0.25) / 60;   % rad/s Führungsgroesse
omega_max = 20;                 % deg/min Grenzwert

%% Regler aus Bode-Verfahren
numR_Bode = (17.28 / 25.27)*conv([251.26 1], [251.26 1]);
denR_Bode = conv([1 0],conv([10 1], [10 1]));

%% Regler aus Polvorgabe
numR_Pol = [2.022e-5 1.609e-7 3.200e-10];
denR_Pol = conv([1 0], [4.630e-8 9.310e-9 4.683e-10]);

%% Beide Regler
regler(1).name = 'Bode-Verfahren';
regler(1).num  = numR_Bode;
regler(1).den  = denR_Bode;
regler(2).name = 'Polvorgabe';
regler(2).num  = numR_Pol;
regler(2).den  = denR_Pol;

%%  e.1 
phi_0 = 0;
omega_0 = 0;
t_d = 200;
M_W = 0;
t_end = 2500;
set_param(model, "StopTime", num2str(t_end));

for i = 1:2
    set_param(reglerBlock, "Numerator", mat2str(regler(i).num, 17));
    set_param(reglerBlock, "Denominator", mat2str(regler(i).den, 17));
    out = sim(model);
    daten = auslesen(out);
    daten.name = regler(i).name;
    ergebnis_e1(i) = daten;
end

%% Plot für e.1

figure(1);
subplot(3,1,1);
plot(ergebnis_e1(1).t, ergebnis_e1(1).w_deg, '--');
hold on;
plot(ergebnis_e1(1).t, ergebnis_e1(1).phi_deg);
plot(ergebnis_e1(2).t, ergebnis_e1(2).phi_deg);
grid on;
ylabel('\Phi in °');
legend('w', '\Phi: Bode-Verfahren', '\Phi: Polvorgabe', 'Location', 'best');

subplot(3,1,2);
plot(ergebnis_e1(1).t, ergebnis_e1(1).u);
hold on;
plot(ergebnis_e1(2).t, ergebnis_e1(2).u);
grid on;
ylabel('u in Nm');
legend('Bode-Verfahren', 'Polvorgabe','Location', 'best');

subplot(3,1,3);
plot(ergebnis_e1(1).t, ergebnis_e1(1).omega_deg_min);
hold on;
plot(ergebnis_e1(2).t, ergebnis_e1(2).omega_deg_min);
yline(omega_max, '--', 'HandleVisibility', 'off');
yline(-omega_max, '--', 'HandleVisibility', 'off');
grid on;
ylabel('\omega in °/min');
xlabel('t in s');
legend('Bode-Verfahren', 'Polvorgabe', 'Location', 'best');

%% Auswertung für e.1

fprintf('\nTEILAUFGABE e.1\n');

for i = 1:2
    idx_stationaer = ergebnis_e1(i).t >= t_end - 100;
    omega_spitze = max(abs(ergebnis_e1(i).omega_deg_min));
    fehler_stationaer = max(abs(ergebnis_e1(i).e_deg(idx_stationaer)));
    fprintf('\n%s:\n', regler(i).name);
    fprintf('Maximale Drehrate: %.4f °/min\n',omega_spitze);
    fprintf(['Maximaler Regelfehler während der ' 'letzten 100 s: %.6e °\n'], fehler_stationaer);
end

%%  e.2 Anfangsabweichung von 15 Grad
% Da w(0) = 0 gilt, ergibt phi_0 = -15 Grad
% einen anfänglichen Regelfehler von +15 Grad.

phi_0 = deg2rad(-15);
omega_0 = 0;
t_d = 200;
M_W = 0;
t_end = 2500;
set_param(model, "StopTime", num2str(t_end));

for i = 1:2
    set_param(reglerBlock, "Numerator", mat2str(regler(i).num, 17));
    set_param(reglerBlock, "Denominator", mat2str(regler(i).den, 17));
    out = sim(model);
    daten = auslesen(out);
    daten.name = regler(i).name;
    ergebnis_e2(i) = daten;
end

%% Plot für e.2

figure(2);
subplot(2,1,1);
plot(ergebnis_e2(1).t, ergebnis_e2(1).e_deg);
hold on;
plot(ergebnis_e2(2).t, ergebnis_e2(2).e_deg);
yline(0.1, '--', 'HandleVisibility', 'off');
yline(-0.1, '--', 'HandleVisibility', 'off');
grid on;
ylabel('e in °');
legend('Bode-Verfahren', 'Polvorgabe','Location', 'best');

subplot(2,1,2);
plot(ergebnis_e2(1).t, ergebnis_e2(1).omega_deg_min);
hold on;
plot(ergebnis_e2(2).t, ergebnis_e2(2).omega_deg_min);
yline(omega_max, '--', 'HandleVisibility', 'off');
yline(-omega_max, '--', 'HandleVisibility', 'off');
grid on;
ylabel('\omega in °/min');
xlabel('t in s');
legend('Bode-Verfahren', 'Polvorgabe','Location', 'best');

%% Auswertung für e.2

fprintf('\nTEILAUFGABE e.2\n');
for i = 1:2
    omega_spitze = max(abs(ergebnis_e2(i).omega_deg_min));
    t_einschwingen = einschwingzeit(ergebnis_e2(i).t,ergebnis_e2(i).e_deg,  0.1);
    fprintf('\n%s:\n', regler(i).name);
    fprintf('Maximale Drehrate: %.4f °/min\n', omega_spitze);
    fprintf('Zeit bis |e| dauerhaft kleiner als ''0.1° ist: %.1f s\n', t_einschwingen);
end

%%  e.3 Konstante Windlast am Streckeneingang

phi_0 = 0;
omega_0 = 0;
t_d = 200;
M_W = 500;
t_end = 6000;
set_param(model, "StopTime", num2str(t_end));
for i = 1:2
    set_param(reglerBlock, "Numerator", mat2str(regler(i).num, 17));
    set_param(reglerBlock, "Denominator", mat2str(regler(i).den, 17));

    out = sim(model);

    daten = auslesen(out);
    daten.name = regler(i).name;
    ergebnis_e3(i) = daten;
end

%% Plot für e.3

figure(3);

subplot(2,1,1);
plot(ergebnis_e3(1).t, ergebnis_e3(1).w_deg, '--');
hold on;
plot(ergebnis_e3(1).t, ergebnis_e3(1).phi_deg);
plot(ergebnis_e3(2).t, ergebnis_e3(2).phi_deg);
grid on;
ylabel('\Phi in °');
legend('w', '\Phi: Bode-Verfahren','\Phi: Polvorgabe', 'Location', 'best');

subplot(2,1,2);
plot(ergebnis_e3(1).t, ergebnis_e3(1).e_deg);
hold on;
plot(ergebnis_e3(2).t, ergebnis_e3(2).e_deg);
grid on;
ylabel('e in °');
xlabel('t in s');
legend('Bode-Verfahren', 'Polvorgabe','Location', 'best');

%% Auswertung für e.3

fprintf('\nTEILAUFGABE e.3\n');

for i=1:2
    idx_stationaer=ergebnis_e3(i).t >= t_end - 200;
    fehler_stationaer=max(abs(ergebnis_e3(i).e_deg(idx_stationaer)));
    maximaler_fehler=max(abs(ergebnis_e3(i).e_deg));
    u_end = ergebnis_e3(i).u(end);
    fprintf('\n%s:\n', regler(i).name);
    fprintf('Maximaler Regelfehler: %.4f °\n',maximaler_fehler);
    fprintf(['Maximaler Regelfehler während der ' 'letzten 200 s: %.6e °\n'], fehler_stationaer);
    fprintf('Stellsignal am Simulationsende: %.4f Nm\n', u_end);
end

%% Lokale Hilfsfunktionen
function daten = auslesen(out)
    daten.t = out.phi.Time;
    daten.phi_deg = rad2deg(squeeze(out.phi.Data));
    daten.w_deg = rad2deg(squeeze(out.w.Data));
    daten.e_deg = rad2deg(squeeze(out.e.Data));
    daten.omega_deg_min = rad2deg(squeeze(out.omega.Data)) * 60;
    daten.u = squeeze(out.u.Data);
end

function t_einschwingen = einschwingzeit(t, e_deg, grenze)
    idx_ausserhalb = find(abs(e_deg) >= grenze,1,'last');
    if isempty(idx_ausserhalb)
        t_einschwingen = 0;
    elseif idx_ausserhalb < length(t)
        t_einschwingen = t(idx_ausserhalb + 1);
    else
        t_einschwingen = NaN;
    end
end