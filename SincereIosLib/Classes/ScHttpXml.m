//
//  FcnApi.m
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/18.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScHttpXml.h"



@implementation ScHttpXml
- (void)loadingDidFinished:(NSURLSessionTask *)connection
{
    NSString *xmlString = [[NSString alloc]initWithData:_receivedData encoding:NSUTF8StringEncoding];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    [_delegate http:self connection:connection didFinishLoading:[doc rootElement]];
}

@end
