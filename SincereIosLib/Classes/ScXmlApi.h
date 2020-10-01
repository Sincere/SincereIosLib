//
//  FcApi.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/07.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScHttpXml.h"
#import "ScLog.h"
#import "ScXmlApiHandler.h"

#pragma mark - ScXmlApiDelegate
@class ScXmlApi;
@protocol ScXmlApiDelegate

- (void)apiDidFinish:(ScXmlApi *)api;
- (void)api:(ScXmlApi *)api didFailWithCode:(NSString *)code message:(NSString *)message;
- (void)api:(ScXmlApi *)api progress:(double)progress;

@end

#pragma mark - ScXmlApi
@interface ScXmlApi : NSObject<ScXmlApiHandlerDelegate>
{
    @private
    NSString *_uri;
    NSMutableDictionary *_params;
    NSString *_handlerName;
    double _progress;
    NSInteger _endCount;
    NSInteger _runningThread;
    NSInteger _restPageCount;
    NSInteger _maxPageCount;
}

@property (nonatomic, strong) id<ScXmlApiDelegate>delegate;
@property (nonatomic, assign) NSInteger maxThreadCount;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, readonly) NSInteger runningThread;

- (id)initWithUri:(NSString *)uri handlerName:(NSString *)handlerName;
- (void)setParam:(id)params forKey: (NSString *)key;
- (void)start;

@end



