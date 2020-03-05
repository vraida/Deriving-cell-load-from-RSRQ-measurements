function s_binned = bin_signal(t, s, t_edges)

    s_binned = nan(1, length(t_edges)-1);
    
    for i = 1 : length(s_binned)
        mask = (t >= t_edges(i))  &  (t < t_edges(i+1));
        s_binned(i) = mean( s(mask) );
    end
    
end

