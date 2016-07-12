function [] = PlotTopology( handles)
catchmentInfo = handles.catchmentInfo;
N = numel((handles.ruebList));
axes(handles.axes1);
cla reset; 

hold off
plotRuebCircle(catchmentInfo, 'WWTP');
hold on
axis equal
for i=1:N
    try
        plotRuebCircle(catchmentInfo, handles.ruebList{i});
    catch
        disp(['No position data for ' handles.ruebList{i}])
    end

    plotArrowToNext(catchmentInfo, handles.ruebList{i}, handles);

end

hold off
end

function plotRuebCircle(catchmentInfo, RUEB)
size = 10;
plotSizeX =  1024;
plotSizeY = 512;
posX = catchmentInfo.(RUEB).x*plotSizeX;
posY = (1-catchmentInfo.(RUEB).y)*plotSizeY; % the way I saved / matlab plots is mirrored for some reason...

rectX = posX-size/2;
rectY = posY-size/2;

rectangle('Position',[rectX,rectY, size, size],'Curvature',[1 1],'FaceColor', 'g')
text(rectX,rectY+15, RUEB)
end

function plotArrowToNext(catchmentInfo, RUEB, handles)

% find next structure with coordinates
while catchmentInfo.(RUEB).x<0
    RUEB = catchmentInfo.(RUEB).downstreamStructure;
end

plotSizeX =  1024;
plotSizeY = 512;

posX = catchmentInfo.(RUEB).x*plotSizeX;
posY = (1-catchmentInfo.(RUEB).y)*plotSizeY; % the way I saved / matlab plots is mirrored for some reason...

targetRUEB = catchmentInfo.(RUEB).downstreamStructure;

if(targetRUEB==-1)
    return
end
dx = catchmentInfo.(targetRUEB).x*plotSizeX - posX;
dy = (1-catchmentInfo.(targetRUEB).y)*plotSizeY - posY; % the way I saved / matlab plots is mirrored for some reason...


quiver(posX, posY,dx,dy,0)

% Stop when next known structure is reached
if(~isfield(targetRUEB, handles.ruebList))
    plotArrowToNext(catchmentInfo, targetRUEB, handles)
end

end


