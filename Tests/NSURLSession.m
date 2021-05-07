//
//  ScHttp.m
//  Tests
//
//  Created by 宮田　雅元 on 2020/10/02.
//  Copyright © 2020 宮田　雅元. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScLog.h"

@interface NSURLSessionSimpleDelegate : NSObject<NSURLSessionDataDelegate>
    @property (nonatomic) dispatch_semaphore_t semaphore;
@end
@implementation NSURLSessionSimpleDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
                                  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    ScLog(@"%@", NSThread.currentThread);
    ScLog(@"----%@", response);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    ScLog(@"%@", NSThread.currentThread);
    ScLog(@"%@", data);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    ScLog(@"%@", NSThread.currentThread);
    ScLog(@"%@", error);
    dispatch_semaphore_signal(self.semaphore);
}
@end

@interface NSURLSessionMainDelegate : NSObject<NSURLSessionDataDelegate>
    @property (nonatomic) dispatch_semaphore_t semaphore;
@end
@implementation NSURLSessionMainDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
                                  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        ScLog(@"%@", NSThread.currentThread);
        ScLog(@"----%@", response);
    });
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ScLog(@"%@", NSThread.currentThread);
        ScLog(@"%@", data);
    });
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ScLog(@"%@", NSThread.currentThread);
        ScLog(@"%@", error);
    });
    dispatch_semaphore_signal(self.semaphore);
}
@end

@interface NSURLSessionTests : XCTestCase<NSURLSessionDataDelegate>
{
    @private
    dispatch_semaphore_t _semaphore;
    XCTestExpectation *_expection;
}
@end

@implementation NSURLSessionTests

- (void)testNonMainSimpleDelegate {
    ScLog(@"%@", NSThread.currentThread);
    NSURLSessionSimpleDelegate *deledate = [[NSURLSessionSimpleDelegate alloc] init];
    deledate.semaphore = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"https://www.google.co.jp/"]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:deledate
                                                     delegateQueue: nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
    ScLog(@"%@", dataTask);
    dispatch_semaphore_wait(deledate.semaphore, DISPATCH_TIME_FOREVER);
}

- (void)testNonMainMainDelegate {
    ScLog(@"%@", NSThread.currentThread);
    NSURLSessionMainDelegate *deledate = [[NSURLSessionMainDelegate alloc] init];
    deledate.semaphore = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"https://www.google.co.jp/"]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:deledate
                                                     delegateQueue: nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
    ScLog(@"%@", dataTask);
    dispatch_semaphore_wait(deledate.semaphore, DISPATCH_TIME_FOREVER);
}

- (void)testMainSimpleDelegate {
    ScLog(@"%@", NSThread.currentThread);
    NSURLSessionSimpleDelegate *deledate = [[NSURLSessionSimpleDelegate alloc] init];
    deledate.semaphore = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"https://www.google.com/"]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:deledate
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
    ScLog(@"%@", dataTask);
    dispatch_semaphore_wait(deledate.semaphore, DISPATCH_TIME_FOREVER);
}

- (void)testWithRequest{
    _expection = [self expectationWithDescription:@"UIDocument is opened."];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://example.com/"]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
//    _semaphore = dispatch_semaphore_create(0);
    [dataTask resume];
    
    NSLog(@"Start: %@", dataTask);
    
//    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    [self waitForExpectations:[NSArray arrayWithObject:_expection] timeout:12.0];
}

- (void)testWithURLString{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL: [NSURL URLWithString: @"https://www.google.com/"]];
    
    _semaphore = dispatch_semaphore_create(0);
    [dataTask resume];
    
    NSLog(@"Start %@", dataTask);
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

# pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
                                  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"didReceiveResponse: %@", NSThread.currentThread);
    NSLog(@"%@", response);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData: %@", NSThread.currentThread);
    NSLog(@"%@", data);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError: %@", NSThread.currentThread);
    NSLog(@"%@", error);
//    dispatch_semaphore_signal(_semaphore);
    [_expection fulfill];
}

@end
