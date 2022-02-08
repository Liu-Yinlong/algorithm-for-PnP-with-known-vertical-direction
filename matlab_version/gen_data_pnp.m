function [point_2d,point_3d,R_gt,t_gt,v_3d,v_2d]=gen_data_pnp(NUM,outlier_rate,noise_level)

outlier_num=round(outlier_rate*NUM);

r_=rand(3,1)*2-1;
r_gt=r_./norm(r_);

theta_gt=rand(1)*2*pi-pi;

R_gt=rotationVectorToMatrix(r_gt*theta_gt);

point_3d=(rand(3,NUM)*2-1)*100+[0;0;150];

t_gt=-mean(point_3d,2);

point_rot=R_gt*(point_3d+t_gt);

if(outlier_num>0)
    point_rot(:,1:outlier_num)=rand(3,outlier_num)*2-1;
end

point_3d=point_3d++randn(3,NUM)*noise_level;

point_2d=point_rot./vecnorm(point_rot);

v_3d_=rand(3,1)*2-1;
v_3d=v_3d_./norm(v_3d_);
v_2d=R_gt*v_3d;

end