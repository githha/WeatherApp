//
//  DetailView.m
//  WeatherApp
//
//  Created by tang bin on 13-4-15.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView
@synthesize curentView;
@synthesize infoSource;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)reloadView:(WeatherInfo *)info
{
    NSLog(@"reloadView。。。。。。。。。。");
    
    if (info) {
        NSLog(@"info.todaystate:::%@",info.todaystate);
         NSLog(@"info.temperature::::%@",info.temperature);
         NSLog(@"info.temfw::::%@",info.temfw);
         NSLog(@"info.windinfo:::%@",info.windinfo);
         NSLog(@"airinfo::::%@",info.airinfo);
        
        
        _statelabel.text=info.todaystate;
        _wDlabel.text=info.temperature;
        _windlabel.text=info.windinfo;
        _airlable.text=info.airinfo;
    }
    
    
   
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"drawRect。。。。。。。。");
    if (infoSource) {
        NSLog(@"infoSource。。。。不为空....");
        NSLog(@"infoSource.todaystate::%@",infoSource.todaystate);
        NSLog(@"infoSource.temperature::%@",infoSource.temperature);
        NSLog(@"infoSource.windinfo:::%@",infoSource.windinfo);
          NSLog(@"airinfo::::%@",infoSource.airinfo);
        
        //给lable 赋值
        _statelabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 120,30)];
        _statelabel.text=[infoSource todaystate];
        _statelabel.font=[UIFont boldSystemFontOfSize:19];
        _statelabel.textAlignment=NSTextAlignmentLeft;
        _statelabel.textColor=[UIColor whiteColor];
        _statelabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_statelabel];
       
        
        _wDlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 55,40)];
        _wDlabel.text=[infoSource temperature];
        _wDlabel.font=[UIFont boldSystemFontOfSize:24];
        _wDlabel.textAlignment=NSTextAlignmentLeft;
        _wDlabel.backgroundColor=[UIColor clearColor];
        _wDlabel.textColor=[UIColor whiteColor];
        [self addSubview:_wDlabel];
        
        
        
        _wDfwlable   =[[UILabel alloc] initWithFrame:CGRectMake(65, 33, 100,20)];
        _wDfwlable.text=[infoSource temfw];
          _wDfwlable.font=[UIFont boldSystemFontOfSize:12];
        _wDfwlable.textAlignment=NSTextAlignmentLeft;
        _wDfwlable.backgroundColor=[UIColor clearColor];
        _wDfwlable.textColor=[UIColor whiteColor];
        [self addSubview:_wDfwlable];
       
        
        
        
        _windlabel   =[[UILabel alloc] initWithFrame:CGRectMake(65, 47, 100,20)];
        _windlabel.text=[infoSource windinfo];
        _windlabel.font=[UIFont boldSystemFontOfSize:12];
        _windlabel.textAlignment=NSTextAlignmentLeft;
        _windlabel.backgroundColor=[UIColor clearColor];
        _windlabel.textColor=[UIColor whiteColor];
        [self addSubview:_windlabel];
        
        
        
        
        UILabel *lable   =[[UILabel alloc] initWithFrame:CGRectMake(240, 12, 80,20)];
        lable .text=@"空气质量";
        lable.numberOfLines=5;
        lable.textAlignment=NSTextAlignmentLeft;
          lable.font=[UIFont boldSystemFontOfSize:12];
        //_airlable.lineBreakMode= UILineBreakModeWordWrap;
        
        lable.backgroundColor=[UIColor clearColor];
        lable.textColor=[UIColor whiteColor];
        [self addSubview:lable];
        [lable release];
        
       
        _airlable   =[[UILabel alloc] initWithFrame:CGRectMake(240, 32, 80,20)];
        _airlable .text=[infoSource airinfo];
         _airlable.font=[UIFont boldSystemFontOfSize:12];
        _airlable.numberOfLines=5;
        _airlable.textAlignment=NSTextAlignmentLeft;
        //_airlable.lineBreakMode= UILineBreakModeWordWrap;
        
        _airlable.backgroundColor=[UIColor clearColor];
        _airlable.textColor=[UIColor whiteColor];
        [self addSubview:_airlable];
    }
}



-(void)dealloc
{
    [_statelabel release];
    [_windlabel release];
    [_airlable  release];
    [_wDlabel release];
    [_wDfwlable release];
    [infoSource release];
    [super dealloc];
}
@end
