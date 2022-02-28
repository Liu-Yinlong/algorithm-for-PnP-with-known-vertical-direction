function [R_opt_1,trans_1,R_opt_2,trans_2,tim] = get_pose_by_degenerate(p_3d,b_2d,v_3d,v_2d)
%GET_POSE_BY_DECOUPLE Summary of this function goes here
%   Detailed explanation goes here
tic

v_1_non=cross(v_3d,v_2d);
v_1=v_1_non./norm(v_1_non);
theta_1=acos(v_3d'*v_2d);

V=[0 -v_1(3) v_1(2);v_1(3) 0 -v_1(1); -v_1(2) v_1(1) 0];
R_1=expm(V*theta_1);


K=v_3d'*(p_3d(:,1)-p_3d(:,2));
if(abs(K)<=1e-10)
    R_opt_1=0;
    trans_1=0;
    R_opt_2=0;
    trans_2=0;
    tim=0;
    return 
end
O1=v_2d'*b_2d(:,1);
O2=v_2d'*b_2d(:,2);
m=K./O1;
n=O2./O1;

Z=p_3d(:,1)-p_3d(:,2);
LL=sum((Z).^2);

A=m.*b_2d(:,1);
B=n.*b_2d(:,1)-b_2d(:,2);

c=sum(A.^2)-LL;
b=sum(2*A.*B);
a=sum(B.^2);

lamda_2=roots([a,b,c]);
lamda_1=m+lamda_2*n;
b_3d_1=[lamda_1(1)*b_2d(:,1),lamda_2(1)*b_2d(:,2)];
b_3d_2=[lamda_1(2)*b_2d(:,1),lamda_2(2)*b_2d(:,2)];

X=R_1*Z;
s1=cross(X,v_2d);

I1=b_3d_1(:,1)-b_3d_1(:,2);
s2_1=cross(I1,v_2d);

I2=b_3d_2(:,1)-b_3d_2(:,2);
s2_2=cross(I2,v_2d);

angle_1=acos(dot(s1,s2_1)/(norm(s1)*norm(s2_1)));
R_2_1=rotationVectorToMatrix(v_2d*angle_1);
if(norm(R_2_1*X-I1)>=1e-10)
    R_2_1=rotationVectorToMatrix(-v_2d*angle_1);
end
angle_2=acos(dot(s1,s2_2)/(norm(s1)*norm(s2_2)));
R_2_2=rotationVectorToMatrix(v_2d*angle_2);
if(norm(R_2_2*X-I2)>=1e-10)
    R_2_2=rotationVectorToMatrix(-v_2d*angle_2);
end

R_opt_1=R_2_1*R_1;
R_opt_2=R_2_2*R_1;

trans_1=R_opt_1'*b_3d_1(:,1)-p_3d(:,1);
trans_2=R_opt_2'*b_3d_2(:,1)-p_3d(:,1);
tim=toc;
end

