//
//  CLOLogMgr.m
//  CLOAlbum
//
//  Created by Cc on 2018/1/6.
//

#import "CLOLogMgr.h"
#import <mach/mach.h>

#if kSDKLog == 1
    #warning [Refactoring] 开启 kSDKLog = 1
#else
    #warning [Refactoring] 关闭 kSDKLog = 0
#endif


#if kSDKErrorLog == 1
    #warning [Refactoring] 开启 kSDKErrorLog = 1
#else
    #warning [Refactoring] 关闭 kSDKErrorLog = 0
#endif


#if kSDKAssertionLog == 1
    #warning [Refactoring] 开启 kSDKAssertionLog = 1
#else
    #warning [Refactoring] 关闭 kSDKAssertionLog = 0
#endif


#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


static BOOL sLogStatus = YES;
static BOOL sXcodeColorsEnable = NO;
static BOOL sLogUsePrintfEnable = NO;

@implementation CLOLogMgr

+ (void)sSetupLogStatus:(BOOL)state
{
    sLogStatus = state;
}
+ (void)sSetupXcodeColorsEnable:(BOOL)enable
{
    sXcodeColorsEnable = enable;
    if (enable) {
        
        NSLog(XCODE_COLORS_ESCAPE @"fg220,0,0;"
              XCODE_COLORS_ESCAPE @"bg255,255,255;"
              @"                                         "
              XCODE_COLORS_RESET);
        NSLog(XCODE_COLORS_ESCAPE @"fg220,0,0;"
              XCODE_COLORS_ESCAPE @"bg255,255,255;"
              @"            XCodeColors enable !         "
              XCODE_COLORS_RESET);
        NSLog(XCODE_COLORS_ESCAPE @"fg220,0,0;"
              XCODE_COLORS_ESCAPE @"bg255,255,255;"
              @"                                         "
              XCODE_COLORS_RESET);
    }
}
+ (void)sSetupLogUsePrintf:(BOOL)enable
{
    sLogUsePrintfEnable = enable;
}

+ (void)svSDKssLog:(NSString*)desc file:(NSString *)fileName lineNumber:(NSInteger)line selector:(SEL)selector title:(NSString *)title withColor:(NSString *)color
{
    if (sLogStatus) {
        
        NSString *strTitle = title.length > 0 ? title : @"SDK";
        
        NSString *strDesc = [NSString stringWithFormat:@"[%@] %@     < %@ ? %@ : %@ > \n "
                             , strTitle
                             , desc
                             , [fileName lastPathComponent]
                             , @(line)
                             , NSStringFromSelector(selector)];
        
        NSString *strColor = color ? color : @"12,151,210";
        [self.class sSDKPrintLog:strDesc withColor:strColor];
    }
}

+ (void)svSDKErrorsLog:(NSString*)desc file:(NSString *)fileName lineNumber:(NSInteger)line selector:(SEL)selector title:(NSString *)title
{
    if (sLogStatus) {
        
        NSString *strTitle = title.length > 0 ? title : @"SDK";
        NSString *strErr = [NSString stringWithFormat:@"< Error > :\n\t\t\t%@ \n\t\t< Error >", desc];
        NSString *strDesc = [NSString stringWithFormat:@"[%@]\n\t< %@ ? %@ : %@ >\n\t\t%@\n™\n "
                             , strTitle
                             , [fileName lastPathComponent]
                             , @(line)
                             , NSStringFromSelector(selector)
                             , strErr];
        
        NSString *strColor = @"190,4,124";
        [self.class sSDKPrintLog:strDesc withColor:strColor];
    }
}

+ (void)sSDKPrintLog:(NSString *)strDesc withColor:(NSString *)strColor
{
    BOOL isUsePrintf = NO;
    if (sXcodeColorsEnable) {
        
        if (sLogUsePrintfEnable) {
            
            isUsePrintf = YES;
        }
        else {
            
            NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET, strColor, strDesc);
        }
    }
    else {
        
        if (sLogUsePrintfEnable) {
            
            isUsePrintf = YES;
        }
        else {
            
            NSLog(@"%@", strDesc);
        }
    }
    
    if (isUsePrintf) {
        
        NSString *strTitle = nil;
        mach_timebase_info_data_t info;
        if (mach_timebase_info(&info) == KERN_SUCCESS) {
            
            uint64_t start = mach_absolute_time ();
            strTitle = [NSString stringWithFormat:@"%@ ... ", @(start)];
        }
        else {
            
            strTitle = @"..无法显示时间..";
        }
        printf("%s%s\n",[strTitle UTF8String], [strDesc UTF8String]);
    }
}

+ (void)sSDKErrorsLog:(SEL)selector
               object:(id)object
                 file:(NSString *)fileName
           lineNumber:(NSInteger)line
            withTitle:(NSString *)title
           withFormat:(NSString *)format, ...
{
    if (sLogStatus) {
        
        va_list argList;
        va_start(argList, format);
        NSString *desc = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
        
        [self svSDKErrorsLog:desc file:fileName lineNumber:line selector:selector title:title];
    }
}

+ (void)sSDKssLog:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line withTitle:(NSString *)title withColor:(NSString *)colorStr withFormat:(NSString *)format, ...
{
    if (sLogStatus) {
        
        va_list argList;
        va_start(argList, format);
        NSString *desc = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
        
        [self svSDKssLog:desc file:fileName lineNumber:line selector:selector title:title withColor:colorStr];
    }
}

@end
