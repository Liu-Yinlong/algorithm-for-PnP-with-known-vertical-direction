#include "misc_func.h"

void get_bounds(unsigned int input_number,type_point_3d* point_3d_pointer,double * alpha_2d_pointer,
                double *v_3d,type_tran_cube *branch_pointer,double epsilon, unsigned int* bounds_pointer)
{
    bounds_pointer[0]=0;
    bounds_pointer[1]=0;

    double t_c[3]= {branch_pointer->tx,branch_pointer->ty,branch_pointer->tz};
    double radius=sqrt(3)*(branch_pointer->half_side);

    double temp_dot=0;

    double tran_x=0;
    double tran_y=0;
    double tran_z=0;

    double length_3d=0;
    double beta_3d=0;
    double diff=0;

    double delta=0;

    for(unsigned int i=0; i<input_number; i++)
    {
        tran_x=point_3d_pointer[i].x+t_c[0];
        tran_y=point_3d_pointer[i].y+t_c[1];
        tran_z=point_3d_pointer[i].z+t_c[2];

        temp_dot=v_3d[0]*tran_x+v_3d[1]*tran_y+v_3d[2]*tran_z;
        length_3d=sqrt(tran_x*tran_x+tran_y*tran_y+tran_z*tran_z);
        temp_dot=temp_dot/length_3d;
        temp_dot=temp_dot<=1? temp_dot : 1; // to avoid domain problem


        beta_3d=acos(temp_dot);
        diff=fabs(beta_3d-alpha_2d_pointer[i]);


        if(diff<=epsilon)
        {
            bounds_pointer[0]++;// lower bound
        }

        if(length_3d<=radius)
        {
            delta=M_PI*2; // to avoid too close case
        }
        else
        {
            delta=asin(radius/length_3d);
        }

        if(diff<=epsilon+delta)
        {
            bounds_pointer[1]++;// upper bound
        }
    }


    return;
}



unsigned int get_input_number(char* path_file)
{
    FILE *fpfile;
    unsigned int input_number=0;

    if((fpfile=fopen(path_file,"r"))==NULL)
    {
        printf("data file cannot be opened\n");
        exit(-1);
    }
    if(fscanf(fpfile,"%d",&input_number)==EOF)
    {
        printf("input number cannot be read\n");
        exit(-1);
    }
    //printf("Input number is :%d\n",input_number);
    fclose(fpfile);
    return input_number;
}

void read_setting(char* path_file,double*epsilon,type_tran_cube* init_branch)
{
    FILE *fpfile;

    if((fpfile=fopen(path_file,"r"))==NULL)
    {
        printf("setting file cannot be opened\n");
        exit(-1);
    }
    fscanf(fpfile,"%lf,%lf,%lf,%lf,%lf\n",
           epsilon,&(init_branch->tx),&(init_branch->ty),&(init_branch->tz),&(init_branch->half_side));

    fclose(fpfile);
    return;
}

void write_result(char* path_file,double*opt_t,double* opt_rot,double tim)
{
    FILE *fpfile;

    if((fpfile=fopen(path_file,"w"))==NULL)
    {
        printf("data file cannot be opened\n");
        exit(-1);
    }

    fprintf(fpfile,"%.10lf\t%.10lf\t%.10lf\t",opt_rot[0],opt_rot[1],opt_rot[2]);
    fprintf(fpfile,"%.10lf\t%.10lf\t%.10lf\t",opt_rot[3],opt_rot[4],opt_rot[5]);
    fprintf(fpfile,"%.10lf\t%.10lf\t%.10lf\t",opt_rot[6],opt_rot[7],opt_rot[8]);

    fprintf(fpfile,"%.10lf\t%.10lf\t%.10lf\t",opt_t[0],opt_t[1],opt_t[2]);

    fprintf(fpfile,"%lf\t",tim);

    fclose(fpfile);
    return ;
}

