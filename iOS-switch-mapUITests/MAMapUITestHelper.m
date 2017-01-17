//
//  MAMapUITestHelper.m
//  MAMapKit_3D_Test
//
//  Created by xiaoming han on 16/11/18.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "MAMapUITestHelper.h"

@implementation MAMapUITestHelper

#pragma mark - Helpers

+ (void)checkAlertWithTitleText:(nonnull NSString *)text cancelBtnText:(nonnull NSString *)cancelBtnText app:(nonnull XCUIApplication *)app test:(nonnull XCTestCase *)test success:(nonnull void(^)())success failure:(nonnull void(^)())failure {
    
    __block BOOL result = NO;
    
    if (app == nil || test == nil) {
        failure();
        return;
    }
    
    XCUIElement *alert = app.alerts[text];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == YES"];
    
    [test expectationForPredicate:exists evaluatedWithObject:alert handler:nil];
    
    [test waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        result = YES;
    }];
   
    
    [alert.buttons[cancelBtnText] tap];
    
    if (result) {
        success();
    } else {
        failure();
    }
}

+ (void)wait:(NSTimeInterval)seconds {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:seconds];
    [[NSRunLoop mainRunLoop] runUntilDate:date];
}

+ (void)handleUpdateWithApp:(nonnull XCUIApplication *)app
                       test:(nonnull XCTestCase *)test
{
    if (app == nil || test == nil)
    {
        return;
    }
    
//    软件更新
    XCUIElement *alert = app.alerts[@"\u8f6f\u4ef6\u66f4\u65b0"];
    
    BOOL result = [alert.staticTexts[@"\u8f6f\u4ef6\u66f4\u65b0"] exists];
    
    if (result)
    {
        [alert.buttons[@"\u7a0d\u540e"] tap];
        [alert.buttons[@"\u7a0d\u540e\u63d0\u9192\u6211"] tap];
    }
}

@end
