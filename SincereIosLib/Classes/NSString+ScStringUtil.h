//
//  NSString+ScStringUtil.h
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/25.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ScStringUtil)
- (NSString*)stringUrlEncoded;
- (BOOL)isEqualAsQueryString:(NSString *)queryString;
- (NSArray *)componentsSeparatedByLength:(NSInteger)length;
- (NSString *)ucfirst;
@end
