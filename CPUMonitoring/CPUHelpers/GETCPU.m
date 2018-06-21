////
////  GETCPU.m
////  CPUMonitoring
////
////  Created by John Allen on 6/18/18.
////  Copyright © 2018 jallen.studios. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "GETCPU.h"
//
//@interface CPUStuff: NSObject {
//    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
//    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
//    unsigned _numCPUs;
//    NSLock *_cpuUsageLock;
//}
//
//- (void)getCPU {
//    int _mib[2U] = { CTL_HW, HW_NCPU };
//    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
//    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
//    if(_status)
//        _numCPUs = 1;
//    
//    _cpuUsageLock = [[NSLock alloc] init];
//    
//    natural_t _numCPUsU = 0U;
//    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
//    if(err == KERN_SUCCESS) {
//        [_cpuUsageLock lock];
//        
//        for(unsigned i = 0U; i < _numCPUs; ++i) {
//            Float32 _inUse, _total;
//            if(_prevCPUInfo) {
//                _inUse = (
//                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
//                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
//                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
//                          );
//                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
//            } else {
//                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
//                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
//            }
//            
//            NSLog(@"Core : %u, Usage: %.2f%%", i, _inUse / _total * 100.f);
//        }
//        
//        [_cpuUsageLock unlock];
//        
//        if(_prevCPUInfo) {
//            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
//            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
//        }
//        
//        _prevCPUInfo = _cpuInfo;
//        _numPrevCPUInfo = _numCPUInfo;
//        
//        _cpuInfo = nil;
//        _numCPUInfo = 0U;
//    } else {
//        NSLog(@"Error!");
//    }
//    
//    return;
//    
//
//    }
//
//
//@end
//
//
