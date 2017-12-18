//
//  AppDelegate.h
//  EPin-IOS
//
//  Created by jeader on 16/3/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//个推
#import "GeTuiSdk.h"

#define kGtAppId           @"fBnpWiZYBU9zm1eZyGDZBA"
#define kGtAppKey          @"D23WtelaWfAJpZMGjxhKv1"
#define kGtAppSecret       @"W5NCAzV6Yv5b62d9HaNV34"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

