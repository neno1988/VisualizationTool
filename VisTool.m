function varargout = VisTool(varargin)
% VISTOOL MATLAB code for VisTool.fig
%      VISTOOL, by itself, creates a new VISTOOL or raises the existing
%      singleton*.
%
%      H = VISTOOL returns the handle to a new VISTOOL or the handle to
%      the existing singleton*.
%
%      VISTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISTOOL.M with the given input arguments.
%
%      VISTOOL('Property','Value',...) creates a new VISTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VisTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VisTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VisTool

% Last Modified by GUIDE v2.5 13-Jun-2016 16:23:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VisTool_OpeningFcn, ...
    'gui_OutputFcn',  @VisTool_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VisTool is made visible.
function VisTool_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VisTool (see VARARGIN)

% Choose default command line output for VisTool
handles.output = hObject;

% Neno part, from here, we import the data
cd Structures
fileList = dir('*.mat');
for i=1:numel(fileList)
    load(fileList(i).name);
    fileName =  fileList(i).name(1:end-4);
    eval(['handles.data.' fileName ' = ' fileName ';']);
end
cd ..

% Added comments
% Added more commentes
if(exist('Data\rainData.mat')~=0)
    load('Data\rainData.mat')
    handles.rainData = rainData;
end
if(exist('Data\catchmentInfo.mat')~=0)
    load('Data\catchmentInfo.mat');
    handles.catchmentInfo = catchmentInfo;
end


if(exist('Data\inflowWWTP.mat')~=0)
    load('Data\inflowWWTP.mat');
    handles.inflowWWTP = inflowWWTP;
end
    
for i=1:numel(fields(handles.data))
    tmpRueb = fields(handles.data);
    handles.ruebList{i} = handles.data.(tmpRueb{i}).name;
end

