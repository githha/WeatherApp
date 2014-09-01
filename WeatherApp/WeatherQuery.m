//
//  WeatherQuery.m
//  WeatherApp
//
//  Created by tang bin on 13-4-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "WeatherQuery.h"
#import <QuartzCore/QuartzCore.h>


@interface WeatherQuery ()

@end

@implementation WeatherQuery
@synthesize pageControl=_pageControl;
@synthesize scrollView=_scrollView;
@synthesize citys=_citys;
@synthesize city,time;
@synthesize parse;
@synthesize detail;
@synthesize tabbarview;
static int hight=30;
static int currentPage=0;
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
//设置 当前view的背景颜色和图片
    self.view.backgroundColor=[UIColor clearColor];
    self.view.layer.contents=(id)[[UIImage imageNamed:@"defult1.png"] CGImage];
  
    
//初始。。。。。数据源和   请求解析类........
    _citys=[[NSMutableArray alloc] initWithObjects:@"北京",@"上海",@"广州",@"深圳", nil];
    parse=[[ParseDate alloc] init];

//加载顶部 标签.......城市和发布时间............
    city=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, hight)];
    city.text=[_citys  objectAtIndex:0];
    city.font=[UIFont boldSystemFontOfSize:18];
    city.textAlignment=NSTextAlignmentLeft;
    city.backgroundColor=[UIColor clearColor];
    city.textColor=[UIColor whiteColor];
    [self.view addSubview:city];
    
    time=[[UILabel alloc] initWithFrame:CGRectMake(215, 0, 110,hight)];
    time.text=@"更新中....";
    time.font=[UIFont boldSystemFontOfSize:12];
    time.backgroundColor=[UIColor clearColor];
    time.textColor=[UIColor whiteColor];
    time.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:time];
   
    
//加载。。。。。。pagecontrol........
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(5, 30, 65, 10)];
    _pageControl.numberOfPages=[_citys count];
    
    if ([_citys count]==0) {
        _pageControl.hidden=YES;
    }
    _pageControl.currentPage=0;
    _pageControl.backgroundColor=[UIColor  clearColor];
    [_pageControl addTarget:self action:@selector(Change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    //加载line
    UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(72, 34, 320-72-5, 2)];
    line.backgroundColor=[UIColor grayColor];//[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    line.alpha=0.5f;
    [self   .view addSubview:line];
    [line release];
    
    
//加载.....scrollview...........
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40)];
    _scrollView.contentSize=CGSizeMake([_citys count] * 320.0f, self.scrollView.frame.size.height);
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate=self;
    _scrollView.backgroundColor=[UIColor clearColor];
    
     [self.view addSubview:_scrollView];
    
//加载。。。。tabbarview。。。
    tabbarview=[[TabbarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    tabbarview.supview=self;
    [self.view addSubview:tabbarview];
    

    
//判断最后一次发布时间 和当前时间差小于15分钟  就读库  否则重新请求
    [self isRequest];
        
}

-(void)viewDidAppear:(BOOL)animated;
{
    NSLog(@"viewDidAppear。。。。。。");
}




//视图切换...从底部向上显示APIMethod
-(void)SwitchView
{
    // 准备动画
    CATransition *animation = [CATransition animation];
    //动画播放持续时间
    [animation setDuration:0.25f];
    //动画速度,何时快、慢
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseIn]];
    if (1==1)
    {
      //  self.showViewController.view.superview == nil
        //  动画方向
        //  [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp
        //       forView:self.view cache:YES];
        /*动画效果
         (
         kCATransitionFade淡出|
         kCATransitionMoveIn覆盖原图|
         kCATransitionPush推出|
         kCATransitionReveal底部显出来
         )
         */
        [animation setType:kCATransitionReveal];
        /*动画方向
         (
         kCATransitionFromRight|
         kCATransitionFromLeft|
         kCATransitionFromTop|
         kCATransitionFromBottom
         )
         */
        [animation setSubtype:kCATransitionFromBottom];
        [self.view.layer addAnimation:animation forKey:@"Reveal"];
        //[saveViewController.view removeFromSuperview];
     //  [self.view insertSubview:showViewController.viewatIndex:0];
    }
    else
    {
        //  动画方向
        //  [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown
        //     forView:self.view  cache:YES];
        /*动画效果
         (
         suckEffect三角|
         rippleEffect水波|
         pageCurl上翻页|
         pageUnCurl下翻页|
         oglFlip上下翻转|
         )
         */
        [animation setType:@"suckEffect"];
        //开始动画
        [self.view.layer addAnimation:animation forKey:@"suckEffect"];
        //[showViewController.view removeFromSuperview];
        //[self.view insertSubview:saveViewController.view atIndex:0];
    }
}




