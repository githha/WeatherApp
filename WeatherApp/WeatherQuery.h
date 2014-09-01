//
//  WeatherQuery.h
//  WeatherApp
//
//  Created by tang bin on 13-4-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParseDate.h"
#import "DetailView.h"
#import "TabbarView.h"
@class ParseDate;
@class TabbarView;
@interface WeatherQuery : UIViewController<UIScrollViewDelegate>
{
    UIPageControl* _pageControl;
    UIScrollView *_scrollView;
   
     NSMutableArray *_citys;
   

}
@property(nonatomic,retain)  NSMutableArray *citys;



@property(nonatomic,retain) UILabel *city;
@property(nonatomic,retain)UILabel *  time;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)UIScrollView *scrollView;



@property (strong, nonatomic)ParseDate*parse;
@property(retain,nonatomic)TabbarView *tabbarview;
@property(strong,nonatomic)DetailView *detail;

@end
