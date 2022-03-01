clc;clear;close all;
outlier_rate=0.2;
noise_level=0.01;
NUM=100;
epsilon=0.0175*1;
t_init=[0;0;0;1000];%[center,radius]
[point_2d,point_3d,R_gt,t_gt,v_3d,v_2d,corr_gt]=gen_data_pnp(NUM,outlier_rate,noise_level);
tic
[t_opt,corr_opt] = globally_search_trans(point_3d,point_2d,v_3d,v_2d,epsilon,t_init);
[R_opt] = voing_R(point_3d,point_2d,corr_opt,t_opt,v_3d,v_2d);
toc

error_rot=acosd((trace(R_gt'*R_opt)-1)*0.5);
error_tran=norm(t_opt-t_gt);

fprintf('error_rot:%f(deg)\n',error_rot);
fprintf('error_tran:%f\n',error_tran);