-(void)isRequest
{
    
    NSArray *arr= [parse getData:[_citys objectAtIndex:_pageControl.currentPage]];
    if ([arr count]>0) {
        WeatherInfo *info=[arr objectAtIndex:0];
        NSDateFormatter *formate=[[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"有数据....最后创建时间%@",info.creattime);
        
        NSDate *updateT= [info creattime] ;//应该是 创建时间.......
        NSDate *date=[NSDate date];//[NSDate dateWithTimeInterval:8*60*60 sinceDate:[NSDate date]];
        int mins=[date timeIntervalSinceDate:updateT]/60;
        
        NSLog(@"最后更新时间：%@",updateT);
        NSLog(@"当前时间：%@",[NSDate date]);
        NSLog(@"mins======%d",mins);
        [formate release];
        if(mins>15)//请求
        {
            //请求完毕后。。。调用updateUI
            [parse request:[_citys objectAtIndex:_pageControl.currentPage]];
            [NSThread detachNewThreadSelector:@selector(RunLoopWaite)  toTarget:self  withObject:nil];
            
        }else
        {
            [self updateUI];//查库....1，有数据更新ui  2,没数据更新标签。。
        }
    }else
    {
        [parse request:[_citys objectAtIndex:_pageControl.currentPage]];
        [NSThread detachNewThreadSelector:@selector(RunLoopWaite)  toTarget:self  withObject:nil];
    }
}



-(void)RunLoopWaite
{
    while (parse.iscomplet==0) {
         [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture] ];
    }
    //判断state 有多个城市时
    if (parse.iscomplet ==1) {//成功
        NSLog(@"入库成功");
    }
    if (parse.iscomplet==2) {//失败
        NSLog(@"失败");//请求失败....
    }
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
}


