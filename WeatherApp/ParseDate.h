//
//  ParseDate.h
//  WeatherApp
//
//  Created by tang bin on 13-4-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "WeatherInfo.h"
@interface ParseDate : NSObject<NSXMLParserDelegate>{

    NSMutableData *weatherData;  //获取的原始xml数据
	NSMutableArray *weatherArray;	//解析后的数据,选取值数组
	NSMutableString *tempString;	//解析中用到的临时数组
    int state;
    
    NSArray *_cityArray;
    
}


@property  int state;
@property  int iscomplet;
@property (nonatomic, retain)   NSMutableArray *dateSource;
@property (nonatomic, retain) NSMutableString *tempString;
@property (nonatomic, retain) NSArray *cityArray;

-(void)request:(NSString *)name;
-(void)requestWeather:(NSArray *)citys;
-( NSArray *)getData:(NSString *)cityName;
@end
