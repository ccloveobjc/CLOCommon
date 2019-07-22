//
//  CLOLogHelper.h
//  CLOCommon
//
//  Created by Cc on 2018/1/6.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define kSDKLog             1
    #define kSDKErrorLog        1
    #define kSDKAssertionLog    1
#else
    #define kSDKLog             0
    #define kSDKErrorLog        0
    #define kSDKAssertionLog    0
#endif

////1  直接断言，  0 断言提示
//#define kSDKAssertEnable 1

//输出日志
#if kSDKLog == 1
    #define SDKLogT(title,fmt, ...) [CLOLogHelper sSDKssLog:_cmd \
                                                                                                                object:self \
                                                                                                                file:[NSString stringWithUTF8String:__FILE__] \
                                                                                                                lineNumber:__LINE__ \
                                                                                                                withTitle:title \
                                                                                                                withColor:nil \
                                                                                                                withFormat:(fmt), ##__VA_ARGS__];

    #define SDKLog(fmt, ...) SDKLogT(nil,fmt, ##__VA_ARGS__)

#else
    #define SDKLog(fmt, ...)
#endif

//错误时断言，并输出日志
#if kSDKErrorLog == 1
    #define SDKErrorLog(fmt, ...) [CLOLogHelper sSDKErrorsLog:_cmd \
                                                                                                                    object:self \
                                                                                                                    file:[NSString stringWithUTF8String:__FILE__] \
                                                                                                                    lineNumber:__LINE__ \
                                                                                                                    withTitle:nil \
                                                                                                                    withFormat:(fmt), ##__VA_ARGS__];
#else
    #define SDKErrorLog(fmt, ...)
#endif

//错误时断言，并输出日志
#if kSDKAssertionLog == 1
    #define SDKAssertionLog(condition, desc, ...) \
        do {                \
        __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        if (!(condition)) { \
        if (desc.length > 0) { \
        [CLOLogHelper sSDKErrorsLog:_cmd \
        object:self \
        file:[NSString stringWithUTF8String:__FILE__] \
        lineNumber:__LINE__ \
        withTitle:nil \
        withFormat:(desc), ##__VA_ARGS__]; \
        } \
        [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd \
        object:self \
        file:[NSString stringWithUTF8String:__FILE__] \
        lineNumber:__LINE__ \
        description:(desc), ##__VA_ARGS__]; \
        } \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
        } while(0);
#else
    #define SDKAssertionLog(condition, desc, ...)
#endif

#define SDKAssert SDKAssertionLog(NO, @"")

#define SDKAssertElseLog(desc, ...) else{ SDKErrorLog(desc, ##__VA_ARGS__); SDKAssertionLog(NO, desc, ##__VA_ARGS__) }

#define SDKAssertAndReturnNO SDKAssert;return NO;

#define SDKAssertAndBreak SDKAssert;break;

@interface CLOLogHelper : NSObject

/**
 *  设置 YES 开始日志，默认YES
 *  NO 关闭日志
 *  ⚠️： kSDKLog ＝ 1 kSDKErrorLog ＝1 kSDKAssertionLog ＝ 1 的时候才会起效
 */
+ (void)sSetupLogStatus:(BOOL)state;
+ (void)sSetupLogUsePrintf:(BOOL)enable;


+ (void)sSDKssLog:(nonnull SEL)selector
           object:(nullable id)object
             file:(nonnull NSString *)fileName
       lineNumber:(NSInteger)line
        withTitle:(nullable NSString *)title
        withColor:(nullable NSString *)colorStr
       withFormat:(nonnull NSString *)format, ... NS_FORMAT_FUNCTION(7,8);


+ (void)sSDKErrorsLog:(nonnull SEL)selector
               object:(nullable id)object
                 file:(nonnull NSString *)fileName
           lineNumber:(NSInteger)line
            withTitle:(nullable NSString *)title
           withFormat:(nonnull NSString *)format, ... NS_FORMAT_FUNCTION(6,7);

@end
