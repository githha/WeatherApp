//
//  AppDelegate.h
//  WeatherApp
//
//  Created by tang bin on 13-4-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherQuery.h"
@class WeatherQuery;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WeatherQuery *wQuery;

@end
