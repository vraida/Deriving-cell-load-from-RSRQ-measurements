% -------------------------------------------------------------------------
% RSRQ simulations evaluating Eq. (8) for different parameter choices.
% Code can be used to produce results in Fig. 2.
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

antennas = 2;   % Valid options: 1 or 2

N  = 100;       % 20 MHz channels => 100 resource blocks (RBs)
Pn = -96;       % Noise power (noise floor) in dBm

RSRP_dBm = -150:-40;

switch antennas
    case 1;  eta_min = 1/6;  eta_max = 1;
    case 2;  eta_min = 1/3;  eta_max = 5/3;
end

eta_from_L = @(L) L*eta_max + (1-L)*eta_min;  % Eq. (13)

% RSRP vs RSRQ (both logarithmic), different cell loads
figure; hold on; grid on; xlabel('RSRQ / dB'); ylabel('RSRP / dBm'); xlim([-25, -5]); ylim([-140, -40]);
    [X,Y] = meshgrid(-25:0.25:-5,-140:-40);
    plot(X(:), Y(:), 'k.', 'MarkerEdgeColor', 0.6.*[1 1 1], 'DisplayName', '0.25dB RSRP steps');    
    for L = 0:0.1:1
        eta = eta_from_L(L);
        plot(calc_RSRQ(RSRP_dBm, N, eta, Pn), RSRP_dBm, 'DisplayName', sprintf('L = %.1f', L), 'LineWidth', 2);
    end
    legend('Location', 'northwest');
    title(sprintf('RSRP (logarithmic) vs RSRQ (logarithmic): %d antennas, P_n = %.2fdBm, Different cell loads L', antennas, Pn));

% RSRP vs RSRQ (both logarithmic), different cell loads: Special case of
% zero noise => no saturation
rsrq_vals = nan(1, length(0:0.1:1)); ii = 1;
figure; hold on; grid on; xlabel('RSRQ / dB'); ylabel('RSRP / dBm');  ylim([-140, -40]);
    for L = 0:0.1:1
        eta = eta_from_L(L);
        RSRQs = calc_RSRQ(RSRP_dBm, N, eta, -inf);  % Pn = 0 W  =>  Pn = -inf dBm
        rsrq_vals(ii) = RSRQs(1);
        plot(RSRQs, RSRP_dBm, 'DisplayName', sprintf('L = %.1f', L));
        ii = ii + 1;
    end
    legend('Location', 'northwest');
    title(sprintf('RSRP (logarithmic) vs RSRQ (logarithmic): %d antennas, P_n = 0W, Different cell loads L', antennas));
    
% Cell load - RSRQ linear
figure; hold on; grid on; xlabel('RSRQ'); ylabel('RSRP / dBm');  ylim([-140, -40]);
    for L = 0:0.1:1
        eta = eta_from_L(L);
        plot(10.^(calc_RSRQ(RSRP_dBm, N, eta, Pn)./10), RSRP_dBm, 'DisplayName', sprintf('L = %.1f', L));
    end
    legend('Location', 'northwest');
    title(sprintf('RSRP (logarithmic) vs RSRQ (linear): %d antennas, P_n = %.2fdBm, Different cell loads L', antennas, Pn));


% Different noise levels    
figure; hold on; grid on; xlabel('RSRQ / dB'); ylabel('RSRP / dBm'); xlim([-35, -2]); ylim([-140, -40]);
    plot(calc_RSRQ(RSRP_dBm, N, 1/3, Pn), RSRP_dBm, 'b-', 'Linewidth', 1.5);
    h1 = plot(calc_RSRQ(RSRP_dBm, N, 5/3, Pn), RSRP_dBm, 'b-', 'Linewidth', 1.5);
    lbl1 = sprintf('2 antennas, Pn = %.2f dBm', Pn);
    
    Pn2 = -106;  % Less noise
    plot(calc_RSRQ(RSRP_dBm, N, 1/3, Pn2), RSRP_dBm, '--', 'Color', [0.1 0.1 0.1], 'Linewidth', 1);
    h2 = plot(calc_RSRQ(RSRP_dBm, N, 5/3, Pn2), RSRP_dBm, '--', 'Color', [0.1 0.1 0.1], 'Linewidth', 1);
    lbl2 = sprintf('2 antennas, Pn = %.2f dBm', Pn2);
    
    Pn3 = -86;   % More noise
    plot(calc_RSRQ(RSRP_dBm, N, 1/3, Pn3), RSRP_dBm, ':', 'Color', [0.1 0.1 0.1], 'Linewidth', 1);
    h3 = plot(calc_RSRQ(RSRP_dBm, N, 5/3, Pn3), RSRP_dBm, ':', 'Color', [0.1 0.1 0.1], 'Linewidth', 1);
    lbl3 = sprintf('2 antennas, Pn = %.2f dBm', Pn3);
    
    plot(calc_RSRQ(RSRP_dBm, N, 1/6, Pn), RSRP_dBm, 'r:', 'Linewidth', 1.5);
    h4 = plot(calc_RSRQ(RSRP_dBm, N, 1/1, Pn), RSRP_dBm, 'r:', 'Linewidth', 1.5);
    lbl4 = sprintf('1 antenna, Pn = %.2f dBm', Pn);
    
    legend([h1,h2,h3,h4], {lbl1,lbl2,lbl3,lbl4}, 'Location', 'northwest');
    title('RSRP vs RSRQ limits');


