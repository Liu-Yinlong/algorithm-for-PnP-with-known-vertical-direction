clc;clear;close all;
outlier_rate=0.3;
noise_level=0.1;
NUM=1000;
epsilon=0.0175*1;


[point_2d,point_3d,R_gt,t_gt,v_3d,v_2d]=gen_data_pnp(NUM,outlier_rate,noise_level);
 
tans_domain=[0;0;0;500];
%%

alpha_2d=acos(v_2d'*point_2d);

tic
[t_opt] = globally_search_trans(point_3d,point_2d,v_3d,v_2d,epsilon,tans_domain);
[opt_r]=voting_estimate_R(point_3d,point_2d,v_3d,v_2d,t_opt);
toc
disp(['trans error(absolute) ',num2str(norm(t_opt-t_gt))]);
disp(['rotation error(deg) ',num2str(rad2deg(norm(rotationMatrixToVector(opt_r'*R_gt))))]);
