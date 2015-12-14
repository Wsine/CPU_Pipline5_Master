/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000003860501976_1069848932_init();
    work_m_00000000000310307794_1983727358_init();
    work_m_00000000001992604532_2533970755_init();
    work_m_00000000000014102809_1709928648_init();
    work_m_00000000003517188371_2642130041_init();
    work_m_00000000003097753568_2012543288_init();
    work_m_00000000001475057741_3508565487_init();
    work_m_00000000002954374525_2231816521_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000002954374525_2231816521");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
