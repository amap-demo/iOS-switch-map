//
//  MAMapUITestHelper.h
//  MAMapKit_3D_Test
//
//  Created by xiaoming han on 16/11/18.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#define kBackButtonTitle @"3D-Test"

@interface MAMapUITestHelper : NSObject

+ (void)checkAlertWithTitleText:(nonnull NSString *)text cancelBtnText:(nonnull NSString *)cancelBtnText app:(nonnull XCUIApplication *)app test:(nonnull XCTestCase *)test success:(nonnull void(^)())success failure:(nonnull void(^)())failure;

+ (void)wait:(NSTimeInterval)seconds;

/// 处理系统升级的alert
+ (void)handleUpdateWithApp:(nonnull XCUIApplication *)app test:(nonnull XCTestCase *)test;

@end
