//
//  TabbarView.h
//  WeatherApp
//
//  Created by tang bin on 13-4-17.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "StupView.h"
#import "WaringView.h"
#import "WeatherQuery.h"




@class WeatherQuery;
@interface TabbarView : UIView
{
   MapView*mapView;
   StupView*stupView;
   WaringView*waringView;
   UIButton *mapButton;
   UIButton *stupButton;
   UIButton *waringButton;
}
@property(nonatomic,retain) WeatherQuery *supview;
@end
