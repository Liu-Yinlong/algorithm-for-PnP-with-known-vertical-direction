function [R_opt_1,trans_1,R_opt_2,trans_2,tim] = get_pose_by_singularity(p_3d,b_2d,v_3d,v_2d)
%GET_POSE_BY_DECOUPLE Summary of this function goes here
%   Detailed explanation goes here
tic
[R_opt_1,R_opt_2] = get_Rot_singularity(p_3d,b_2d,v_3d,v_2d);
[trans_1] = get_tran(p_3d,b_2d,R_opt_1);
[trans_2] = get_tran(p_3d,b_2d,R_opt_2);
tim=toc;
end

