//
//  py_reverse_debugger.c
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/5/31.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#include "py_reverse_debugger.h"

#include <sys/stat.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <unistd.h>
#import "fishhook.h"


//原始函数的地址
int (*sysctl_p)(int *, u_int, void *, size_t *, void *, size_t);

//自定义函数
int py_sysctl(int *name, u_int namelen, void *info, size_t *infosize, void *newinfo, size_t newinfosize){
    if (namelen == 4
        && name[0] == CTL_KERN
        && name[1] == KERN_PROC
        && name[2] == KERN_PROC_PID
        && info
        && (int)*infosize == sizeof(struct kinfo_proc))
    {
        int err = sysctl_p(name, namelen, info, infosize, newinfo, newinfosize);
        //拿出info做判断
        struct kinfo_proc * myInfo = (struct kinfo_proc *)info;
        if((myInfo->kp_proc.p_flag & P_TRACED) != 0){
            //使用异或取反
            myInfo->kp_proc.p_flag ^= P_TRACED;
        }
        return err;
    }
    
    return sysctl_p(name, namelen, info, infosize, newinfo, newinfosize);
}
int py_sysctl_reverse_debugger(void){
    return rebind_symbols((struct rebinding[1]){{"sysctl",py_sysctl,(void *)&sysctl_p}}, 1);
}
