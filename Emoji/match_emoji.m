function y = match_emoji( vector )
    load('image_set.mat')
    load('class_set.mat')
    
    [ n, vec_len ] = size(image_set);
    distance_min = 255 * 255 * 12288;
    index = 0;
    for i = 1 : n
        distance_tmp = sum((vector - image_set(i,:)).^2);
        if (distance_tmp < distance_min)
            distance_min = distance_tmp;
            index = i;
        end
    end
    y = class_set(index,:);
end
        
        
        