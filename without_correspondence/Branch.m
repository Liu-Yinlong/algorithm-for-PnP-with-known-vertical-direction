function out=Branch(branch)
%对输入的区间进行2^3分支

center=branch(1:3);
half_side=branch(4);
new_half_side=0.5*half_side;

out(:,1)=[center(1)-new_half_side;center(2)-new_half_side;center(3)-new_half_side];
out(:,2)=[center(1)-new_half_side;center(2)-new_half_side;center(3)+new_half_side];
out(:,3)=[center(1)-new_half_side;center(2)+new_half_side;center(3)+new_half_side];
out(:,4)=[center(1)-new_half_side;center(2)+new_half_side;center(3)-new_half_side];

out(:,5)=[center(1)+new_half_side;center(2)-new_half_side;center(3)-new_half_side];
out(:,6)=[center(1)+new_half_side;center(2)-new_half_side;center(3)+new_half_side];
out(:,7)=[center(1)+new_half_side;center(2)+new_half_side;center(3)-new_half_side];
out(:,8)=[center(1)+new_half_side;center(2)+new_half_side;center(3)+new_half_side];

out(4,:)=new_half_side*ones(1,8);


end