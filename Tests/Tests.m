//
//  Tests.m
//  Tests
//
//  Created by 宮田　雅元 on 2020/10/01.
//  Copyright © 2020 宮田　雅元. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScLog.h"
#import "ScColor.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    ScLog(@"----%@", ScColor.defaultLabelColor);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end