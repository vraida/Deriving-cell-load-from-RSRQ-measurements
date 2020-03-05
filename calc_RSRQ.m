% -------------------------------------------------------------------------
% Function to calculate RSRQ according to Eq. (8).
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

function RSRQ_dB = calc_RSRQ(RSRP_dBm, N_prb, eta, Pn) 
    % Example inputs
    %----------------
    %
    % RSRP_dBm = -200:-40;
    %
    % One receive antenna:
    % x = 1/6;  % Empty: only RS transmitted (one antenna)
    % x = 1;    % Full load (one antenna)
    %
    % Two receive antennas:
    %   x = 1/3;  % Empty: only RS transmitted
    %   x = 5/3;  % Full load
    %
    % N_prb = 100;  % for BW of 20 MHz

    
    % Linear scale
    RSRP_mW = 10.^(RSRP_dBm/10);
    Pn_mW = 10^(Pn/10);
    
    % Denominator in (8)
    RSSI_mW = eta * 12 * N_prb * RSRP_mW + Pn_mW;  % 12 RE per RB in f-dimension
    
    % Eq. (8) & convert back to logarithmic scale
    RSRQ_dB = 10*log10( N_prb * RSRP_mW ./ RSSI_mW );  % RSRQ in dB

end