void read_data(char* path_file,type_point_3d* point_3d_pointer,type_bear_vector* bear_vector_pointer,double*v_3d,double*v_2d)
{
    FILE *fpfile;
    unsigned int input_number=0;

    if((fpfile=fopen(path_file,"r"))==NULL)
    {
        printf("data file cannot be opened\n");
        exit(-1);
    }

    if(fscanf(fpfile,"%d",&input_number)==EOF)
    {
        printf("input number cannot be read\n");
        exit(-1);
    }
    fscanf(fpfile,"%lf,%lf,%lf,%lf,%lf,%lf\n",&v_3d[0],&v_3d[1],&v_3d[2],&v_2d[0],&v_2d[1],&v_2d[2]);

    for(unsigned int i=0; i<input_number; i++)
    {
        //fscanf(fpfile, "%lf\t%lf\t%lf\t%lf\t%lf\t%lf\n",&(bear_vector.x),&(bear_vector.y),&(bear_vector.z),&(point_3d.x),&(point_3d.y),&(point_3d.z));
        fscanf(fpfile, "%lf\t%lf\t%lf\t%lf\t%lf\t%lf\n",
               &(bear_vector_pointer[i].x),&(bear_vector_pointer[i].y),&(bear_vector_pointer[i].z),
               &(point_3d_pointer[i].x),&(point_3d_pointer[i].y),&(point_3d_pointer[i].z));
    }

    fclose(fpfile);
    return;
}

void read_pose_gt(char* path_file,double *R_gt,double *t_gt, double *v_3d, double *v_2d)
{
    FILE *fpfile;

    if((fpfile=fopen(path_file,"r"))==NULL)
    {
        printf("pose file cannot be opened\n");
        exit(-1);
    }

    fscanf(fpfile,"%lf\t%lf\t%lf\n",&R_gt[0],&R_gt[1],&R_gt[2]);
    fscanf(fpfile,"%lf\t%lf\t%lf\n",&R_gt[3],&R_gt[4],&R_gt[5]);
    fscanf(fpfile,"%lf\t%lf\t%lf\n",&R_gt[6],&R_gt[7],&R_gt[8]);

    fscanf(fpfile,"%lf\t%lf\t%lf\n",&t_gt[0],&t_gt[1],&t_gt[2]);

    fscanf(fpfile,"%lf\t%lf\t%lf\n",&v_3d[0],&v_3d[1],&v_3d[2]);
    fscanf(fpfile,"%lf\t%lf\t%lf\n",&v_2d[0],&v_2d[1],&v_2d[2]);

    fclose(fpfile);
}


void print_3d_vector(double * vector_pointer)
{
    printf("%lf\t%lf\t%lf\n",vector_pointer[0],vector_pointer[1],vector_pointer[2]);
    return;
}

void print_Rot(double* Rot)
{
    //printf("rotation ground truth:\n");
    printf("%10.8lf\t%10.8lf\t%10.8lf\n",Rot[0],Rot[1],Rot[2]);
    printf("%10.8lf\t%10.8lf\t%10.8lf\n",Rot[3],Rot[4],Rot[5]);
    printf("%10.8lf\t%10.8lf\t%10.8lf\n",Rot[6],Rot[7],Rot[8]);
    return;
}


void globally_search(unsigned int input_number,type_point_3d* point_3d,type_bear_vector* bear_vector,double *v_3d,double*v_2d,
                     type_tran_cube *init_branch,double epsilon, double* opt_tran )
{
    //Init-(1)
    double* const alpha_2d =(double*)calloc(input_number,sizeof(double));
    double temp_dot=0;

    for(unsigned int i=0; i<input_number; i++)
    {
        temp_dot=v_2d[0]*bear_vector[i].x+v_2d[1]*bear_vector[i].y+v_2d[2]*bear_vector[i].z;
        temp_dot=temp_dot<=1? temp_dot : 1;
        alpha_2d[i]=acos(temp_dot);
    }
    //Init-(2)


    type_sub_branch* branch_pool_start=(type_sub_branch*)malloc(sizeof(type_sub_branch));
    branch_pool_start->branch_tran=*init_branch;
    branch_pool_start->next=NULL;
    branch_pool_start->previous=NULL;
    branch_pool_start->branch_lower=0;
    branch_pool_start->branch_upper=input_number;


    type_sub_branch* best_branch=branch_pool_start;


    //Init-(3)

    unsigned int global_L=0;
    unsigned int global_U=input_number;

    // unsigned int iter=1;

    type_tran_cube new_translation[8]= {'\0'};
    unsigned int estimate_bounds[2]= {'\0'};

    type_sub_branch* opt_branch=best_branch;
    while(global_L<global_U)
    {

        branching(best_branch->branch_tran,new_translation);

        for(unsigned int i=0; i<8; i++)
        {
            get_bounds(input_number,point_3d,alpha_2d,v_3d,&(new_translation[i]),epsilon, estimate_bounds);


            if(estimate_bounds[1]<global_L)
            {
                continue;
            }

            type_sub_branch* new_branch_pointer=(type_sub_branch*)malloc(sizeof(type_sub_branch));
            new_branch_pointer->previous=NULL;
            new_branch_pointer->next=NULL;
            new_branch_pointer->branch_upper=estimate_bounds[1];
            new_branch_pointer->branch_lower=estimate_bounds[0];
            new_branch_pointer->branch_tran=new_translation[i];

            if(estimate_bounds[0]>global_L)
            {
                opt_branch=new_branch_pointer;
                global_L=estimate_bounds[0];
            }


            branch_pool_start=add_sub_branch(branch_pool_start,new_branch_pointer);


        }

        branch_pool_start=delete_sub_branch(branch_pool_start,best_branch);


        best_branch=branch_pool_start;
        global_U=best_branch->branch_upper;

        //printf("%d,\t%d,\t%d\n",global_L,global_U,iter++);


    }

    opt_tran[0]=opt_branch->branch_tran.tx;
    opt_tran[1]=opt_branch->branch_tran.ty;
    opt_tran[2]=opt_branch->branch_tran.tz;
    free(alpha_2d);
    free_all_branches(branch_pool_start);
    return;
}


