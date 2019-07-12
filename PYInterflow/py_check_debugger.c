//
//  py_check_debugger.c
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/5/31.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#include "py_check_debugger.h"

#import <dlfcn.h>
#import <sys/types.h>

#include <sys/stat.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <unistd.h>


typedef int  (*ptrace_ptr_t)(int _request,pid_t pid,caddr_t _addr,int _data);
#ifndef PT_DENY_ATTACH
#define PT_DENY_ATTACH 31
#endif

void py_ptrace_check_debugger(void){
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}
int py_sysctl_check_debugger(void) {
    int name[4];
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    info.kp_proc.p_flag = 0;
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    if(sysctl(name,4,&info,&info_size,NULL,0) == -1){
        return 1;
    }
    return (info.kp_proc.p_flag & P_TRACED) ? 1 : 0;
}

void py_stop_debugger(void){
    asm(
        "mov X0,#0\n"
        "mov w16,#1\n"
        "svc #0x80"
        );

}
