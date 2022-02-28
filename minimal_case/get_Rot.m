function [R_opt_1,R_opt_2] = get_Rot(p_3d,b_2d,v_3d,v_2d)
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


if(abs(b)<1e-10)
    x(1)=-c/a;
    x(2)=x(1);
    y(1)=sqrt(1-c^2/a^2);
    y(2)=-y(1);
else %%%% see, https://www.wolframalpha.com/
    B=a^2+b^2;
    A=sqrt(b^2*(B-c^2));
    C=B*b;
    x(1)=-(A+a*c)/B;
    x(2)=(A-a*c)/B;
    y(1)=-(b^2*c-a*A)/C;
    y(2)=-(b^2*c+a*A)/C;
end

% tic
% syms k1 k2;
% eqn1=a*k1+b*k2+c==0;
% eqn2=k1^2+k2^2==1;
% [S]=vpasolve([eqn1,eqn2],[k1,k2]);
% k1=double(S.k1);
% k2=double(S.k2);
% toc

R_opt_1=(eye(3)+x(1)*G+(1-y(1))*G*G)*R_1;
R_opt_2=(eye(3)+x(2)*G+(1-y(2))*G*G)*R_1;

end


