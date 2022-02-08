clc;clear;close all;

input_number=1000;
outlier_rate=0.95;
noise_level=0.1;

data_file_name='./data.txt';

setting_file_name='./setting.txt';

save_file_name='./save.txt';

epsilon=0.0175;
init_t=[0,0,0,500];

dlmwrite(setting_file_name, [epsilon,init_t], "delimiter", ",");

[R_gt,t_gt]=gen_data(input_number,outlier_rate,noise_level,data_file_name);

cmd=['G_PnP ',data_file_name,' ',setting_file_name,' ',save_file_name];

system(cmd);

results=dlmread(save_file_name);

opt_R=reshape(results(1:9),3,3)';

opt_t=results(10:12)';

tim= results(end);

error_r=acosd(0.5*(trace(opt_R'*R_gt)-1));

error_t=norm(opt_t-t_gt);

disp(['runtime(ms):',num2str(tim)])
disp('rotaion ground truth:')
disp(R_gt);
disp('optimal rotation:')
disp(opt_R)

disp('translation ground truth:')
disp(t_gt)
disp('optimal translation:')
disp(opt_t)

fprintf('rotation error is %f(deg)\n',error_r)
fprintf('trans error is %f(diff)\n',error_t)


