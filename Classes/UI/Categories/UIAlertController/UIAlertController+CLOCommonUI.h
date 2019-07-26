//
//  UIAlertController+CLOCommonUI.h
//  CLOCommon
//
//  Created by Cc on 2017/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (CLOCommonUI)

/**
 创建一个对象

UIAlertController *vc = [UIAlertController CLOGotAlertController:@{
        @"title": @"title",
        @"msg": @"description",
    } withOkParams:@{
        @"title": @"buttonTitle",
        @"UIAlertActionStyle": @(UIAlertActionStyleDestructive),
        @"click": ^(UIAlertAction * _Nonnull action) {
        },
        @"titleClick": ^(UIAlertController* ctr, UIAlertAction * _Nonnull action) {
        },
    } withCancelParams:@{
        @"title": @"buttonTitle",
        @"click": ^(UIAlertAction * _Nonnull action) {
 
        },
}];
[self presentViewController:vc animated:YES completion:nil];
 
 @param titleParams  参数
 @param okParams 参数
 @param cancelParams 参数
 @return 对象
 */
+ (instancetype)CLOGotAlertController:(NSDictionary *)titleParams
                         withOkParams:(nullable NSDictionary *)okParams
                     withCancelParams:(nullable NSDictionary *)cancelParams;

@end

NS_ASSUME_NONNULL_END
