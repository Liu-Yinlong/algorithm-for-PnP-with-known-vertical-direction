function [p_3d,b_2d,v_3d,v_2d,R_gt,t_gt] = gen_data_mini(theta)
%GEN_DATA_MINI Summary of this function goes here
%   Detailed explanation goes here

v_3d_non=rand(3,1)*2-1;
v_3d=v_3d_non./norm(v_3d_non);
v_2d_non=rand(3,1)*2-1;
v_2d=v_2d_non./norm(v_2d_non);

v_1_non=cross(v_3d,v_2d);
v_1=v_1_non./norm(v_1_non);
theta_1=acos(v_3d'*v_2d);

V=[0 -v_1(3) v_1(2);v_1(3) 0 -v_1(1); -v_1(2) v_1(1) 0];
R_1=expm(V*theta_1);

R_gt=rotationVectorToMatrix(v_2d*theta)*R_1;


p_3d=(rand(3,2)*2-1)+[0;0;100];




t_gt=mean(p_3d,2)+rand(3,1)*10;

b_2d_non=R_gt*(p_3d+t_gt);
b_2d=b_2d_non./vecnorm(b_2d_non);





end