void branching(type_tran_cube given_branch,type_tran_cube *branch_tran_pointer)
{

    double new_half_side=0.5*given_branch.half_side;
    double t_x=given_branch.tx;
    double t_y=given_branch.ty;
    double t_z=given_branch.tz;

    for(unsigned int i=0; i<8; i++)
    {

        branch_tran_pointer[i].half_side=new_half_side;

        switch(i)
        {
        case 0:
            branch_tran_pointer[i].tx=t_x-new_half_side;
            branch_tran_pointer[i].ty=t_y-new_half_side;
            branch_tran_pointer[i].tz=t_z-new_half_side;
            break;
        case 1:
            branch_tran_pointer[i].tx=t_x-new_half_side;
            branch_tran_pointer[i].ty=t_y-new_half_side;
            branch_tran_pointer[i].tz=t_z+new_half_side;
            break;
        case 2:
            branch_tran_pointer[i].tx=t_x-new_half_side;
            branch_tran_pointer[i].ty=t_y+new_half_side;
            branch_tran_pointer[i].tz=t_z+new_half_side;
            break;
        case 3:
            branch_tran_pointer[i].tx=t_x-new_half_side;
            branch_tran_pointer[i].ty=t_y+new_half_side;
            branch_tran_pointer[i].tz=t_z-new_half_side;
            break;
        case 4:
            branch_tran_pointer[i].tx=t_x+new_half_side;
            branch_tran_pointer[i].ty=t_y-new_half_side;
            branch_tran_pointer[i].tz=t_z-new_half_side;
            break;
        case 5:
            branch_tran_pointer[i].tx=t_x+new_half_side;
            branch_tran_pointer[i].ty=t_y-new_half_side;
            branch_tran_pointer[i].tz=t_z+new_half_side;
            break;
        case 6:
            branch_tran_pointer[i].tx=t_x+new_half_side;
            branch_tran_pointer[i].ty=t_y+new_half_side;
            branch_tran_pointer[i].tz=t_z-new_half_side;
            break;
        case 7:
            branch_tran_pointer[i].tx=t_x+new_half_side;
            branch_tran_pointer[i].ty=t_y+new_half_side;
            branch_tran_pointer[i].tz=t_z+new_half_side;
            break;
        default:
            printf("something incorrect!");
            break;
        }
    }

    //print_list(sub_branches_pointer);

    return ;
}
void free_all_branches(type_sub_branch *branch_pointer)
{
    type_sub_branch *pNode=branch_pointer;

    while(pNode!=NULL)
    {
        branch_pointer=branch_pointer->next;
        free(pNode);
        pNode=branch_pointer;
    }
    return;
}

