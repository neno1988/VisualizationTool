% This tool offers a nice way to represent data in the field of rain/wastewwater
% 
% For each structure, a .mat file is needed. The field names in the.mat
% files are required to be the following:
% (RUEB_NAME).timeSec           Time in seconds
% (RUEB_NAME).waterLevel        
% (RUEB_NAME).flow
% (RUEB_NAME).COD
%            ...
% Structure Files need to be moved to teh /Structures folder.

% Two examples of data generation can befound in the
% /NidauDataGeneration/2014, /2015
% folders

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
% The data in CatchmentInfo is not required to use the tool, but you might
% not be able to use all plot types.
% 
% The file CatchmentInfo.mat has to e moved to the /Data Folder.

% An example of the catchmentInfo File generation can be found in the
% /NidauDataGeneration Folder

% Additional Information can be added to the /Data folder: 
% 1) inflowWWTP with Fields data and timeSec and rainData
% 2) rainData with Fields rain and timeSec and rainData
% Two example files for Nidau can be found in the /NidauData Folder

% The tool as it is now, already has the data of Nidau catchment in it.