function [L,U] = get_bounds(branch,point_3d,v_3d,alpha_2d,epsilon)
%GET_BOUNDS Summary of this function goes here
%   Detailed explanation goes here
t_c=branch(1:3);
half_side=branch(4);
point_3d_tran=point_3d+t_c;
Length=vecnorm(point_3d_tran);

beta_3d=acos(v_3d'*(point_3d_tran./Length));

temp=sqrt(3)*half_side./Length;
ind=temp>=1;
temp(ind)=1;
delta=asin(temp);
delta(ind)=2*pi;

diff=abs(beta_3d'-alpha_2d);
L=sprank(diff<=epsilon);
U=sprank(diff<=epsilon+delta');

end

