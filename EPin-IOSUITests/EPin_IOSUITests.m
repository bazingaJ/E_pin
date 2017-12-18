//
//  EPin_IOSUITests.m
//  EPin-IOSUITests
//
//  Created by jeader on 16/3/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface EPin_IOSUITests : XCTestCase

@end

@implementation EPin_IOSUITests

- (void)setUp {
    [super setUp];
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = tablesQuery2;
    [[[[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:3] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] swipeUp];
    
    XCUIElement *staticText = [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:6] childrenMatchingType:XCUIElementTypeStaticText].element;
    [staticText tap];
    [[[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:7] childrenMatchingType:XCUIElementTypeStaticText].element swipeDown];
    
    XCUIElementQuery *tablesQuery2 = tablesQuery;
    [tablesQuery2.buttons[@"\U91d1\U878d"] tap];
    
    XCUIElement *staticText2 = [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:5] childrenMatchingType:XCUIElementTypeStaticText].element;
    [staticText2 swipeUp];
    [staticText2 swipeUp];
    [[[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:18] childrenMatchingType:XCUIElementTypeStaticText].element tap];
    [tablesQuery2.buttons[@"\U8d2d\U7269"] tap];
    
    XCUIElement *staticText3 = [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:9] childrenMatchingType:XCUIElementTypeStaticText].element;
    [staticText3 tap];
    [staticText3 tap];
    [staticText tap];
    [staticText2 tap];
    [[[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:19] childrenMatchingType:XCUIElementTypeStaticText].element swipeDown];
    [app.buttons[@"1"] tap];
    [[[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeStaticText].element tap];
    
    XCUIElement *cell = [[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1];
    XCUIElement *staticText4 = [cell childrenMatchingType:XCUIElementTypeStaticText].element;
    [staticText4 tap];
    [staticText4 swipeUp];
    [staticText4 tap];
    [app.buttons[@"2"] tap];
    [cell swipeUp];
    
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
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