listbox3_Callback(0, 0, handles)
% end of Neno part
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VisTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function  axes1_CreateFcn(~, ~, ~)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Outputs from this function are returned to the command line.
function varargout = VisTool_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(~, ~, handles) %#ok<*DEFNU>
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in listbox2.
function listbox2_Callback(~, ~, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


plotType = GetString(handles.listbox2);


if(strcmp(plotType,'test'))
    handles.listbox1.String = {'test'};
    handles.listbox1.Value = 1;
elseif(strcmp(plotType,'horizonPlot') || strcmp(plotType,'heatmap'))
    handles.listbox1.String = {'percentFilling'; 'absErrCentralTank'; 'compareToDownstream'};
    handles.listbox1.Value = 1;
elseif(strcmp(plotType,'normalPlot'))
    handles.listbox1.String = {'waterLevel'; 'inflow'; 'outflow';'overflow';'COD'; 'rain'};
    handles.listbox1.Value = 1;
elseif(strcmp(plotType,'histogram'))
    handles.listbox1.String = {'waterLevel'; 'inflow'; 'outflow';'overflow';'COD'; 'rain'};
    handles.listbox1.Value = 1;
elseif(strcmp(plotType,'topology'))
    handles.listbox1.String = {'all'; 'withData'};
    handles.listbox1.Value = 1;
    
else
    error('should not happen')
end
UpdatePlots(handles); % Actualize plots at each change


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdatePlots(handles)
% Select plot type

plotType = GetString(handles.listbox2);
    

% normal axis
axis normal
switch(plotType)
    case 'test'
        x = 1:10;
        y = x.^2;
        plot(x,y)
        %         set(gca,'KeyPressFcn', @fig_keypressfcn);
    case 'normalPlot'
        handles.axes4.Visible = 'off';
        PlotNormalPlot(handles);
    case 'horizonPlot'
        handles.axes4.Visible = 'off';
        PlotHorizonPlot(handles, 'horizonPlot');
    case 'heatmap'
        handles.axes4.Visible = 'on';
        PlotHorizonPlot(handles, 'heatmap');
    case 'histogram'
        handles.axes4.Visible = 'off';
        PlotHystogram(handles);
    case 'topology'
        handles.axes4.Visible = 'off';
        PlotTopology( handles);
    otherwise
        if(isfield(handles.listbox2, 'String'))
        error([handles.listbox2.String(V,:) ': Unknown Plot'])
        else
            error([': Unknown Plot'])
        end
end


function PlotHystogram(handles)

variable = GetString(handles.listbox1);
if(iscell(variable))
    variable = variable{1};
end


tmpRUEB = GetString(handles.listbox3);
if(iscell(tmpRUEB))
    tmpRUEB = tmpRUEB{1};
end
try
    dataRUEB = handles.data.(tmpRUEB).(variable);
catch
    DataNotAvailable();
    return
end

% histogram(dataRUEB', 400);
hist(dataRUEB', 400);



function PlotNormalPlot(handles)

    RUEB = GetString(handles.listbox3);



    variable = GetString(handles.listbox1);


% dirty trick... but it works
try
    handles.data.toPlot.y = handles.data.(RUEB).(variable);
catch
    DataNotAvailable();
    return
end

timeSec = handles.data.(RUEB).timeSec;


startTime = GetString(handles.startDateEdit); %'01.05.2014';
stopTime  = GetString(handles.stopDateEdit); % '10.05.2014';


dt = 600; % 10 Minutes
startTimeSec = datenum(startTime,'dd.mm.yyyy')*24*60*60;
stopTimeSec  = datenum(stopTime,'dd.mm.yyyy')*24*60*60;
newtime = [startTimeSec:dt:stopTimeSec]'; %#ok<NBRAK>


handles.data.toPlot.y(diff(timeSec)==0) = []; % remove double values
timeSec(diff(timeSec)==0) = [];
toPlotY = interp1(timeSec, handles.data.toPlot.y, newtime); % Linear interpolate between data points

timeSec = newtime;

timeTicks = GetString(handles.listbox4);


timeSec = timeSec - timeSec(1);
switch(timeTicks)
    case 'seconds'
        t = timeSec;
    case 'minutes'
        t = timeSec/60;
    case 'hours'
        t = timeSec/(60*60);
    case 'days'
        t = timeSec/(60*60*24);
    case 'weeks'
        t = timeSec/(60*60*24*7);
    case 'months'
        disp('Displaying every 30 day, not months')
        t = timeSec/(60*60*24*30);
    otherwise
        error('Unknown Time in Time scale box')
end

plot(t, toPlotY);
set(gcf,'toolbar','figure');


% --- Executes on selection change in listbox3.
function listbox3_Callback(~, ~, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
% handles.listbox3.Value = 1;
% for i=1:numel(fields(handles.data))
%     tmpRueb = fields(handles.data);
%     handles.listbox3.String{i} = handles.data.(tmpRueb{i}).name;
% end

if(isfield(handles.listbox3, 'String'))
    
    % MATLAB 2015
    if(isempty(handles.listbox3.String))
        handles.listbox3.Value = 1;
        handles.listbox3.String = handles.ruebList;
    end
else
    % MATLAB 2014
    if(isempty(get(handles.listbox3, 'String')))
        set(handles.listbox3, 'Value', 1);
        set(handles.listbox3, 'String',  handles.ruebList);
    end
end
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% handles.listbox3.String

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(~, ~, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
UpdatePlots(handles);

function listbox4_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startDateEdit_Callback(~, ~, handles)
% hObject    handle to startDateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startDateEdit as text
%        str2double(get(hObject,'String')) returns contents of startDateEdit as a double
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function startDateEdit_CreateFcn(hObject, ~, ~)
% hObject    handle to startDateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stopDateEdit_Callback(~, ~, handles)
% hObject    handle to stopDateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stopDateEdit as text
%        str2double(get(hObject,'String')) returns contents of stopDateEdit as a double
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function stopDateEdit_CreateFcn(hObject, ~, ~)
% hObject    handle to stopDateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(~, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% move to next time period
ShiftDate(handles, 1);

UpdatePlots(handles)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Move to previous time period
ShiftDate(handles, -1);
UpdatePlots(handles)


function  ShiftDate(handles, sign)

howLong = GetString(handles.listbox4);
if(iscell(howLong))
    howLong = howLong{1};
end


switch(howLong)
    case 'seconds'
        dt = 1/(60*60*24);
    case 'minutes'
        dt = 1/(60*24);
    case 'hours'
        dt = 1/24;
    case 'days'
        dt = 1;
    case 'weeks'
        dt = 1*7;        
    case 'months'
        disp('day, not months yet')
        dt = 1*30;
    otherwise
        error('Unknown Time in Time scale box')
end

% Shift start and stop dates of dt
handles.startDateEdit.String = datestr(datenum(GetString(handles.startDateEdit),'dd.mm.yyyy') + sign*dt, 'dd.mm.yyyy');
handles.stopDateEdit.String  = datestr(datenum(GetString(handles.stopDateEdit),'dd.mm.yyyy') + sign*dt, 'dd.mm.yyyy');


function [] = fig_keypressfcn(varargin)
% The keypressfcn for the figure.
switch varargin{2}.Key
    case 'a'
        ShiftDate(handles, 1);
    case 's'
        ShiftDate(handles, -1);
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(~, ~, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if(handles.checkbox2.Value==1)
    hold on;
else
    hold off
end

function [] = DataNotAvailable()
disp('Data not available :/')
notFoundImage = imread('404.jpg');
image(notFoundImage);

function[string] = GetString(listbox)

if(isfield(listbox, 'Value'))
V = listbox.Value;
string = strtrim(listbox.String{V});
else
    V = get(listbox, 'Value');
    if(V~=0)
        % listbox
    V = get(listbox, 'Value');
    stringVec = get(listbox, 'String');
    string = strtrim(stringVec(V));
    else
        % Edit
        string = strtrim(get(listbox, 'String'));
    end
end
if(iscell(string))
    string = string{1};
end