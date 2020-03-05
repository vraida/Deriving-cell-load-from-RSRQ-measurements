% -------------------------------------------------------------------------
% NEMO measurements conducted in a lab.
% DL traffic was generated by iPerf3.
% Only the measuring UE was active (no sharing of resources with other UEs).
% We can observe the difference between RSRQ measured properly (at intervals
% with zero throughput of the measuring UE) and between RSRQ measured all the time.
% Code produces results in Fig. 4 (a).
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

clc; close all;

%%%%%%
%%% SIMULATION
%%%%%%
N  = 100;                   % 20 MHz channels => 100 resource blocks (RBs)
Pn = -97;                   % Noise power in dBm
x_min = 1/3;  x_max = 5/3;  % Two antennas
RSRP_dBm = -150:-40;

x_from_L = @(L) L*x_max + (1-L)*x_min;

figure(1); hold on; grid on; xlabel('RSRQ / dB'); ylabel('RSRP / dBm'); xlim([-25, -5]); ylim([-140, -40]);
    for L = 0:0.1:1
        x = x_from_L(L);
        plot(calc_RSRQ(RSRP_dBm, N, x, Pn), RSRP_dBm, 'DisplayName', sprintf('L = %.1f', L));
    end
    
    
%%%%%%
%%% MEASUREMENTS
%%%%%%
fprintf('Loading data...\n');
load('data/lab_nemo-parsed_0-intf_2018-03-30.mat');  % DL, S; 6 interferers

t_edges = S.t(1):2:S.t(end);   % BIN ALL SIGNALS => same time grid
fprintf('Binning signals...\n');
binned.RSRP1 = f.bin_signal(S.t, S.RSRP1, t_edges);             fprintf('\tRSRP1 binned\n');
binned.RSRP2 = f.bin_signal(S.t, S.RSRP2, t_edges);             fprintf('\tRSRP2 binned\n');
binned.RSRQ1 = f.bin_signal(S.t, S.RSRQ1, t_edges);             fprintf('\tRSRQ1 binned\n');
binned.RSRQ2 = f.bin_signal(S.t, S.RSRQ2, t_edges);             fprintf('\tRSRQ2 binned\n');
binned.RSSI1 = f.bin_signal(S.t, S.RSSI1, t_edges);             fprintf('\tRSSI1 binned\n');
binned.RSSI2 = f.bin_signal(S.t, S.RSSI2, t_edges);             fprintf('\tRSSI2 binned\n');
binned.phrate1 = f.bin_signal(DL.t, DL.phrate1, t_edges);       fprintf('\tphrate1 binned\n');
binned.phrate2 = f.bin_signal(DL.t, DL.phrate2, t_edges);       fprintf('\tphrate2 binned\n');
binned.R = (binned.phrate1 + binned.phrate2)/10^6;

figure(1);
    plot(S.RSRQ1, S.RSRP1, 'o', 'DisplayName', 'Measurements (all)');
    plot(binned.RSRQ1(binned.R==0), binned.RSRP1(binned.R==0), 's', 'DisplayName', 'Measurements (R = 0 only)');
    legend('Location', 'northwest');
    title('Measurement vs simulation: 6 interfering UEs active');


% Plot all raw and binned signals over time
figure; hold on; grid on;

    sp(1) = subplot(4,2,1); hold on; grid on; ylabel('RSRP / dBm');
        title('Raw signals');
        plot(S.t, S.RSRP1, '.', 'DisplayName', 'Antenna 1');
        plot(S.t, S.RSRP2, '.', 'DisplayName', 'Antenna 2'); legend('Location', 'northeast');
    sp(2) = subplot(4,2,3); hold on; grid on; ylabel('RSRQ / dB');
        plot(S.t, S.RSRQ1, '.', 'DisplayName', 'Antenna 1');
        plot(S.t, S.RSRQ2, '.', 'DisplayName', 'Antenna 2');
    sp(3) = subplot(4,2,5); hold on; grid on; ylabel('RSSI / dBm');
        plot(S.t, S.RSSI1, '.', 'DisplayName', 'Antenna 1');
        plot(S.t, S.RSSI2, '.', 'DisplayName', 'Antenna 2'); legend('Location', 'northeast');
    sp(4) = subplot(4,2,7); hold on; grid on; ylabel('physical R / (Mbit/s)');
        plot(DL.t, DL.phrate1/10^6, '.', 'DisplayName', 'Antenna 1');
        plot(DL.t, DL.phrate2/10^6, '.', 'DisplayName', 'Antenna 2');
        plot(DL.t, (DL.phrate1 + DL.phrate2)/10^6, '.', 'DisplayName', 'Sum'); legend('Location', 'northeast');
        
    sp(5) = subplot(4,2,2); hold on; grid on; ylabel('RSRP / dBm');
        title('Binned signals');
        plot(t_edges(1:end-1), binned.RSRP1, '.', 'DisplayName', 'Antenna 1');
        plot(t_edges(1:end-1), binned.RSRP2, '.', 'DisplayName', 'Antenna 2'); legend('Location', 'northeast');
    sp(6) = subplot(4,2,4); hold on; grid on; ylabel('RSRQ / dB');
        plot(t_edges(1:end-1), binned.RSRQ1, '.', 'DisplayName', 'Antenna 1');
        plot(t_edges(1:end-1), binned.RSRQ2, '.', 'DisplayName', 'Antenna 2'); legend('Location', 'northeast');
    sp(7) = subplot(4,2,6); hold on; grid on; ylabel('RSSI / dBm');
        plot(t_edges(1:end-1), binned.RSSI1, '.', 'DisplayName', 'Antenna 1');
        plot(t_edges(1:end-1), binned.RSSI2, '.', 'DisplayName', 'Antenna 2');
    sp(8) = subplot(4,2,8); hold on; grid on; ylabel('physical R / (Mbit/s)'); legend('Location', 'northeast');
        plot(t_edges(1:end-1), binned.phrate1/10^6, '.', 'DisplayName', 'Antenna 1');
        plot(t_edges(1:end-1), binned.phrate2/10^6, '.', 'DisplayName', 'Antenna 2');
        plot(t_edges(1:end-1), (binned.phrate1 + binned.phrate2)/10^6, '.', 'DisplayName', 'Sum'); legend('Location', 'northeast');
        
    linkaxes(sp, 'x');

