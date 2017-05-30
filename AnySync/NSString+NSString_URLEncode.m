//
//  NSString+NSString_URLEncode_h.m
//  extenFun
//
//  Created by CmST0us on 17/5/9.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "NSString+NSString_URLEncode.h"

@implementation NSString (NSString_URLEncode)
int urlEncode(char *dest, const char *src, int maxSrcSize)
{
    static const char *hex = "0123456789ABCDEF";
    
    int len = 0;
    
    if (src) while (*src) {
        if (++len > maxSrcSize) {
            *dest = 0;
            return 0;
        }
        unsigned char c = *src;
        if (isalnum(c) ||
            (c == '-') || (c == '_') || (c == '.') || (c == '!') ||
            (c == '~') || (c == '*') || (c == '\'') || (c == '(') ||
            (c == ')') || (c == '/')) {
            *dest++ = c;
        }
        else if (*src == ' ') {
            *dest++ = '+';
        }
        else {
            *dest++ = '%';
            *dest++ = hex[c >> 4];
            *dest++ = hex[c & 15];
        }
        src++;
    }
    
    *dest = 0;
    
    return 1;
}

- (NSString *)URLEncodedString{

    void *s = malloc([self length] * 3 + 1);
    memset(s, 0, [self length]);
    urlEncode(s, [self cStringUsingEncoding:NSUTF8StringEncoding], (int)[self length] * 3 + 1);
    NSString *urlencodeString = [[NSString alloc]initWithCString:s encoding:NSUTF8StringEncoding];
    free(s);
    return urlencodeString;
}
@end
