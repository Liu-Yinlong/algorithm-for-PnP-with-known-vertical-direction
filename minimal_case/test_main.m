clc;clear;close all

addpath('singularity\')
addpath('degenerated\')


theta=rand(1);

[p_3d,b_2d,v_3d,v_2d,R_gt,t_gt] = gen_data_mini(theta);

[R_opt_1,trans_1,R_opt_2,trans_2,tim_degenerate] = get_pose_by_degenerate(p_3d,b_2d,v_3d,v_2d);

[error_rot_degenerate,error_tran_degenerate] = calc_error(R_opt_1,trans_1,R_opt_2,trans_2,R_gt,t_gt);

[R_opt_1,trans_1,R_opt_2,trans_2,tim_our] = get_pose_by_decouple(p_3d,b_2d,v_3d,v_2d);

[error_rot_our,error_tran_our] = calc_error(R_opt_1,trans_1,R_opt_2,trans_2,R_gt,t_gt);

[R_opt_1,trans_1,R_opt_2,trans_2,tim_singularity] = get_pose_by_singularity(p_3d,b_2d,v_3d,v_2d);

[error_rot_singularity,error_tran_singularity] = calc_error(R_opt_1,trans_1,R_opt_2,trans_2,R_gt,t_gt);




