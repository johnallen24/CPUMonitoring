//
//  AMDevice.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import "AMUtils.h"
#import "HardcodedDeviceData.h"
#import "CPUInfoController.h"
#import "CPUInfo.h"
#import "AMDevice.h"
#import "CPUMonitoring-Swift.h"

@interface AMDevice()
// Overriden

@property (nonatomic, strong) CPUInfo        *cpuInfo;
@property (nonatomic, strong) CPUInfoController        *cpuInfoCon;

@property (nonatomic, copy)   NSArray        *processes;

@end

@implementation AMDevice
@synthesize cpuInfo;

@synthesize processes;


- (id)init
{
    if (self = [super init])
    {
        // Warning: since we rely a lot on hardcoded data, hw.machine must be retrieved
        // before everything else!
        NSString *hwMachine = [AMUtils getSysCtlChrWithSpecifier:"hw.machine"];
        HardcodedDeviceData *hardcodeData = [HardcodedDeviceData sharedDeviceData];
        [hardcodeData setHwMachine:hwMachine];
    
       
        cpuInfo = _cpuInfoCon.getCPUInfo;
       

    }
    return self;
}



- (CPUInfo*)getCpuInfo
{
    return cpuInfo;
}

- (NSArray*)getProcesses
{
    return processes;
}

#pragma mark - public

- (void)refreshStorageInfo
{
   
}

@end
