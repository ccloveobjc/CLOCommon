//
//  NSData+CLOConvertToHex.m
//  CLOCommon
//
//  Created by Cc on 14/11/24.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "NSData+CLOConvertToHex.h"
#import "CLOLogHelper.h"

static const char c_strHexs[] = "0123456789ABCDEF";

@implementation NSData (CLOConvertToHex)

+ (NSString *)CLOConvertToHexString:(NSData *)dataHex
{
    NSMutableString *strHex = [[NSMutableString alloc] init];
    if (dataHex.length > 0) {
        
        NSData *dataS = dataHex;
        
        char e1 = 0xF0;
        char e2 = 0x0F;
        
        const char *pByte = dataS.bytes;
        for (int i = 0; i < dataS.length; ++i) {
            
            char s = *(pByte + i);
            char t1 = ((s & e1) >> 4);
            char s1 = t1 & 0x0F;
            char s2 = s & e2;
            [strHex appendFormat:@"%c%c", c_strHexs[s1], c_strHexs[s2]];
        }
    }
    else {
        
        SDKErrorLog(@"dataHex.length > 0    return NO");
    }
    
    return strHex.length > 0 ? strHex : nil;
}

+ (instancetype)CLOConvertHexStringToData:(NSString *)strHex
{
    if (strHex.length > 0) {
        
        strHex = [strHex uppercaseString];
        const char *pByte = [strHex UTF8String];
        size_t lengthB = strlen(pByte);
        
        if (lengthB % 2 == 0) {
            
            char chexs[3] = {'\0'};
            chexs[2] = '\0';
            NSMutableData * dataS = [NSMutableData data];
            for (int i = 0; i < lengthB; ++i) {
                
                chexs[0] = *(pByte + i);
                i++;
                chexs[1] = *(pByte + i);
                
                char d = strtoll(chexs, NULL, 16);
                
                [dataS appendBytes:&d length:1];
            }
            
            return dataS;
        }
        else {
            
            SDKErrorLog(@"lengthB %% 2 == 0   return NO");
        }
    }
    else {
        
        SDKErrorLog(@"strHex.length > 0   return NO");
    }
    
    return nil;
}

@end
