# Deriving-cell-load-from-RSRQ-measurements
Source code and measurement data to reproduce the results presented in this paper:<br>
V. Raida, M. Lerch, P. Svoboda and M. Rupp, "Deriving Cell Load from RSRQ Measurements," *2018 Network Traffic Measurement and Analysis Conference (TMA)*, Vienna, 2018.
<br><br>
Published version of the article: https://ieeexplore.ieee.org/document/8506494
<br><br>
Accepted version of the article available as open access: https://publik.tuwien.ac.at/files/publik_271503.pdf<br>
(compliant with IEEE policy https://www.ieee.org/content/dam/ieee-org/ieee/web/org/pubs/author_version_faq.pdf)
<br><br>
**Brief summary:** In LTE, the physical layer indicator called RSRQ (reference signal received quality) can be used to estimate the cell load (percentage of resource elements that are scheduled to active users). However, the measuring UE (user equipment) should not produce any DL (downlink) traffic while measuring RSRQ. Otherwise, RSRQ is influenced by the DL traffic of the measuring UE.

## Source Code Details
**calc_RSRQ.m:** Function that calculates RSRQ according to Eq. (8).<br>
**rsrp_vs_rsrq_simulation.m:** Simulation evaluates Eq. (8) for different parameter choices. Can reproduce results in Fig. 2.<br>
**noise_floor.m:** NEMO lab measurements of the noise floor. Produces results in Fig. 3.<br>
**rsrp_vs_rsrq_measurement__intf_free.m:** NEMO lab measurements: Only the measuring UE was active. Fig. 4 (a).<br>
**rsrp_vs_rsrq_measurement__6interferers.m:** NEMO lab measurements: Six other UEs were generating DL traffic. Fig. 4 (b).<br>
**corr_positive.m:** Outdoor measurement campaign. RSRQ was measured properly (zero DL throughput of the measuring UE), therefore, it reflects cell load caused by other active users and it positively correlates with the achievable DL throughput of the measuring UE. Fig. 7 and Fig. 9 (a).<br>
**corr_negative.m:** NEMO lab measurements. RSRQ was measured while the measuring UE was generating DL traffic. RSRQ thus measures our own DL traffic. Fig. 8 and Fig. 9 (b).
