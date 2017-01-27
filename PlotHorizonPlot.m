function PlotHorizonPlot(handles, typ)
% Process data

variable = GetString(handles.listbox1);
if(iscell(variable))
    variable = variable{1};
end
switch(variable)
    
    case 'waterLevel'
        [dataRUEB, ~] = GetDataRueb(handles, 'waterLevel');
        imagesc(dataRUEB');
        
    case 'percentFilling'
        % Get Data
        [waterLevels, newTime] = GetDataRueb(handles, 'waterLevel');
        [gepOverflowEdge, ~] = GetDataRueb(handles, 'gepOverflowEdge', 'catchmentInfo');
        [overflowEdge, ~] = GetDataRueb(handles, 'overflowEdge', 'catchmentInfo');
        [volume, ~] = GetDataRueb(handles, 'volume', 'catchmentInfo');
        [H2VHeight, ~] = GetDataRueb(handles, 'H2VHeight', 'catchmentInfo');
        [H2VVolume, ~] = GetDataRueb(handles, 'H2VVolume', 'catchmentInfo');
        
        % rescale water levels
        waterLevels = bsxfun(@rdivide,waterLevels,overflowEdge);
        waterLevels = bsxfun(@times,waterLevels,gepOverflowEdge);
        
        
        % Remove tanks without H2V functions:
        toRemove= find(isnan(sum(H2VVolume)));
        waterLevels(:, toRemove) = [];
        volume(:, toRemove) = [];
        H2VHeight(:, toRemove) = [];
        H2VVolume(:, toRemove) = [];
        ruebList = handles.ruebList;
        disp('removing' );
        disp(ruebList(toRemove));
        disp('Missing Height to volume information');
        ruebList(toRemove) = [];
        
        % compute criteria
        N = numel(ruebList);
        dataRUEB = zeros(numel(newTime), N);
        for i = 1:N
            tmpHeight = sort(H2VHeight(:,i));
            tmpVolume = sort(H2VVolume(:,i));
            tmpVolume(diff(tmpHeight)<=0) = [];
            tmpHeight(diff(tmpHeight)<=0) = [];
            
            dataRUEB(:,i)     = interp1(tmpHeight, tmpVolume, waterLevels(:,i), 'linear');
        end
        dataRUEB = bsxfun(@rdivide, dataRUEB,volume);

        % Scale WRT dimension
        if(strcmp(typ,'heatmap'))
            yResolution = 50; % Plus separation lines!
            totalStorageVolume = sum(volume);
            dataRUEBNew = [];
            yTicks = zeros(N,1);
            nanCol = nan*ones(size(dataRUEB(:,1)));
            for i=1:N
                reps = round(volume(i)/totalStorageVolume*yResolution);
                yTicks(i) = round(size(dataRUEBNew, 2)+ reps/2+1);
                dataRUEBNew = [dataRUEBNew, repmat(dataRUEB(:,i), [1,reps]), nanCol];
            end
            dataRUEB = dataRUEBNew;
            set(gca, 'YTick', yTicks);
            
        end
        
        
    case 'absErrCentralTank'
        % Get Data
        [waterLevels, newTime] = GetDataRueb(handles, 'waterLevel');
        [gepOverflowEdge, ~] = GetDataRueb(handles, 'gepOverflowEdge', 'catchmentInfo');
        [overflowEdge, ~] = GetDataRueb(handles, 'overflowEdge', 'catchmentInfo');
        [volume, ~] = GetDataRueb(handles, 'volume', 'catchmentInfo');
        [H2VHeight, ~] = GetDataRueb(handles, 'H2VHeight', 'catchmentInfo');
        [H2VVolume, ~] = GetDataRueb(handles, 'H2VVolume', 'catchmentInfo');
        
        % rescale water levels
        waterLevels = bsxfun(@rdivide,waterLevels,overflowEdge);
        waterLevels = bsxfun(@times,waterLevels,gepOverflowEdge);
        
        % Remove tanks without H2V functions:
        toRemove= find(isnan(sum(H2VVolume)));
        waterLevels(:, toRemove) = [];
        volume(:, toRemove) = [];
        H2VHeight(:, toRemove) = [];
        H2VVolume(:, toRemove) = [];
        ruebList = handles.ruebList;
        disp('removing' );
        disp(ruebList(toRemove));
        disp('Missing Height to volume information');
        ruebList(toRemove) = [];
        
        % compute criteria
        N = numel(ruebList);
        fillingLevel = zeros(numel(newTime), N);
        Vtot = 0;
        for i = 1:N
            tmpHeight = sort(H2VHeight(:,i));
            tmpVolume = sort(H2VVolume(:,i));
            tmpVolume(diff(tmpHeight)<=0) = [];
            tmpHeight(diff(tmpHeight)<=0) = [];
            
            fillingLevel(:,i) = interp1(tmpHeight, tmpVolume, waterLevels(:,i));
            Vtot = Vtot + tmpVolume(end);
        end
        
        fillingLevelPercent = bsxfun(@rdivide, fillingLevel,volume);
        overallFillingLevelPercent = sum(fillingLevel,2)/Vtot;
        dataRUEB = bsxfun(@minus, fillingLevelPercent,overallFillingLevelPercent);
        
    case 'compareToDownstream'    
                % Get Data
        [waterLevels, newTime] = GetDataRueb(handles, 'waterLevel');
        [gepOverflowEdge, ~] = GetDataRueb(handles, 'gepOverflowEdge', 'catchmentInfo');
        [overflowEdge, ~] = GetDataRueb(handles, 'overflowEdge', 'catchmentInfo');
        [volume, ~] = GetDataRueb(handles, 'volume', 'catchmentInfo');
        [H2VHeight, ~] = GetDataRueb(handles, 'H2VHeight', 'catchmentInfo');
        [H2VVolume, ~] = GetDataRueb(handles, 'H2VVolume', 'catchmentInfo');
        [downstreamTanks, ~] = GetDataRueb(handles, 'downstreamTank', 'catchmentInfo');
        
        % rescale water levels
        waterLevels = bsxfun(@rdivide,waterLevels,overflowEdge);
        waterLevels = bsxfun(@times,waterLevels,gepOverflowEdge);
        
        % Find index of downstram Tank
        ruebList = handles.ruebList;
        N = numel(ruebList);
        downstreamIndex = zeros(1,N);
        %
        for i=1:N % for all tanks
            tankNow = handles.ruebList{i};
            tankDownstream = handles.catchmentInfo.(tankNow).downstreamTank;
            for k=1:10 % 10 = Max-depth search
                for j=1:N
                    tankDownstream(double(tankDownstream)==0)=[]; % clean spaces (strtrim cannot remove these...)
                    if(sum(strcmp(tankDownstream, handles.ruebList))>=1)
                        downstreamIndex(i) = find(strcmp(tankDownstream, handles.ruebList));
                        break
                    end
                end
                if(downstreamIndex(i)==0)
                    % follow downstream structures until the end
                    if(strcmp(strtrim(tankDownstream), 'WWTP'))
                        % Zero for WWTP looks like a good standard...
                        break;
                    else
                        tankDownstream = handles.catchmentInfo.(tankDownstream).downstreamTank;
                    end
                else
                    break
                end
            end
        end
        
        
        % WWTP:
        inflowWWTP = handles.inflowWWTP;
        inflowWWTPToPlot = interp1(inflowWWTP.timeSec, inflowWWTP.data, newTime);
        maxCapacity  = handles.catchmentInfo.WWTP.maxInflow;
        inflowWWTPUsage = inflowWWTPToPlot/maxCapacity;
        
        % Remove tanks without H2V functions:
        toRemove= find(isnan(sum(H2VVolume)));
        waterLevels(:, toRemove) = [];
        volume(:, toRemove) = [];
        H2VHeight(:, toRemove) = [];
        H2VVolume(:, toRemove) = [];

        disp('removing' );
        disp(ruebList(toRemove));
        disp('Missing Height to volume information');
        % Update downstream tank information
        tmpList = [ruebList {'WWTP'}];
        downstreamIndex(downstreamIndex==0) = size(tmpList,2);
        downtreamTanksList = tmpList(downstreamIndex);
        ruebList(toRemove) = [];
        downtreamTanksList(toRemove) = [];
        
        % compute criteria
        N = numel(ruebList);
        fillingLevelCompared = zeros(numel(newTime), N);
        Vtot = 0;
        for i = 1:N
        
            
            if(strcmp(downtreamTanksList{i}, 'WWTP'))
                fillingLevelThis = ComputeFillingLevelPercent(H2VHeight, H2VVolume,waterLevels, i);
                fillingLevelCompared(:,i) = min(max(0,inflowWWTPUsage-fillingLevelThis), 1);
            else
                
            downstreamIdx = find(strcmp(downtreamTanksList{i}, ruebList));
            fillingLevelThis  = ComputeFillingLevelPercent(H2VHeight, H2VVolume,waterLevels, i);
            fillingLevelBelow = ComputeFillingLevelPercent(H2VHeight, H2VVolume,waterLevels,downstreamIdx);
            fillingLevelCompared(:,i) = min(max(0,fillingLevelThis ./ fillingLevelBelow),1);
            end
        end

        dataRUEB = fillingLevelCompared;
        
                % Scale WRT dimension
        if(strcmp(typ,'heatmap'))
            yResolution = 50; % Plus separation lines!
            totalStorageVolume = sum(volume);
            dataRUEBNew = [];
            yTicks = zeros(N,1);
            nanCol = nan*ones(size(dataRUEB(:,1)));
            for i=1:N
                reps = round(volume(i)/totalStorageVolume*yResolution);
                yTicks(i) = round(size(dataRUEBNew, 2)+ reps/2+1);
                dataRUEBNew = [dataRUEBNew, repmat(dataRUEB(:,i), [1,reps]), nanCol];
            end
            dataRUEB = dataRUEBNew;
            set(gca, 'YTick', yTicks);
            
        end
    otherwise
        disp('unknown plot')
        return;
end


% If available, plot rain
if(isfield(handles, 'rainData'))
    rainData = handles.rainData;
    rainDataToPlot = interp1(rainData.timeSec, rainData.rain, newTime);
    rainDataColorMap = rainDataToPlot/5; % 5 mm/h is the max. reperesentable
    
    % Update Data in dataRUEB matrix

    
    % update ticks and labels
    ruebList =  [ 'RAIN', ruebList];
    if(strcmp(typ,'heatmap'))
        rainSize = 10;
        dataRUEB = [repmat(rainDataColorMap, [1,rainSize]),nanCol, dataRUEB];
        yTicks = [floor(rainSize/2); yTicks+rainSize];
    elseif(strcmp(typ,'horizonPlot'))
        dataRUEB = [dataRUEB, rainDataColorMap];
    end
    
end

% If available, plot WWTP capacity utilization
if(isfield(handles, 'inflowWWTP'))
    
    inflowWWTP = handles.inflowWWTP;
    inflowWWTPToPlot = interp1(inflowWWTP.timeSec, inflowWWTP.data, newTime);
    
    maxCapacity  = handles.catchmentInfo.WWTP.maxInflow;
    inflowWWTPColormap = inflowWWTPToPlot/maxCapacity;
    % update ticks and labels
    ruebList =  [ruebList, 'WWTP Capacity'];
    if(strcmp(typ,'heatmap'))
            WWTPCapacitySize = 10;
            dataRUEB = [dataRUEB, repmat(inflowWWTPColormap, [1,WWTPCapacitySize])];
            yTicks = [ yTicks; size(dataRUEB, 2)-floor(WWTPCapacitySize/2)];
    elseif(strcmp(typ,'horizonPlot'))
        dataRUEB = [dataRUEB, inflowWWTPColormap];
    end
    
end





% actual Plotting
if(strcmp(typ,'horizonPlot'))
    options.axesPlot = 1;
    options.handles = handles;
    MakeHorizonPlot(-dataRUEB*2+1, 1, 3, options);
    
    N = size(ruebList, 2);
    tmp = gca;
    yTicksDelta = (tmp.YLim(2) - tmp.YLim(1))/(N);
    yTicks = tmp.YLim(1)-yTicksDelta/2 + cumsum(ones(1,N)*yTicksDelta);
    set(gca, 'YTick', yTicks);
    set(gca, 'YTickLabel', ruebList);
    caxis([0 1])
    
elseif(strcmp(typ,'heatmap'))
    colormap jet
    h = imagesc(dataRUEB');
    if(strcmp(version(),'8.3.0.532 (R2014a)')) % Bug/ function not available, matlab crash
        set(h,'alphadata',~isnan(dataRUEB'))
    end
    set(gca, 'YTick', yTicks);
    set(gca, 'YTickLabel', ruebList);
    caxis([0 1])
    
    % Time Axis
    SetTimeXAxis(handles);
else
    error('Unknown plot type.');
end
end

function fillingLevel = ComputeFillingLevelPercent(H2VHeight, H2VVolume,waterLevels, i)
tmpHeight = sort(H2VHeight(:,i));
tmpVolume = sort(H2VVolume(:,i));
tmpVolume(diff(tmpHeight)<=0) = [];
tmpHeight(diff(tmpHeight)<=0) = [];
fillingLevel = interp1(tmpHeight, tmpVolume, waterLevels(:,i));

% take into account tank size
fillingLevel = fillingLevel/tmpVolume(end);
end
