function [  ] = GenerateData(  )
%GENERATEDATA Generate data to use in the visualization tool
% The data has to be added somehow in this function. Still wondering what
% is the best way to do so.

%% Example structure
timeSec = 1:10; 
waterLevel = 1:10;
flow = 1:10;
inflow = 1:10;
rain = 1:10;
CSB = 1:10;

%% Structure generation
CreateStructure('RUEB12421', timeSec);
AddMeasurement('RUEB12421', 'waterLevel', waterLevel);
AddMeasurement('RUEB12421', 'outflow', flow);
AddMeasurement('RUEB12421', 'inflow', inflow);
AddMeasurement('RUEB12421', 'rain', rain);
AddMeasurement('RUEB12421', 'CSB', CSB);

end

function [] = CreateStructure(name, timeSec) %#ok<INUSD> used in eval command

command = [name '.timeSec = timeSec;'];
eval(command);
save(name, name);

end

function[] = AddMeasurement(structure, dataTyp, data)
fullName = [structure '.mat'];

%% Checks
% Structure exists?
if(exist(fullName,'file')==2)
load(fullName);
eval(['s = ' structure ';']);
else
    error('Must create structure before adding measurements')
end

% timeSec and data have the same size?
if(~isequal(size(data), size(s.timeSec))) %#ok<NODEF> defined by eval command above
    data = data';
    if(~isequal(size(data), size(s.timeSec)))
        error('dimension mismatch')
    end
end

%% add data
dataTypLC = lower(dataTyp);

switch(dataTypLC)
    case 'waterlevel'
        s.waterLevel = data;
    case 'outflow'
        s.outflow = data;
    case 'inflow'
        s.inflow = data;        
    case 'overflow'
        s.overflow = data;
    case 'COD'
        s.COD = data;
    case 'rain'
        s.rain = data;
    otherwise
        warning(['unknown data - ' dataTyp 'you will not be able to display this in the visualization tool']);
        s.(dataTyp) = data;
        
end

%% Save to file
eval([structure ' = s;'] );
save(structure, structure);
end



