function out=Branch(branch)
%��������������2^3��֧

center=branch(1:3);
half_side=branch(4);
new_half_side=0.5*half_side;
out=zeros(4,8);
out(1:3,1)=[center(1)-new_half_side;center(2)-new_half_side;center(3)-new_half_side];
out(1:3,2)=[center(1)-new_half_side;center(2)-new_half_side;center(3)+new_half_side];
out(1:3,3)=[center(1)-new_half_side;center(2)+new_half_side;center(3)+new_half_side];
out(1:3,4)=[center(1)-new_half_side;center(2)+new_half_side;center(3)-new_half_side];

out(1:3,5)=[center(1)+new_half_side;center(2)-new_half_side;center(3)-new_half_side];
out(1:3,6)=[center(1)+new_half_side;center(2)-new_half_side;center(3)+new_half_side];
out(1:3,7)=[center(1)+new_half_side;center(2)+new_half_side;center(3)-new_half_side];
out(1:3,8)=[center(1)+new_half_side;center(2)+new_half_side;center(3)+new_half_side];

out(4,:)=new_half_side*ones(1,8);


end