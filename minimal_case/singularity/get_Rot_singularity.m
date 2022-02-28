function [R_opt_1,R_opt_2] = get_Rot_singularity(p_3d,b_2d,v_3d,v_2d)
%GET_POSE Summary of this function goes here
%   Detailed explanation goes here
n=cross(b_2d(:,1),b_2d(:,2));

v_1_non=cross(v_3d,v_2d);
v_1=v_1_non./norm(v_1_non);
theta_1=acos(v_3d'*v_2d);

V=[0 -v_1(3) v_1(2);v_1(3) 0 -v_1(1); -v_1(2) v_1(1) 0];
R_1=expm(V*theta_1);

G=[0 -v_2d(3) v_2d(2);v_2d(3) 0 -v_2d(1); -v_2d(2) v_2d(1) 0];
P=R_1*(p_3d(:,1)-p_3d(:,2));

a=n'*G*P;
b=-n'*G*G*P;
c=n'*(eye(3)+G*G)*P;


A=c-b;
B=2*a;
C=b+c;

% if(abs(A)<1e-10)
%     q(1)=-C/B;
%     q(2)=q(1);
% else
%     Q=sqrt(B^2-4*A*C);
%     q(1)=(-B+Q)/(2*A);
%     q(2)=(-B-Q)/(2*A);
% end
q=roots([A,B,C]);


x=2*q./(1+q.^2);
y=(1-q.^2)./(1+q.^2);

% tic
% syms k1 k2;
% eqn1=a*k1+b*k2+c==0;
% eqn2=k1^2+k2^2==1;
% [S]=vpasolve([eqn1,eqn2],[k1,k2]);
% k1=double(S.k1);
% k2=double(S.k2);
% toc
if(size(q)==1)
    
end
R_opt_1=(eye(3)+x(1)*G+(1-y(1))*G*G)*R_1;
if(size(q)==1)
    R_opt_2=R_opt_1;
else
    R_opt_2=(eye(3)+x(2)*G+(1-y(2))*G*G)*R_1;
end


end


