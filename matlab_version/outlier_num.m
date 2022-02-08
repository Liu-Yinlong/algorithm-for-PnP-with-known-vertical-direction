clc;clear;close all;


outlier_rate=0.1;
noise_level=10;
NUM=1000:1000:18000;
epsilon=0.0175;
tans_domain=[0;0;0;500];%[center;half_side]
error(50,18)=0;
tim(50,18)=0;
for ii=1:18
    for jj=1:50
        [point_2d,point_3d,R_gt,t_gt,v_3d,v_2d]=gen_data_pnp(NUM(ii),outlier_rate,noise_level);
        tic
        [t_opt] = globally_search_trans(point_3d,point_2d,v_3d,v_2d,epsilon,tans_domain);
        tim(jj,ii)=toc;
        error(jj,ii)=norm(t_opt-t_gt);
        [ii,jj]
    end
    
end
figure
boxplot(error);
figure
boxplot(tim);