void print_list(type_sub_branch *branch_pointer)
{
    if(branch_pointer==NULL)
    {
        printf("***********none*******\n");
    }
    while(branch_pointer!=NULL)
    {
        printf("%10.5lf,\t %10.5lf,\t %10.5lf,\t %10.5lf,\t %10d,\t %10d\n",
               branch_pointer->branch_tran.tx,branch_pointer->branch_tran.ty,branch_pointer->branch_tran.tz,
               branch_pointer->branch_tran.half_side,branch_pointer->branch_lower,branch_pointer->branch_upper);

        branch_pointer=branch_pointer->next;
    }
    return;
}

type_sub_branch* add_sub_branch(type_sub_branch*branch_pool_start,type_sub_branch*new_branch_pointer)
{

    type_sub_branch* b_ptr=branch_pool_start;// add new branch
    if(branch_pool_start==NULL)
    {
        new_branch_pointer->previous=NULL;
        new_branch_pointer->next=NULL;

        return new_branch_pointer;
    }

    while(b_ptr!=NULL)
    {

        if((new_branch_pointer->branch_upper)<(b_ptr->branch_upper))
        {
            if(b_ptr->next==NULL)
            {
                b_ptr->next= new_branch_pointer;
                new_branch_pointer->previous=b_ptr;

                break;
            }
        }

        if((new_branch_pointer->branch_upper)>=b_ptr->branch_upper)
        {
            if(b_ptr->previous==NULL)
            {
                b_ptr->previous= new_branch_pointer;
                new_branch_pointer->next=b_ptr;
                branch_pool_start=new_branch_pointer;
                branch_pool_start->previous=NULL;

                break;
            }
            else
            {
                (b_ptr->previous)->next=new_branch_pointer;
                new_branch_pointer->previous=b_ptr->previous;
                new_branch_pointer->next=b_ptr;
                b_ptr->previous= new_branch_pointer;
                break;
            }

            break;
        }

        b_ptr=b_ptr->next;

    }

    return branch_pool_start;
}

type_sub_branch* delete_sub_branch(type_sub_branch*branch_pool_start,type_sub_branch *branch_pointer)
{
    if((branch_pointer->previous==NULL) &&(branch_pointer->next==NULL))
    {
        free(branch_pointer);
        branch_pointer=NULL;
        printf("It's empty!\n");
        getchar();
        return branch_pool_start;
    }
    if(branch_pointer->previous==NULL)//ͷ
    {
        //branch_pointer->previous->next=branch_pointer->next;
        branch_pool_start=branch_pointer->next;
        (branch_pointer->next)->previous=NULL;
        //printf("case-1\n");
        free(branch_pointer);

        return branch_pool_start;
    }
    if(branch_pointer->next==NULL)//β
    {
        (branch_pointer->previous)->next=NULL;
        //branch_pointer->next->previous=branch_pointer->previous;
        //printf("case-2\n");
        free(branch_pointer);
        return branch_pool_start;
    }
    (branch_pointer->previous)->next=branch_pointer->next;
    (branch_pointer->next)->previous=branch_pointer->previous;
    //printf("case-3\n");
    free(branch_pointer);
    return branch_pool_start;
}


void get_cross(double *a,double *b,double *c)
{
    c[0]=a[1]*b[2]-a[2]*b[1];
    c[1]=a[2]*b[0]-a[0]*b[2];
    c[2]=a[0]*b[1]-a[1]*b[0];
    return;
}
void make_unit(double*a)
{
    double length=0;
    length=sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]);
    a[0]=a[0]/length;
    a[1]=a[1]/length;
    a[2]=a[2]/length;
    return;
}
void make_exp_R(double*r,double angle,double *R)
{
    double sin_angle=sin(angle);
    double cos_angle=1.0-cos(angle);

    R[0]=1.0+cos_angle*(r[0]*r[0]-1.0);
    R[1]=-sin_angle*r[2]+cos_angle*r[0]*r[1];
    R[2]=sin_angle*r[1]+cos_angle*r[0]*r[2];

    R[3]=sin_angle*r[2]+cos_angle*r[0]*r[1];
    R[4]=1.0+cos_angle*(r[1]*r[1]-1.0);
    R[5]=-sin_angle*r[0]+cos_angle*r[1]*r[2];

    R[6]=-sin_angle*r[1]+cos_angle*r[0]*r[2];
    R[7]=sin_angle*r[0]+cos_angle*r[1]*r[2];
    R[8]=1.0+cos_angle*(r[2]*r[2]-1.0);
    return;
}


