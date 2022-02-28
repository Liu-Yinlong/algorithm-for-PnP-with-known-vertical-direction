function [trans] = get_tran(p_3d,b_2d,R_opt)
%GET_TRAN Summary of this function goes here
%   Detailed explanation goes here
b_2d=R_opt'*b_2d;
A=[0 -b_2d(3,1) b_2d(2,1);
    b_2d(3,1) 0 -b_2d(1,1);
    0 -b_2d(3,2) b_2d(2,2);
    b_2d(3,2) 0 -b_2d(1,2)];
b=[b_2d(3,1)*p_3d(2,1)-b_2d(2,1)*p_3d(3,1);
   -b_2d(3,1)*p_3d(1,1)+b_2d(1,1)*p_3d(3,1);
   b_2d(3,2)*p_3d(2,2)-b_2d(2,2)*p_3d(3,2);
   -b_2d(3,2)*p_3d(1,2)+b_2d(1,2)*p_3d(3,2)];
trans=A\b;
end

