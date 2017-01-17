//
//  iOS_switch_mapUITests.m
//  iOS-switch-mapUITests
//
//  Created by eidan on 17/1/17.
//  Copyright © 2017年 autonavi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAMapUITestHelper.h"

@interface iOS_switch_mapUITests : XCTestCase

@end

@implementation iOS_switch_mapUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    //获得高德地图
    XCUIElement *elementAMap = [[[[[[[[XCUIApplication alloc] init] childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    
    sleep(1);
    
    [elementAMap swipeDown];
    
    [MAMapUITestHelper checkAlertWithTitleText:@"是否切换到苹果地图显示" cancelBtnText:@"确定" app:app test:self success:^{
        
        sleep(1);
        
         XCUIElement *elementAppleMap = [[[[[[[[XCUIApplication alloc] init] childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0];
        
        [elementAppleMap swipeUp];
        
        [MAMapUITestHelper checkAlertWithTitleText:@"是否切换到高德地图显示" cancelBtnText:@"确定" app:app test:self success:^{
            
            sleep(3);
            
        } failure:^{
            XCTAssert(@"没有切换到高德地图，失败");
        }];
       
        
    } failure:^{
        XCTAssert(@"没有切换到苹果地图，失败");
    }];
    
}

@end
