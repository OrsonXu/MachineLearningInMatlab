files_test = dir('emojis/*.png');
n_total= length(files_test);

n_test = 0;
for i = 1 : n_total
    tmp_name = files_test(i).name;
    tmp_image = imread(strcat('./emojis/',tmp_name));
    if (prod(size(tmp_image)) == 64 * 64 *3)
        n_test = n_test + 1;
        class_test{n_test} = tmp_name;
        images{n_test} = tmp_image;
    end
end

class_test = char(class_test);
for i = 1 : n_test
    tmp = images{i};
    tmp = reshape(tmp, [1,64*64*3]);
    image_test(i,:) = tmp;
end

correct_count = 0;
for i = 1 : n_test
    disp(i)
    tmp_result = match_emoji(image_test(i,:));
    if (strcmp(tmp_result, class_test(i,:)))
        correct_count = correct_count + 1;
    end
end

% RESULT : 1.00
accuracy = correct_count / n_test;
disp(accuracy);

for i = 1 : n_test
    tmp = sum((image_test(i,:) - image_set(i,:)).^2);
    fprintf('%d, %d\n',i,tmp);
end