//
//  FcApiHander.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/09.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScXmlApiHandler.h"

@implementation ScXmlApiHandler

-(NSError *)createErrorWithCode:(NSString*)code message:(NSString *)message
{
    return [NSError errorWithDomain:@"ScXmlApiError" code:[code intValue] userInfo: @{NSLocalizedDescriptionKey: message}];
}

#pragma mark - ScHttpDelegate
- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didFinishLoading:(id)response
{
    NSError *error = [self errorInXmlElement:response http:http];
    if(error)
    {
        [self http:http didFailWithCode:[NSString stringWithFormat:@"%ld", (long)error.code] message:[error localizedDescription]];
    }
    else
    {
        ScPagePath *pagePath = [self createPagePathWithXmlElement:response http:http];
        
        [self.delegate http:http handler:self didLoadWithPagePath:pagePath];
        
        [self.delegate http:http handlerWillStart:self];
        
        @synchronized(self)
        {
            [self handleXmlElement:response pagePath:pagePath http:http];
        }
        
        [self.delegate http:http handlerDidFinish:self];
    }
}

- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self http:http didFailWithCode:@"9999" message:[NSString stringWithFormat:@"%ld : %@", (long)[error code], [error localizedDescription]]];
}

- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection progress:(double)progress
{
    
}

#pragma mark - abstract - protected

-(void)handleXmlElement:(DDXMLDocument *)rootElement pagePath:(DDXMLElement *)pagePath http:(ScHttp *)http 
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
}

-(ScPagePath *)createPagePathWithXmlElement:(DDXMLElement *)rootElement http:(ScHttp *)http
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

-(NSError *)errorInXmlElement:(DDXMLElement *)rootElement http:(ScHttp *)http
{
    return nil;
}

#pragma mark - pivate
- (void)http:(ScHttp *)http didFailWithCode:(NSString *)code message:(NSString *)message;
{
    [self.delegate http:http handler:self didFailWithCode:code message:message];
}
@end
