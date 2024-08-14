function [y_var, y_diff, peak] = fun_annotate(x_var,Cal_t)
%Annotate the min and max relative difference on the upper left of the
%figure.

len = length(Cal_t);
for i = 1:len
    for j = 1:length(x_var)
        idx = find(Cal_t{i}(:,1) == x_var(j));
        idx = idx(1);
        if ~isempty(idx)
            y_var(j,i) = Cal_t{i}(idx,2);
        else
            y_var(j,i) = NAN;
        end
    end
end
peak = zeros(2, (len-1)*2); %
text_1 = "min: ";
text_2 = "max: ";
for i = 2:len
    y_index = 2*(i-1);
    T_index = 2*(i-1)-1;
    y_temp = (y_var(:,i) - y_var(:,1)) ./ y_var(:,1);
    % minimum value
    [peak(1, y_index), index] = min(y_temp);
     peak(1, y_index) = peak(1,y_index)*100;%value * 100 to be shown in percentage.
     peak(1, T_index) = x_var(index);
    % maximum value
    [peak(2, y_index), index] = max(y_temp);
     peak(2, y_index) = peak(2, y_index)*100;%value * 100 to be shown in percentage.
     peak(2, T_index) = x_var(index);
    text_1 = text_1 + "%0.0fK, %0.2f%%, ";
    text_2 = text_2 + "%0.0fK, %0.2f%%, ";
end
text_1 = char(text_1);
text_1 =text_1(1:end-2);
text_2 = char(text_2);
text_2 = text_2(1:end-2);
annotation_text_1 = sprintf(text_1, peak(1,:));
annotation_text_2 = sprintf(text_2, peak(2,:));

% Define the position for the annotation (adjust as needed)
x_limits = xlim;
y_limits = ylim;
x_position = x_limits(1) + 0.07 * (x_limits(2) - x_limits(1)); % 5% from the left
y_position_1 = y_limits(2) - 0.07 * (y_limits(2) - y_limits(1)); % 5% from the top
y_position_2 = y_limits(2) - 0.11 * (y_limits(2) - y_limits(1)); % 5% from the top
text(x_position, y_position_1, annotation_text_1, 'FontSize', 10, 'BackgroundColor', 'none');
text(x_position, y_position_2, annotation_text_2, 'FontSize', 10, 'BackgroundColor', 'none');
y_diff = (y_var(:, 2:end) - y_var(:,1)) ./ y_var(:,1);
end


