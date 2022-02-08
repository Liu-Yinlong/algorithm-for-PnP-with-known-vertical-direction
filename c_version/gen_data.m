function [R_gt,t_gt]=gen_data(input_number,outlier_rate,noise_level,data_file_name)
  
  number_outlier=round(input_number*outlier_rate);
  %number_inlier=input_number-number_outlier;
  
  %==========generate 3D point===============
  
  point_3d=(rand(3,input_number)*2-1)*100+[0;0;150];
  
  %=======generate t_gt==================
  
  t_gt=-mean(point_3d,2);
  
  %=========generate R_gt==========
  r_=rand(3,1)*2-1;
  r=r_./norm(r_);
  
  angle=rand(1)*2*pi-pi;
  
  r_time=[0 -r(3) r(2);r(3) 0 -r(1);-r(2) r(1) 0];
  
  R_gt=expm(r_time*angle);
  
  %=========generate 2D bear vector============
  
  point_trans=R_gt*(point_3d+t_gt);
  
  bear_2d=point_trans./vecnorm(point_trans);
  
  %==========mismatches==============
  if(number_outlier>0)
    outlier_=rand(3,number_outlier);
    outlier=outlier_./vecnorm(outlier_);
    bear_2d(:,1:number_outlier)=outlier;  
  end
  %=========add noise=========
  point_3d=point_3d+randn(3,input_number)*noise_level;
  
  %================3D  vertical=====
  v_3d_=rand(3,1)*2-1;
  v_3d=v_3d_./norm(v_3d_);
  %=================2D vertical========
  v_2d=R_gt*v_3d;
  
  %=====save file===========
  
  dlmwrite (data_file_name, input_number); 
  
  dlmwrite (data_file_name, [v_3d',v_2d'], "delimiter", ",", "-append");
 
  dlmwrite (data_file_name, [bear_2d',point_3d'], "delimiter", "\t", "-append"); 
  
end
