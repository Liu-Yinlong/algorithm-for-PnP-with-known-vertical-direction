#!/usr/bin/python

import os

import numpy as np
from scipy.linalg import expm


def creat_R(r, angle):
    r_time = np.zeros((3, 3))

    r_time[0, 1] = -r[2]
    r_time[0, 2] = r[1]

    r_time[1, 0] = r[2]
    r_time[1, 2] = -r[0]

    r_time[2, 0] = -r[1]
    r_time[2, 1] = r[0]

    R = expm(r_time*angle)

    return R


def gen_data(input_num, outlier_rate, noise_level, data_file_name):
    number_outlier = int(input_num*outlier_rate)
    # number_inlier=input_num-number_outlier

    ####=========genarate 3d point ============#########
    point_3d = np.random.uniform(-1, 1, (3, input_num)) * \
        100+np.array([0, 0, 150]).reshape(3, 1)

    ##=======genarate R_gt and t_gt========########
    r_ = np.random.uniform(-1, 1, (3, 1))

    r = np.true_divide(r_, np.linalg.norm(r_))

    angle = np.random.uniform(-np.pi, np.pi)

    R_gt = creat_R(r, angle)

    t_gt = -np.mean(point_3d, axis=1).reshape(3, 1)

    ###======genarate 2d bear vector========#####

    bear_vector_ = np.dot(R_gt, point_3d+t_gt)

    length = np.sqrt(np.sum(bear_vector_*bear_vector_, axis=0))

    bear_vector = np.true_divide(bear_vector_, length)

    # ========mismatches=======================

    mismatches_ = np.random.uniform(-1, 1, (3, number_outlier))

    length = np.sqrt(np.sum(mismatches_*mismatches_, axis=0))
    mismatches = np.true_divide(mismatches_, length)

    bear_vector[..., 0:number_outlier] = mismatches

    # ==========add noise=====================

    point_3d = point_3d+np.random.uniform(-1, 1, (3, input_num))*noise_level

    # ========V_3d,V_2d===============

    v_3d_ = np.random.uniform(-1, 1, (3, 1))
    v_3d = np.true_divide(v_3d_, np.linalg.norm(v_3d_))

    v_2d = np.dot(R_gt, v_3d)

    # ====save data=======================

    file_object = open(data_file_name, 'w')
    file_object.write('%s\n' % input_num)

    str_second = '%.10f,%.10f,%.10f,%.10f,%.10f,%.10f\n' % (
        v_3d[0], v_3d[1], v_3d[2], v_2d[0], v_2d[1], v_2d[2])
    file_object.write(str_second)

    for ii in range(input_num):
        str_ = '%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\n' % (
            bear_vector[0, ii], bear_vector[1, ii], bear_vector[2, ii], point_3d[0, ii], point_3d[1, ii], point_3d[2, ii])
        file_object.write(str_)

    file_object.close()

    # =====return====
    return R_gt, t_gt


if __name__ == '__main__':

    input_num = 1000
    outlier_rate = 0.2
    noise_level = 0.1

    epsilon = 0.0175
    init_trans = [0, 0, 0, 500]  # <---[center,radius]

    data_file_name = './data.txt'
    setting_file_name = './setting.txt'
    save_file_name = './save.txt'

    file_object = open(setting_file_name, 'w')
    file_object.write('%.10f,%.10f,%.10f,%.10f,%.10f\n' % (
        epsilon, init_trans[0], init_trans[1], init_trans[2], init_trans[3]))
    file_object.close()

    [R_gt, t_gt] = gen_data(input_num, outlier_rate,
                            noise_level, data_file_name)


    cmd = './G_PnP %s %s %s' % (
        data_file_name, setting_file_name, save_file_name)

    os.system(cmd)

    results = np.loadtxt(save_file_name)

    opt_R = results[0:9].reshape(3, 3)
    opt_t = results[9:12].reshape(3, 1)
    tim = results[-1]

    error_r = np.arccos(0.5*(np.trace(np.dot(opt_R, R_gt.T))-1))
    error_t = np.linalg.norm(opt_t-t_gt)

    print('rotation error is %.3f (deg)'%(error_r/np.pi*180))
    print('trans error is %.3f'%error_t)
    print('run time is %d (ms)'%(int(tim)))
