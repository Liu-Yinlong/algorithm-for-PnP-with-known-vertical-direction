function [error_rot,error_tran] = calc_error(R_opt_1,trans_1,R_opt_2,trans_2,R_gt,t_gt)
%CALC_ERROR Summary of this function goes here
%   Detailed explanation goes here
error_rot_1=norm(R_opt_1-R_gt,'fro');
error_rot_2=norm(R_opt_2-R_gt,'fro');
error_tran_1=norm(trans_1-t_gt);
error_tran_2=norm(trans_2-t_gt);

error_rot=min(error_rot_1,error_rot_2);
error_tran=min(error_tran_1,error_tran_2);
end

