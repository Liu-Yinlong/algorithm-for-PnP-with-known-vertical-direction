function [opt_r] = voing_R(p_3d,b_2d,corr_opt,t_opt,v_3d,v_2d)
%VOING_R Summary of this function goes here
%   Detailed explanation goes here

r_min_=cross(v_3d,v_2d);
r_min=r_min_./norm(r_min_);
theta_min=acos(v_3d'*v_2d);
r_time=[0 -r_min(3) r_min(2);r_min(3) 0 -r_min(1);-r_min(2) r_min(1) 0];
R_min=expm(r_time*theta_min);

%%%
M=sum(corr_opt>0);
b_2d(:,corr_opt==0)=[];
p_3d=p_3d(:,corr_opt(corr_opt>0));
point_3d_tran=p_3d+t_opt;
Q_3d=R_min*point_3d_tran;

m_3d_=cross(Q_3d,repmat(v_2d,1,M));
m_3d=m_3d_./vecnorm(m_3d_);
n_2d_=cross(b_2d,repmat(v_2d,1,M));
n_2d=n_2d_./vecnorm(n_2d_);

direction=cross(m_3d,n_2d);
ind_direc=v_2d'*direction>0;


angle=acos(dot(m_3d,n_2d));
angle(~ind_direc)=2*pi-angle(~ind_direc);

edges=linspace(0,2*pi,361);
angle_hist= histcounts(angle,edges);

% figure;
% histogram(angle,edges);
% title('voting for rotation')
% xticks([0 pi/2 pi 1.5*pi 2*pi])
% xticklabels({'0' '\pi/2' '\pi' '1.5\pi' '2\pi'})
% xlabel('rad');
% grid on

[~,theta_index]=max(angle_hist);

theta=0.5*(edges(theta_index)+edges(theta_index+1));
v_2d_time=[0 -v_2d(3) v_2d(2);v_2d(3) 0 -v_2d(1);-v_2d(2) v_2d(1) 0];
% R_extend_1=expm(theta*v_2d_time);
R_extend=expm(theta*v_2d_time);

opt_r=R_extend*R_min;


end