-(void)Change:(id)sender
{
    UIPageControl *pageC=(UIPageControl *)sender;
    int whichPage = pageC.currentPage;
    NSLog(@"whichPage：%d",whichPage);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [_scrollView setContentOffset:CGPointMake(320.0f * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
}
- (NSUInteger)updateCurrentPageIndex
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    NSUInteger cpi = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage=cpi ;
    NSLog(@"=======%d",cpi);
    return cpi;
}

-(DetailView *)isHaveDetail:(int)currentPage
{
    DetailView *View =nil;
   if ([[_scrollView subviews] count]>0) {
         for ( int i=0;i<[[_scrollView subviews] count];i++ ) {
             if ([[[_scrollView subviews] objectAtIndex:i] isKindOfClass:[DetailView class]]) {
                 DetailView *dView=[[_scrollView subviews] objectAtIndex:i];
                 if (dView.curentView==currentPage) {
                     View=dView;
                 }
             } 
         }
   }
    return View;
}

-(void)updateImg:(NSString *)todayState
{
    BOOL b1=NO;
    BOOL b2=NO;
    BOOL b3=NO;
    BOOL b4=NO;
    NSRange rang1;
     NSRange rang2;
     NSRange rang3;
     NSRange rang4;
    NSRange range=[todayState rangeOfString:@"转"];
    if (range.length==0) {
        NSLog(@"不包含转===============");
         rang1=[todayState rangeOfString:@"阴"];
        if (rang1.length!=0) {
            b1=YES;
        }
         rang2=[todayState  rangeOfString:@"雨"];
        if (rang2.length!=0) {
             b2=YES;
        }
         rang3=[todayState  rangeOfString:@"多云"];
        if (rang3.length!=0) {
             b3=YES;
        }
         rang4=[todayState  rangeOfString:@"晴"];
        if (rang4.length!=0) {
             b4=YES;
        }
        
    }else{
        NSLog(@"包含转==============");
        NSArray *state=[todayState   componentsSeparatedByString:@"转"];
        if ([state count]>0) {
             rang1=[[state objectAtIndex:1] rangeOfString:@"阴"];
            if (rang1.length!=0) {
                 b1=YES;
            }
             rang2=[[state objectAtIndex:1]  rangeOfString:@"雨"];
            if (rang2.length!=0) {
                 b2=YES;
            }
             rang3=[[state objectAtIndex:1]  rangeOfString:@"多云"];
            if (rang3.length!=0) {
                 b3=YES;
            }
             rang4=[[state objectAtIndex:1]  rangeOfString:@"晴"];
            if (rang4.length!=0) {
                 b4=YES;
            }
        }
    }

    if (b1) {//阴
        self.view.layer.contents=(id)[UIImage imageNamed:@"yint.png"].CGImage;
    }

    if (b2) {//雨
          self.view.layer.contents=(id)[UIImage imageNamed:@"rain.png"].CGImage;
    }

    if (b3) {//多云
          self.view.layer.contents=(id)[UIImage imageNamed:@"duoyun.png"].CGImage;
    }

    if (b4) {//晴
          self.view.layer.contents=(id)[UIImage imageNamed:@"qingt.png"].CGImage;
    }
}
-(void)updateUI//从数据库查数据    //异步线程
{
   NSArray *dateS=   [parse  getData:[_citys objectAtIndex:_pageControl.currentPage]];
    if ([dateS count]>0) {
        WeatherInfo *winfo=[dateS objectAtIndex:0];
        //先换图片....
        [self updateImg:winfo.todaystate];
        
        
        
        int num=_pageControl.currentPage;
        NSLog(@"num:=====当前页...==============================::%d",num);
        
       DetailView *view=   [self isHaveDetail:_pageControl.currentPage];
        // 先判断 是否存在该view
        if (!view) {
            NSLog(@"不存在..初始...");
            detail=[[DetailView alloc] initWithFrame:CGRectMake(num*320, 0, 320, _scrollView.frame.size.height)];
            detail.curentView=num;
            detail.infoSource=winfo;
            [_scrollView addSubview:detail];
            [detail release];
        }else
        {
            NSLog(@"存在。。。重新显示。。。。");
            [view reloadView:winfo];
        }
        
        NSLog(@"更新发布时间....");
        NSArray *up=[NSArray arrayWithObjects:[_citys objectAtIndex:_pageControl.currentPage],winfo.uptime, nil];
        [self updateLable:up];
        
    }else
    {
        NSLog(@"数据库没有数据");
        
        NSArray *up=[NSArray arrayWithObjects:[_citys objectAtIndex:_pageControl.currentPage], nil];
        [self updateLable:up];
    }
}
-(void)updateLable:(NSArray *)arr
{
    if ([arr count ]>0) {
        if ([arr count]==2) {
            time.hidden=NO;
            city.text=[arr objectAtIndex:0];
            time.text=[NSString stringWithFormat:@"%@%@",[arr objectAtIndex:1],@"发布"];
        }else
        {
             time.hidden=YES;
          city.text=[arr objectAtIndex:0];
        }
    }
}



#pragma - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //先更新便签..  查库改城市最后一条数据创建时间 是否和当前时间  大于15分钟    1,有数据...大于15请求. 2.没数据，请求   3，断网。。。暂不考虑断网情况   
    NSLog(@"scrollViewDidEndDecelerating");
   int cpi=  [self updateCurrentPageIndex];
    
    if (currentPage!=cpi) {
        city.text=[_citys objectAtIndex:_pageControl.currentPage];
        time.text=@"更新中....";      
        [self isRequest];
        currentPage=cpi;
    }
     
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    [self updateCurrentPageIndex];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
   
    [tabbarview release];
    [detail release];
    [parse release];
    [city release];[time release];
    [_scrollView release],_scrollView=nil;
    [_pageControl release],_pageControl=nil;
    [_citys release];_citys =nil;
    [super dealloc];
}

@end
