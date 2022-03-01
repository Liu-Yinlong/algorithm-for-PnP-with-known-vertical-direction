function [point_2d,point_3d,R_gt,t_gt,v_3d,v_2d,corr_gt]=gen_data_pnp(NUM,outlier_rate,noise_level)

outlier_num=round(outlier_rate*NUM);

r_=rand(3,1)*2-1;
r_gt=r_./norm(r_);

theta_gt=rand(1)*2*pi-pi;

R_gt=rotationVectorToMatrix(r_gt*theta_gt);

point_3d=rand(3,NUM)*150+[0;0;100];

t_gt=-mean(point_3d,2);

point_rot=R_gt*(point_3d+t_gt)+(rand(3,NUM)*2-1)*noise_level;

corr_gt=randperm(NUM);
point_2d_non_unit=point_rot(:,corr_gt);

if(outlier_num>0)
    point_2d_non_unit(:,1:outlier_num)=rand(3,outlier_num)*2-1;
    corr_gt(1:outlier_num)=0;
end
point_2d=point_2d_non_unit./vecnorm(point_2d_non_unit);

v_3d_=rand(3,1)*2-1;
v_3d=v_3d_./norm(v_3d_);
v_2d=R_gt*v_3d;


end