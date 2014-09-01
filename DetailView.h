//
//  DetailView.h
//  WeatherApp
//
//  Created by tang bin on 13-4-15.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfo.h"
@interface DetailView : UIView
{
    UILabel *_statelabel;
    UILabel *_wDlabel;
    UILabel * _windlabel;
    UILabel *_wDfwlable;
    UILabel *  _airlable;
}

@property int curentView;
@property(nonatomic,retain) WeatherInfo *infoSource;

-(void)reloadView:(WeatherInfo *)info;
@end
