function posix_time = str2posix(time_string, time_zone)
    
    date_time = datetime(time_string, 'InputFormat', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', time_zone);
    
    posix_time = posixtime(date_time);
    
    %posix_time = num2str(posix_time);
    
end

