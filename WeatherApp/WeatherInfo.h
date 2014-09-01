//
//  WeatherInfo.h
//  WeatherApp
//
//  Created by tang bin on 13-4-16.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherInfo : NSManagedObject

@property (nonatomic, retain) NSString * citycode;
@property (nonatomic, retain) NSDate * creattime;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDecimalNumber * state;
@property (nonatomic, retain) NSString * temfw;
@property (nonatomic, retain) NSString * temperature;
@property (nonatomic, retain) NSString * todaystate;
@property (nonatomic, retain) NSString * uptime;
@property (nonatomic, retain) NSString * windinfo;
@property (nonatomic, retain) NSString * airinfo;
@property (nonatomic, retain) NSString * lineinfo;
@property (nonatomic, retain) NSString * warterinfo;
@property (nonatomic, retain) NSString * threedayinfo;
@property (nonatomic, retain) NSString * detailInfo;

@end
