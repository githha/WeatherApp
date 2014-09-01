//
//  TabbarView.m
//  WeatherApp
//
//  Created by tang bin on 13-4-17.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "TabbarView.h"
#import <QuartzCore/QuartzCore.h>
@implementation TabbarView

@synthesize supview;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mapView= [[MapView alloc] init] ;
        stupView= [[StupView alloc] init] ;
        waringView= [[WaringView alloc] init] ; 
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//地图按钮
    mapButton=[UIButton  buttonWithType:UIButtonTypeCustom ];
    mapButton.frame=CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height);
    mapButton.backgroundColor=[UIColor clearColor];
    mapButton.tag=1;
    [mapButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
    [mapButton  addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside ];
    [self  addSubview:mapButton];
//设置按钮    
    stupButton=[UIButton  buttonWithType:UIButtonTypeCustom ];
    stupButton.frame=CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height);
    stupButton.backgroundColor=[UIColor clearColor];
    stupButton.tag=2;
    [stupButton setImage:[UIImage imageNamed:@"stup.png"] forState:UIControlStateNormal];
    [stupButton  addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside ];
    [self  addSubview:stupButton];
    
//提醒按钮    
    waringButton=[UIButton  buttonWithType:UIButtonTypeCustom ];
    waringButton.frame=CGRectMake( self.frame.size.width/3*2,0, self.frame.size.width/3, self.frame.size.height);
    waringButton.backgroundColor=[UIColor clearColor];
    waringButton.tag=3;
    [waringButton setImage:[UIImage imageNamed:@"waring.png"] forState:UIControlStateNormal];
    [waringButton  addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside ];
    [self  addSubview:waringButton];
}
-(void)push:(id)sender
{
    NSLog(@"点击按钮......");
    NSLog(@"supView:::::::::%p",supview);
    UIButton *button=(UIButton *)sender;
    // 准备动画
    CATransition *animation = [CATransition animation];
    //动画播放持续时间
    [animation setDuration:0.3f];
    //动画速度,何时快、慢
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseIn]];
    /*动画效果
     (
     kCATransitionFade淡出|
     kCATransitionMoveIn覆盖原图|
     kCATransitionPush推出|
     kCATransitionReveal底部显出来
     )
     */
    [animation setType:kCATransitionPush];
    /*动画方向
     (
     kCATransitionFromRight|
     kCATransitionFromLeft|
     kCATransitionFromTop|
     kCATransitionFromBottom
     )
     */
    [animation setSubtype:kCATransitionFromRight];
    [supview.view.layer addAnimation:animation forKey:@"Reveal"];

    if (button.tag==1&&mapView.view.superview == nil)
    {
        [supview.view addSubview:mapView.view];
    }
    if (button.tag==2&&stupView.view.superview == nil)
    {
        [supview.view addSubview:stupView.view];
    }
    if (button.tag==3&&waringView.view.superview == nil)
    {
        [supview.view addSubview:waringView.view];
    }
}

-(void)dealloc
{
    [mapButton release];
    [stupButton release];
    [waringButton release];
    [supview release];
    [mapView release];
    [waringView release];
    [stupView release];
    [super dealloc  ];
}
@end
