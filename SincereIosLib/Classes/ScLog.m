//
//  ScLog.c
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/11/05.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScLog.h"
#import "mach/mach.h"

NSString* ScStringFromBOOL(BOOL value)
{
    return value ? @"YES" : @"NO";
}

void ScMemoryReport()
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in MB): %lu", (unsigned long)info.resident_size / 1024 / 1024);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}
