function[dataRUEB, newtime] = GetDataRueb(handles, dataName, varargin)
if(nargin>3)
    error('too many inputs')
elseif(nargin==3)
    from = varargin;
else
    from = 'data';
end
tmpRueb = fields(handles.data);
N = numel(fields(handles.data));
%% Get data from catchment info?
if(strcmp(from, 'catchmentInfo'))
%     dataRUEB =
%     zeros(max(size(handles.catchmentInfo.(tmpRueb{1}).(dataName))), N); %
%     Should initialize, but it is not clear how
    for i=1:N
        if(isfield(handles.catchmentInfo.(tmpRueb{i}), dataName))
        nInterPoints = numel(handles.catchmentInfo.(tmpRueb{i}).(dataName));
        dataRUEB(1:nInterPoints,i) = handles.catchmentInfo.(tmpRueb{i}).(dataName)';
        else
            dataRUEB(1,i) = NaN;
        end
    end
    newtime = nan;
    return;
end


%% Get and reshape data from all RUEB
startTime = handles.startDateEdit.String; %'01.05.2014';
stopTime  = handles.stopDateEdit.String; % '10.05.2014';
dt = 600; % 10 Minutes
startTimeSec = datenum(startTime,'dd.mm.yyyy')*24*60*60;
stopTimeSec  = datenum(stopTime,'dd.mm.yyyy')*24*60*60;
newtime = [startTimeSec:dt:stopTimeSec]'; %#ok<NBRAK>


dataRUEB = zeros(numel(newtime), N);

for i=1:N
    
    timeSec = handles.data.(tmpRueb{i}).timeSec;
    
    data = handles.data.(tmpRueb{i}).(dataName);
    data(diff(timeSec)==0) = [];
    timeSec(diff(timeSec)==0) = [];
    
    
    dataRUEB(:,i) = interp1(timeSec, data, newtime); % Linear interpolate between data points
end