void multi_RR(double*a,double *b,double *c)
{
    c[0]=a[0]*b[0]+a[1]*b[3]+a[2]*b[6];
    c[1]=a[0]*b[1]+a[1]*b[4]+a[2]*b[7];
    c[2]=a[0]*b[2]+a[1]*b[5]+a[2]*b[8];

    c[3]=a[3]*b[0]+a[4]*b[3]+a[5]*b[6];
    c[4]=a[3]*b[1]+a[4]*b[4]+a[5]*b[7];
    c[5]=a[3]*b[2]+a[4]*b[5]+a[5]*b[8];

    c[6]=a[6]*b[0]+a[7]*b[3]+a[8]*b[6];
    c[7]=a[6]*b[1]+a[7]*b[4]+a[8]*b[7];
    c[8]=a[6]*b[2]+a[7]*b[5]+a[8]*b[8];
    return;
}
void voting_estimate_R(unsigned int input_number,type_point_3d* point_3d,type_bear_vector* bear_vector,
                       double *v_3d,double*v_2d,double*opt_tran,double *opt_r)
{

    double R_min[9]= {'\0'};
    double r_min[3]= {'\0'};
    double angle_min=0;

    make_unit(v_3d);
    make_unit(v_2d);
    angle_min=acos(v_3d[0]*v_2d[0]+v_3d[1]*v_2d[1]+v_3d[2]*v_2d[2]);

    get_cross(v_3d,v_2d,r_min);

    make_unit(r_min);


    make_exp_R(r_min,angle_min,R_min);

    //OK, we get R_min;


    double point_3d_tran[3]= {'\0'};
    double point_3d_Rt[3]= {'\0'};

    double m_3d[3]= {'\0'};
    double n_2d[3]= {'\0'};

    unsigned int voting_pool[BIN_NUM]= {0};
    double single_bin=2*M_PI/BIN_NUM;

    double angle_extend=0;
    double r_extend[3]= {'\0'};
    double R_extend[9]= {'\0'};

    unsigned int index=0;

    double p_3d[3]= {0};
    double b_2d[3]= {0};

    for(unsigned int ii=0; ii<input_number; ii++)
    {
        p_3d[0]=point_3d[ii].x;
        p_3d[1]=point_3d[ii].y;
        p_3d[2]=point_3d[ii].z;

        b_2d[0]=bear_vector[ii].x;
        b_2d[1]=bear_vector[ii].y;
        b_2d[2]=bear_vector[ii].z;

        point_3d_tran[0]=p_3d[0]+opt_tran[0];
        point_3d_tran[1]=p_3d[1]+opt_tran[1];
        point_3d_tran[2]=p_3d[2]+opt_tran[2];


        point_3d_Rt[0]=R_min[0]*point_3d_tran[0]+R_min[1]*point_3d_tran[1]+R_min[2]*point_3d_tran[2];
        point_3d_Rt[1]=R_min[3]*point_3d_tran[0]+R_min[4]*point_3d_tran[1]+R_min[5]*point_3d_tran[2];
        point_3d_Rt[2]=R_min[6]*point_3d_tran[0]+R_min[7]*point_3d_tran[1]+R_min[8]*point_3d_tran[2];


        get_cross(point_3d_Rt,v_2d,m_3d);
        make_unit(m_3d);
        get_cross(b_2d,v_2d,n_2d);
        make_unit(n_2d);

        angle_extend=acos(m_3d[0]*n_2d[0]+m_3d[1]*n_2d[1]+m_3d[2]*n_2d[2]);

        get_cross(m_3d,n_2d,r_extend);

        if(r_extend[0]*v_2d[0]+r_extend[1]*v_2d[1]+r_extend[2]*v_2d[2]<0)
        {
            angle_extend=2*M_PI-angle_extend;
        }

        index=floor(angle_extend/(single_bin));//<------------counting bin
        voting_pool[index]++;


    }


    unsigned int max_count_angle=0;
    index=0;
    max_count_angle=voting_pool[0];

    for(unsigned int ii=0; ii<BIN_NUM; ii++)
    {
        if(max_count_angle<voting_pool[ii])
        {
            max_count_angle=voting_pool[ii];
            index=ii;
        }
    }

    angle_extend=single_bin*(index+0.5);
    make_exp_R(v_2d,angle_extend,R_extend);


    multi_RR(R_extend,R_min,opt_r);

    return;
}


