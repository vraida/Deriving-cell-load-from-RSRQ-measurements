function plot_time_from_posix(first, last, time_zone, disp_lbls)
    % first, last ... posix times in seconds
    
    remove_hours = false;
    
    hour = 3600;
    
    if mod(first, hour) == 0
        first_tick = first;
    else
        first_tick = first + hour - mod(first, hour);
    end
    last_tick  = last - mod(last, hour);

    % Create hours labels
    time_ticks = first_tick:hour:last_tick;
    date_times = datetime(time_ticks, 'ConvertFrom', 'posixtime', 'TimeZone', time_zone);
    labels = cellstr( datestr(date_times, 'HH:MM') );
    
    % Add day labels
    for i = 1 : length(labels)
        if strcmp(labels{i}, '00:00')
            labels{i} = datestr(date_times(i), 'dd-mmm-yyyy');
        elseif remove_hours
            labels{i} = '';
        end
    end
    
    if remove_hours
        mask = strcmp(labels, '');
        time_ticks(mask) = [];
        labels(mask) = [];
    end
    
    % Set ticks;  If disp_lbls == 1  ->  display labels
    set(gca, 'XTick', time_ticks);    
    if disp_lbls
        set(gca, 'XTickLabel', labels);
    else
        set(gca, 'XTickLabel', []);
    end
    
    set(gca, 'XTickLabelRotation', 60);
    
    xlim([first last]);
    grid on;

end


