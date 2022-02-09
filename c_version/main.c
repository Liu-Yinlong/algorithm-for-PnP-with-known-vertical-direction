
#include "main.h"

int main(int argc,char* argv[])
{
//    char* save_path_file="./data/synthetic_data/save.txt";
//    char* data_path_file="./data/synthetic_data/data_input.txt";
//    char* setting_path_file="./data/synthetic_data/setting.txt";


    char* data_path_file=argv[1];
    char* setting_path_file=argv[2];
    char* save_path_file=argv[3];

    clock_t start_tim,end_tim;//<---timer


    // Init (1) for input data

    unsigned int input_number;

    input_number=get_input_number(data_path_file);

    type_point_3d* const point_3d=(type_point_3d*)calloc(input_number,sizeof(type_point_3d));

    type_bear_vector* const bear_vector=(type_bear_vector*)calloc(input_number,sizeof(type_bear_vector));

    double v_3d[3]={0};
    double v_2d[3]={0};

    read_data(data_path_file,point_3d,bear_vector,v_3d,v_2d);

    // Init-(2) //for setting

    double epsilon=0.0175;

    type_tran_cube init_branch;

    read_setting(setting_path_file,&epsilon,&init_branch);

    //compute

    double opt_tran[3]={'\0'};
    double opt_r[9]={0};//<---------output


    start_tim = clock(); // start computing...


    globally_search(input_number,point_3d,bear_vector,v_3d,v_2d,&init_branch,epsilon,opt_tran );

    voting_estimate_R(input_number,point_3d,bear_vector,v_3d,v_2d,opt_tran,opt_r);

    end_tim = clock(); //end computing...

    free(point_3d);
    free(bear_vector);


    double tim=(double)(end_tim-start_tim)/(CLOCKS_PER_SEC/1000);

    write_result(save_path_file,opt_tran,opt_r,tim);

    return 0;
}
