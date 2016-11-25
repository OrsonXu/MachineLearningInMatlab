files = dir('emojis/*.png');
nfiles = length(files);

count = 0;
for i = 1 : nfiles
    tmp_name = files(i).name;
    tmp_image = imread(strcat('./emojis/',tmp_name));
    if (prod(size(tmp_image)) == 64 * 64 *3)
        count = count + 1;
        class_name{count} = tmp_name;
        images{count} = tmp_image;
    end
end

class_name = char(class_name);
for i = 1 : count
    tmp = images{i};
    tmp = reshape(tmp, [1,64*64*3]);
    image_set(i,:) = tmp;
end
class_set = class_name;
save('image_set.mat', 'image_set');
save('class_set.mat', 'class_set');
    