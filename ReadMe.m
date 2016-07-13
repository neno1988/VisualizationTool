% This tool offers a nice way to represent data in the field of rain/wastewwater
% 
% data structure in catchmentInfo
% 
% for each RUEB: x, y position
%                 fill level data
%                 flow data
%                 quality data
%                 ...
% name of below structure
% position from ARA: 1.2.1.1.1
% .mat files around: time (seconds) and data as TS with standard names:
% (RUEB_NAME).timeSec
%            .waterLevel
%            .flow
%            .COD
%            ...
%                  

% Additional RUEB information which is not time-based, can be stored in a
% file named CatchmentInformation.mat (matlab struct)
% the variables used from this file are:
% overflowEdge
% H2V (height to volume)
% volume
% WWTP: maxCapacity
% if available, the tool uses
% measuredOverflowEdge
% gepOverflowEdge
%
% this list is increasing...