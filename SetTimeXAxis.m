function [] = SetTimeXAxis(handles)
    timeStartSec = datenum(GetString(handles.startDateEdit), 'dd.mm.yyyy')*24*60*60;
    timeStopSec  = datenum(GetString(handles.stopDateEdit), 'dd.mm.yyyy')*24*60*60;
    dt = 600;
    timeSec = timeStartSec:dt:timeStopSec;
    timeSec = timeSec - timeSec(1);
    timeScale = GetString(handles.listbox4);

    
    switch(timeScale)
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
    
    xlabel(['Time [' timeScale ']'])
    numberOfTicks = floor(t(end));
    L = get(gca,'XLim');
    if(numberOfTicks>60)
        warning('Limiting X-axis labels to 60')
        numberOfTicks = 60;
        dt = max(t)/numberOfTicks;
        set(gca, 'XTick', linspace(L(1),L(2),numberOfTicks+1));
        set(gca, 'XTickLabel', round([0:numberOfTicks]*dt)); %#ok<NBRAK>
    else
        set(gca, 'XTick', linspace(L(1),L(2),numberOfTicks+1));
        set(gca, 'XTickLabel', 0:numberOfTicks);
    end
    

    