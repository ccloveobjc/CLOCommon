//
//  UIAlertController+pg_common.m
//  Pods
//
//  Created by Cc on 2017/7/8.
//
//

#import "UIAlertController+CLOCommonUI.h"
#import <objc/runtime.h>

@implementation UIAlertController (CLOCommonUI)

+ (instancetype)CLOGotAlertController:(NSDictionary *)titleParams
                         withOkParams:(NSDictionary *)okParams
                     withCancelParams:(NSDictionary *)cancelParams
{
    NSString *title = titleParams[@"title"];
    NSString *msg = titleParams[@"msg"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelParams) {
        
        NSString *cancelTitle = cancelParams[@"title"];
        void (^cancelBlock)(UIAlertAction *action) = cancelParams[@"click"];
        UIAlertActionStyle style = UIAlertActionStyleCancel;
        if (cancelParams[@"UIAlertActionStyle"]) {
            
            style = [cancelParams[@"UIAlertActionStyle"] integerValue];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:style handler:cancelBlock];
        [alertController addAction:cancelAction];
    }
    
    if (okParams) {
        
        NSString *okTitle = okParams[@"title"];
        void (^okBlock)(UIAlertAction *action) = okParams[@"click"];
        void (^okTitleBlock)(UIAlertController* ctr, UIAlertAction *action) = okParams[@"titleClick"];
        NSString *titleName = okParams[@"titleName"];
        if (titleName) {
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                
                textField.placeholder = titleName;
            }];
        }
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (okParams[@"UIAlertActionStyle"]) {
            
            style = [okParams[@"UIAlertActionStyle"] integerValue];
        }
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:style handler:^(UIAlertAction * _Nonnull action) {
            
            if (okBlock) {
                
                okBlock(action);
            }
            if (okTitleBlock) {
                
                okTitleBlock(alertController, action);
            }
        }];
        [alertController addAction:okAction];
    }
    
    return alertController;
}

@end
