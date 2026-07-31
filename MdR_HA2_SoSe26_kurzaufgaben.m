%% Aufgabe 1

F_1 = tf([4, 8], [1, -3]);

figure(1);
nyquist(F_1);
grid on;

F_2 = tf([2, 4, 2], [1, 4, 0]);

figure(2);
nyquist(F_2);
grid on;

F_3 = tf([10, -20], [1, 12, 35, 24]);

figure(3);
nyquist(F_3);
grid on;

%% Aufgabe 4

%F_1=tf([0, 1.2],[1, 0.5]);
%bode(F_1);
%grid on;

%aus dem Skript:
s = tf('s');

TF_S = 1.2 / (s + 0.5);

[Gm, Pm, Wcg, Wcp] = margin(TF_S);

fprintf('Gain margin: %.3f\n', Gm);
fprintf('Phase margin: %.3f degrees\n', Pm);
fprintf('Phase-crossover frequency: %.3f rad/s\n', Wcg);
fprintf('Gain-crossover frequency: %.3f rad/s\n', Wcp);

figure(4);
margin(TF_S)

ax = findall(gcf, 'Type', 'axes');

for k = 1:length(ax)
    ax(k).XGrid = 'on';
    ax(k).YGrid = 'on';
    ax(k).XMinorGrid = 'on';
    ax(k).YMinorGrid = 'off';
    if contains(string(ax(k).YLabel.String), "Magnitude")
    yline(ax(k), 0, 'k-', 'LineWidth', 0.1, "LineStyle","-.");
    end
    ax(k).GridLineStyle = '-';
    ax(k).MinorGridLineStyle = '-';
    ax(k).GridLineWidth = 0.05;
    ax(k).MinorGridLineWidth = 0.05;
end

s = tf('s');

TF_0 = 59.57 / (s*(s + 0.5));

[Gm, Pm, Wcg, Wcp] = margin(TF_0);

fprintf('Gain margin: %.3f\n', Gm);
fprintf('Phase margin: %.3f degrees\n', Pm);
fprintf('Phase-crossover frequency: %.3f rad/s\n', Wcg);
fprintf('Gain-crossover frequency: %.3f rad/s\n', Wcp);

figure(5);
margin(TF_0)

ax = findall(gcf, 'Type', 'axes');

for k = 1:length(ax)
    ax(k).XGrid = 'on';
    ax(k).YGrid = 'on';
    ax(k).XMinorGrid = 'on';
    ax(k).YMinorGrid = 'off';
    if contains(string(ax(k).YLabel.String), "Magnitude")
    yline(ax(k), 0, 'k-', 'LineWidth', 0.1, "LineStyle","-.");
    end
    ax(k).GridLineStyle = '-';
    ax(k).MinorGridLineStyle = '-';
    ax(k).GridLineWidth = 0.05;
    ax(k).MinorGridLineWidth = 0.05;
end

s = tf('s');

TF_G = (59.57 * (s+2.107))/ (s*(s+11.86)*(s + 0.5));

[Gm, Pm, Wcg, Wcp] = margin(TF_G);

fprintf('Gain margin: %.3f\n', Gm);
fprintf('Phase margin: %.3f degrees\n', Pm);
fprintf('Phase-crossover frequency: %.3f rad/s\n', Wcg);
fprintf('Gain-crossover frequency: %.3f rad/s\n', Wcp);

figure(6);
margin(TF_G)

ax = findall(gcf, 'Type', 'axes');

for k = 1:length(ax)
    ax(k).XGrid = 'on';
    ax(k).YGrid = 'on';
    ax(k).XMinorGrid = 'on';
    ax(k).YMinorGrid = 'off';
    if contains(string(ax(k).YLabel.String), "Magnitude")
    yline(ax(k), 0, 'k-', 'LineWidth', 0.1, "LineStyle","-.");
    end
    ax(k).GridLineStyle = '-';
    ax(k).MinorGridLineStyle = '-';
    ax(k).GridLineWidth = 0.05;
    ax(k).MinorGridLineWidth = 0.05;
end

%% Augabe 5

s = tf('s');

Strecke = 80 / (s*(0.2*s + 1));
Filter = 1/(0.05*s+1);
Fs_Ff = Strecke*Filter;

figure(7);
bode(Strecke,Filter,Fs_Ff);
grid on;
legend("Strecke","Filter","Fs_Ff");

drawnow;
ax = findall(gcf, 'Type', 'axes');

for k = 1:length(ax)
    ax(k).XGrid = 'on';
    ax(k).YGrid = 'on';
    ax(k).XMinorGrid = 'on';
    ax(k).YMinorGrid = 'off';
    ax(k).GridLineStyle = '-';
    ax(k).MinorGridLineStyle = '-';
    ax(k).GridLineWidth = 0.05;
    ax(k).MinorGridLineWidth = 0.05;
end


[Gm, Pm, Wcg, Wcp] = margin(Fs_Ff);

fprintf('Gain margin: %.3f\n', Gm);
fprintf('Phase margin: %.3f degrees\n', Pm);
fprintf('Phase-crossover frequency: %.3f rad/s\n', Wcg);
fprintf('Gain-crossover frequency: %.3f rad/s\n', Wcp);

figure(8);
margin(Fs_Ff)

ax = findall(gcf, 'Type', 'axes');

for k = 1:length(ax)
    ax(k).XGrid = 'on';
    ax(k).YGrid = 'on';
    ax(k).XMinorGrid = 'on';
    ax(k).YMinorGrid = 'off';
    if contains(string(ax(k).YLabel.String), "Magnitude")
    yline(ax(k), 0, 'k-', 'LineWidth', 0.1, "LineStyle","-.");
    end
    ax(k).GridLineStyle = '-';
    ax(k).MinorGridLineStyle = '-';
    ax(k).GridLineWidth = 0.05;
    ax(k).MinorGridLineWidth = 0.05;
end


s = tf('s');

TF_S = 2 / ((1+0.1*s)*(1+0.5*s)*(1+1.2*s));
figure(9);
bode(TF_S);
grid on;
t = 0:0.1:12;
u = ones (length(t),1) ;
% Simulation
figure(10);
lsim (TF_S,u,t);
grid on;

s = tf('s');

TF_S = 2 / ((1+0.1*s)*s);
figure(11);
margin(TF_S);
grid on;