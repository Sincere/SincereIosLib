//
//  ScHttp.m
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/22.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScHttp.h"

@implementation ScHttp

- (id) initWithUri: (NSString *) uri;
{
    self = [super init];
    if (self != nil)
    {
        _autoloadWaiting = NO;
        _receivedData = [[NSMutableData alloc] init];
        _baseUri = uri;
        _params = [[NSMutableDictionary alloc] init];
        self.timeout = 8;
    }
    
    return self;
}

- (id) initWithUri: (NSString *) uri delegate: (id<ScHttpDelegate>) delegate
{
    self = [self initWithUri:uri];
    if (self != nil)
    {
        _delegate = delegate;
    }
    
    return self;
}

- (void) enableAutoLoad: (NSTimeInterval) sec
{
    _autoloadSec = sec;
}

- (void) setHttpMethod: (NSString *) method
{
    _httpMethod = [method uppercaseString];
}

- (void) load
{
    @synchronized(self)
    { 
        if(_autoloadWaiting)
        {
            if([(NSObject *)_delegate respondsToSelector:@selector(endAutoLoadWait)])
            {
                [_delegate endAutoLoadWait];
            }
            
            _autoloadWaiting = NO;
        }
        
        //クエリに変更がなければアクセスの必要なし
        //クエリの並び替えは下のisEqualAsQueryStringでやってる・・微妙かも
        NSString *query = [self buildParameters];
        if(_prevQuery != nil)
        {
            if ([query isEqualAsQueryString:_prevQuery])
            {
                _prevQuery = query;
                return;
            }
        }
        
        _prevQuery = query;
        
        //リセット
        [_currentConnection cancel];
        
        //リクエスト初期化
        ScLog(@"Init request: %@ %@ %@", _httpMethod, _baseUri, query);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: _baseUri]];
        if(_httpMethod)
        {
            [request setHTTPMethod:_httpMethod];
        }
        
        if([request.HTTPMethod isEqualToString:@"POST"])
        {
            NSData *httpBody = [query dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[httpBody length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: httpBody];
        }
        else
        {
            request.URL = [request.URL URLByAppendingQueryString:query];
        }
        
        //リクエストスタート
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                              delegate:self
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
        
        [dataTask resume];
    }
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
                                  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    ScLog(@"Start load %@ : post[%@]", [dataTask currentRequest], [[NSString alloc] initWithData:[[dataTask currentRequest]HTTPBody] encoding:NSUTF8StringEncoding]);
    _totalBytes = [response expectedContentLength];
    _loadedBytes = 0.0;

    if(_progressView)
    {
        [_progressView setProgress:_loadedBytes];
    }

    [_receivedData setLength:_loadedBytes];
    [_delegate http:self connection:dataTask didReceiveResponse:response];

    // Need this for continue to `didReceiveData` and `didCompleteWithError`
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    ScLog(@"didReceiveData: %@", data);
    
    _loadedBytes += [data length];
    double progress = _loadedBytes/_totalBytes;
    
    if(_progressView)
    {
        [_progressView setProgress:(progress)];
    }
    
    [_delegate http:self connection:dataTask progress:progress];
    
    [_receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error)
    {
        ScLog(@"didCompleteWithError: %@", error);
        [_delegate http:self connection:task didFailWithError:error];
    }
    else
    {
        ScLog(@"didCompleteWithoutError: %@", _receivedData);
        if(_progressView)
        {
            [_progressView setProgress:1.0];
        }
        
        [self loadingDidFinished:task];
    }
}

#pragma mark - private
- (NSString*)buildParameters
{
    NSMutableString *strParams = [NSMutableString string];
    
    NSString *key;
    for ( key in _params ) {
        id value = [_params objectForKey:key];
        if([value isKindOfClass:[NSArray class]])
        {
            for (id val in value)
            {
                [strParams appendFormat:@"%@[]=%@&", key, [val stringUrlEncoded]];
            }
        }
        else if(value)
        {
            [strParams appendFormat:@"%@=%@&", key, [value stringUrlEncoded]];
        }
    }
    
    //最後の&を消す
    if ( [strParams length] > 0 )
    {
        [strParams deleteCharactersInRange:NSMakeRange([strParams length]-1, 1)];
    }
    
    return strParams;
}

- (id) paramForKey:(NSString *)key
{
    return [_params objectForKey:key];
}



- (void) setProgressBar: (UIProgressView *) progress
{
    _progressView = progress;
}

- (void) setParam: (id)params forKey: (NSString *)key
{
    bool change = NO;
    id cParams = [params copy];
    
    id currentValue = [_params objectForKey: key];
    
    if(currentValue == nil)
    {
        if(cParams != nil && ![cParams isEqual:@""])
        {
            change = YES;
        }
    }
    else if([currentValue isKindOfClass:[NSArray class]])
    {
        if(![cParams isKindOfClass:[NSArray class]])
        {
            change = YES;
        }
        else if([currentValue count] != [cParams count])
        {
            change = YES;
        }
        else
        {
            currentValue = [currentValue sortedArrayUsingSelector:@selector(compare:)];
            cParams = [cParams sortedArrayUsingSelector:@selector(compare:)];
            for (int i = 0; i < [currentValue count]; i++)
            {
                if(![[currentValue objectAtIndex:i] isEqual:[cParams objectAtIndex:i]])
                {
                    change = YES;
                    break;
                }
            }
        }
    }
    else
    {
        change = ![currentValue isEqual:cParams];
    }
    
    if(change)
    {
        if(cParams != nil)
        {
            [_params setObject:cParams forKey:key];
        }
        else
        {
            [_params removeObjectForKey:key];
        }
        
        [self onChangeParameterFrom:currentValue to: cParams on: key];
    }
}

- (void) removeParam:(NSString *)key
{
    id currentValue = [_params objectForKey:key];
    if(currentValue != nil)
    {
        [_params removeObjectForKey:key];
        [self onChangeParameterFrom:currentValue to: nil on: key];
    }
}

- (NSArray *) arrayForKey: (NSString *) key
{
    id value = [_params objectForKey:key];
    if([value isKindOfClass:[NSArray class]])
    {
        return (NSArray *)value;
    }
    
    NSArray *array = [[NSArray alloc] initWithObjects:value, nil];
    return array;
}

- (NSString *) stringForKey: (NSString *) key
{
    id value = [_params objectForKey:key];
    if([value isKindOfClass:[NSArray class]])
    {
        [NSException raise:@"ScHasMultipleValueException" format:@"[%@] has multiple values.", key];
    }
    
    return (NSString *) value;
}

- (void) onChangeParameterFrom:(id) currentValue to:(id) newValue on:(id) key
{
    if(_autoloadSec > 0)
    {
        if(_autoloadWaiting == NO)
        {
            if([(NSObject *)_delegate respondsToSelector:@selector(startAutoLoadWait)])
            {
                [_delegate startAutoLoadWait];
            }
            
            _autoloadWaiting = YES;
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(load) object:nil];
        [self performSelector:@selector(load) withObject:nil afterDelay: _autoloadSec];
    }
}

- (void)loadingDidFinished:(NSURLSessionTask *)connection
{
    [_delegate http:self connection: connection didFinishLoading:_receivedData];
}

@end
