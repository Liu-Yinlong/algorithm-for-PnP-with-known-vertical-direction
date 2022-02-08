#ifndef MISC_FUNC_H_INCLUDED
#define MISC_FUNC_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct //2d数据类型
{
    double x;
    double y;
    double z;
} type_bear_vector;

typedef struct //3d数据类型
{
    double x;
    double y;
    double z;
} type_point_3d;

typedef struct //trans数据类型
{
    double tx;
    double ty;
    double tz;

    double half_side;

} type_tran_cube;

typedef struct sub_branch//branch数据类型
{

    type_tran_cube branch_tran;

    unsigned int branch_lower;

    unsigned int branch_upper;

    struct sub_branch *previous;
    struct sub_branch *next;

} type_sub_branch;



#define BIN_NUM 360

unsigned int get_input_number(char* path_file);
void read_data(char* path_file,type_point_3d* point_3d_pointer,type_bear_vector* bear_vector_pointer,double*v_3d,double*v_2d);

void read_setting(char* path_file,double*epsilon,type_tran_cube* init_branch);


void branching(type_tran_cube given_branch,type_tran_cube *branch_tran_pointer);
void free_all_branches(type_sub_branch *branch_pointer);

type_sub_branch* add_sub_branch(type_sub_branch*branch_pool_start,type_sub_branch*new_branch_pointer);
type_sub_branch* delete_sub_branch(type_sub_branch*branch_pool_start,type_sub_branch *branch_pointer);


void get_bounds(unsigned int input_number,type_point_3d* point_3d_pointer,double * alpha_2d_pointer,
                double *v_3d,type_tran_cube *branch_pointer,double epsilon, unsigned int* bounds_pointer);

void globally_search(unsigned int input_number,type_point_3d* point_3d,type_bear_vector* bear_vector,double *v_3d,double*v_2d,
                     type_tran_cube *init_branch,double epsilon, double* opt_tran );

void voting_estimate_R(unsigned int input_number,type_point_3d* point_3d,type_bear_vector* bear_vector,double *v_3d,double*v_2d,double*opt_tran,double *opt_r);


void write_result(char* path_file,double*opt_t,double* opt_rot,double tim);





#endif // MISC_FUNC_H_INCLUDED
