% SCRIPT: setearth.m
% USE: Same as setearthmoon.m (Earth-Moon-Barycenter Model)
%      Set paramters for Sun-Earth/Moon RTBP model.
%      Return in BODY in globals.
% OUT: global mu AU BODY EARTH
%      mu = sun-(earth-moon barycenter) mass param.
%      AU = EARTH.sm [km]
% VER: 9/1/2012
% Solar System Model from Quick 4/11/06

global mu AU BODY EARTH MODEL PRIM SEC RUNIT

setearth0 % setup all the constants.
disp('Set SUN-EARTH/MOON System RTBP Model in global, BODY=EARTH, mu=EARTH.mubary');

mu           = EARTH.mubary;
BODY         = EARTH;
MODEL	= 'EarthMoonBarycenterModel';

PRIM = SUN;
SEC = EARTH
AU = EARTH.sm;
RUNIT = 384400; %[km]
