//
//  WaringView.m
//  WeatherApp
//
//  Created by tang bin on 13-4-16.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "WaringView.h"
#import <QuartzCore/QuartzCore.h>
@interface WaringView ()

@end

@implementation WaringView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.frame=[[UIScreen mainScreen] bounds];
    
    
    button=[UIButton  buttonWithType:UIButtonTypeCustom ];
    button.frame=CGRectMake(0, 0, 30, 30);
    button.backgroundColor=[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"back60.png"] forState:UIControlStateNormal];
    [button  addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside ];
    [self .view addSubview:button];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(32, 0, 80, 30)];
    label.text=@"天气提醒";
    // label.font=[UIFont boldSystemFontOfSize:12] ;
    label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:label];
    [label release];
    
    
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 100, 30)];
    label1.text=@"位置提醒";
    label1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:label1];
    [label1 release];
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(5, 140, 100, 30)];
    label2.text=@"短信提醒";
    label2.backgroundColor=[UIColor clearColor];
    [self.view addSubview:label2];
    [label2 release];
    
}
-(void)push
{
    if (self.view.superview) {
        // 准备动画
        CATransition *animation = [CATransition animation];
        //动画播放持续时间
        [animation setDuration:0.3f];
        //动画速度,何时快、慢
        [animation setTimingFunction:[CAMediaTimingFunction
                                      functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
        if (self.view.superview!=nil) {
            [self   .view removeFromSuperview];
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [button release];
    [super dealloc];
}
@end
