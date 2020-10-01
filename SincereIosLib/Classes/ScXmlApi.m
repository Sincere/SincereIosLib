//
//  FcApi.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/07.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScXmlApi.h"

@implementation ScXmlApi

@synthesize runningThread = _runningThread;

- (id)initWithUri:(NSString *)uri handlerName:(NSString *)handlerName
{
    self = [super init];
    
    if (self)
    {
        _uri = uri;
        _params = [[NSMutableDictionary alloc]init];
        _handlerName = handlerName;
        self.maxThreadCount = 1;
        self.pageName = @"pid";
    }
    
    return self;
}

- (void)start
{
    _progress = 0;
    _runningThread = 0;
    _restPageCount = 0;
    [self loadStart:nil];
}

- (void) setParam: (id)params forKey: (NSString *)key
{
    [_params setObject:params forKey:key];
}

#pragma mark - ScXmlApiHandlerDelegate

- (void)http:(ScHttp *)http handlerDidFinish:(ScXmlApiHandler *)handler
{
    @synchronized(self)
    {
        ++_endCount;
    }
    
    if(_endCount == _maxPageCount)
    {
        [self.delegate apiDidFinish:self];
    }
}

- (void)http:(ScHttp *)http handler:(ScXmlApiHandler *)handler didFailWithCode:(NSString *)code message:(NSString *)message
{
    [self.delegate api:self didFailWithCode:code message:message];
}

- (void)http:(ScHttp *)http handler:(ScXmlApiHandler *)handler incrementProgress:(double)progress
{
    @synchronized(self)
    {
        _progress += progress;
    }
    
    [self.delegate api:self progress:_progress];
}

- (void)http:(ScHttp *)http handler:(ScXmlApiHandler *)handler didLoadWithPagePath:(ScPagePath *)pagePath
{
    if(pagePath.index == 1)
    {
        _restPageCount = pagePath.length - 1;
        _maxPageCount = pagePath.length;
        
        if([pagePath hasMore])
        {
            for (int i=0; i<self.maxThreadCount; i++)
            {
                NSString *pid = [self popPageId];
                if(pid != nil)
                {
                    ScHttpXml *request = [[ScHttpXml alloc]initWithUri:_uri delegate:handler];
                    for (NSString *key in _params)
                    {
                        [request setParam:[_params objectForKey:key] forKey:key];
                    }
                    
                    [request setParam:pid forKey: self.pageName];
                    [self loadHttp:request];
                }
            }
        }
    }
    else
    {
        _maxPageCount = pagePath.length;
        NSString *pid = [self popPageId];
        
        if(pid != nil)
        {
            [http setParam:pid forKey: self.pageName];
            [self loadHttp:http];
        }
    }
    
    @synchronized(self)
    {
        --_runningThread;
    }
}

- (void)http:(ScHttp *)http handlerWillStart:(ScXmlApiHandler *)handler
{
    
}

#pragma mark - private
- (void)loadHttp:(ScHttp *)http
{
    [http load];
    @synchronized(self)
    {
        ++_runningThread;
    }
}

- (NSString *)popPageId
{
    @synchronized(self)
    {
        if(_restPageCount == 0)
        {
            return nil;
        }
        else
        {
            NSString *pid = [NSString stringWithFormat:@"%d", (int)(_maxPageCount - _restPageCount) + 1];
            --_restPageCount;
            
            return pid;
        }
    }
}

- (void)loadStart:(NSString *)pid
{
    ScXmlApiHandler *handler = [[NSClassFromString(_handlerName) alloc] init];
    ScLog(@"%@", handler);
    NSAssert1(handler != nil, @"Missing %@ class", _handlerName);
    
    handler.delegate = self;
    ScHttpXml *request = [[ScHttpXml alloc]initWithUri:_uri delegate:handler];
    [request setHttpMethod:@"POST"];
    for (NSString *key in _params)
    {
        [request setParam:[_params objectForKey:key] forKey:key];
    }
    
    if(pid)
    {
        [request setParam:pid forKey:self.pageName];
    }
    
    [self loadHttp:request];
}
@end
