function [t_opt,corr] = globally_search_trans(point_3d,point_2d,v_3d,v_2d,epsilon,t_init)
%GLOBALLY_SEARCH Summary of this function goes here
%   Detailed explanation goes here
%t_opt=[0,0,0]';
% figure
% h_l=animatedline('color','red');
% h_u=animatedline('color','green');
% figure
% h_v=animatedline('color','green');
% title('volume')
% figure
% h_num=animatedline('color','green');
% title('number')


alpha_2d=acos(v_2d'*point_2d);

B=[];
Lower_bound=0;
Upper_bound=max([size(point_3d,2),size(point_2d,2)]);

best_branch=t_init; %[center,half_side]

Li(8)=0;
Ui(8)=0;

iter=1;

% pre_u=Upper_bound;
% pre_B=best_branch;
% now_u=0;

while(Upper_bound-Lower_bound>0)
    new_branch=Branch(best_branch);
    for ii=1:8
        [Li(ii),Ui(ii)]=get_bounds(new_branch(:,ii),point_3d,v_3d,alpha_2d,epsilon);
    end
    B=[B,[new_branch;Li;Ui]];
        
%     addpoints(h_v,iter,sum(8*B(end-2,:).^3));
%     addpoints(h_num,iter,size(B,2));
    
    [new_Lower_bound,ind_lower]=max(B(end-1,:));

    if(new_Lower_bound>Lower_bound)
        t_opt=B(1:3,ind_lower);
        Lower_bound=new_Lower_bound;
    end
    
    [Upper_bound,ind_best]=max(B(end,:));
    
    
    best_branch=B(1:4,ind_best);
    B(:,ind_best)=[];
    
    B(:,B(end,:)<Lower_bound)=[];


     
%     addpoints(h_l,iter,Lower_bound);
%     addpoints(h_u,iter,Upper_bound);
% 
%     drawnow
    iter=iter+1;
    
    if(Lower_bound==Upper_bound) %% exit...
        point_3d_tran=point_3d+t_opt;
        Length=vecnorm(point_3d_tran);
        beta_3d=acos(v_3d'*(point_3d_tran./Length));
        
        matching=abs(beta_3d'-alpha_2d)<=epsilon;
        corr=dmperm(matching>0);
%         disp('exit...')
        break;
    end
end


end

