% -------------------------------------------------------------------------
% NEMO measurements conducted in a lab.
% We measured noise floor on the antenna port 1.
% (On the antenna port 2, the signal power was kept fixed to not loosing the connection too early.)
% Code produces results in Fig. 3.
%
% For more details, see the paper:
% V. Raida, M. Lerch, P. Svoboda and M. Rupp, "Deriving Cell Load from RSRQ Measurements,"
% 2018 Network Traffic Measurement and Analysis Conference (TMA), Vienna, 2018.
%
% Accepted version (open access): https://publik.tuwien.ac.at/files/publik_271503.pdf
% Published version: https://ieeexplore.ieee.org/document/8506494
%
% (C) 2018 Vaclav Raida, TU Wien
% email: vaclav.raida@tuwien.ac.at
% -------------------------------------------------------------------------

clear; clc; close all;

load('data/lab_nemo-parsed_noise-floor_2018-04-18.mat');  % S = signal, DL = throughput

% Convert unix timestamps to relative time
t_first = min([S.t(1), DL.t(1)]);
S.t  = S.t - t_first;
DL.t = DL.t - t_first;

% Plot raw signals
figure; hold on; grid on;
    sp(1) = subplot(4,1,1); hold on; grid on; ylabel('RSRP / dBm');
        plot(S.t, S.RSRP1, '.', 'DisplayName', 'Antenna 1');
        plot(S.t, S.RSRP2, '.', 'DisplayName', 'Antenna 2');
        legend('Location', 'northwest');
    sp(2) = subplot(4,1,2); hold on; grid on; ylabel('RSRQ / dB');
        plot(S.t, S.RSRQ1, '.', 'DisplayName', 'Antenna 1');
        plot(S.t, S.RSRQ2, '.', 'DisplayName', 'Antenna 2');
        legend('Location', 'northwest');
    sp(3) = subplot(4,1,3); hold on; grid on; ylabel('RSSI / dBm');
        plot(S.t, S.RSSI1, '.', 'DisplayName', 'Antenna 1');
        plot(S.t, S.RSSI2, '.', 'DisplayName', 'Antenna 2');
        legend('Location', 'northwest');
    sp(4) = subplot(4,1,4); hold on; grid on; ylabel('physical R / (Mbit/s)');
        plot(DL.t, DL.phrate1/10^6, '.', 'DisplayName', 'Antenna 1');
        plot(DL.t, DL.phrate2/10^6, '.', 'DisplayName', 'Antenna 2');
        plot(DL.t, (DL.phrate1 + DL.phrate2)/10^6, '.', 'DisplayName', 'Sum');
        xlabel('t / s'); legend('Location', 'northwest');
    linkaxes(sp, 'x');

    
% Inspect noise floor of a single port
t_lim = [70, 380];  % Cut off constant phase at the beginning and spurious noisy samples at the end
mask = (S.t >= t_lim(1)) & (S.t <= t_lim(2));
t = S.t(mask);
rsrp = S.RSRP1(mask);
rsrq = S.RSRQ1(mask);
rssi = S.RSSI1(mask);

% RSSI vs RSRP
figure; hold on; grid on;
    scatter(rsrp, rssi); xlabel('RSRP / dBm'); ylabel('RSSI / dBm');

% Single port, filtered
figure
    subplot(3,1,1); hold on; grid on;
        plot(t-t(1), rsrp, '.'); ylabel('RSRP / dBm');
    subplot(3,1,2); hold on; grid on;
        plot(t-t(1), rsrq, '.'); ylabel('RSRQ / dB');
    subplot(3,1,3); hold on; grid on;
        plot(t-t(1), rssi, '.'); ylabel('RSSI / dBm');
        xlabel('t / s');

