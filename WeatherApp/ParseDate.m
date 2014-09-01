//
//  ParseDate.m
//  WeatherApp
//
//  Created by tang bin on 13-4-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "ParseDate.h"
#import "CoreDataAPI.h"
@implementation ParseDate
@synthesize tempString;
@synthesize dateSource;
@synthesize state;
@synthesize cityArray=_cityArray;
@synthesize iscomplet;
static NSString *const urlAddr = @"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx";	//连接地址
static   int  maxid=0;


-(id)init
{
    self=[super init];
    if (self) { 
    }
    return self;
}


-(void)requestWeather:(NSArray *)citys
{
    [NSThread detachNewThreadSelector:@selector(queue:) toTarget:self withObject:citys];
}
-(void)queue:(id )arr
{
    NSArray *arrs=(NSArray *)arr;
    for (int i=0; i<[arrs count]; i++) {
        [self request:[arrs objectAtIndex:i]];
        while (iscomplet==0) {
           // NSLog(@"请求阻塞.........");
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
      if (iscomplet==1) {
        NSLog(@"==========%@解析入库成功",[arrs objectAtIndex:i]);
       }
      if (iscomplet==2) {
        NSLog(@"==========%@解析入库失败",[arrs objectAtIndex:i]);
      }
    }
    state=1;//全部解析完成....
}


-(void)request:(NSString *)name
{
    iscomplet=0;
    NSMutableString *soapMessage =[[NSMutableString alloc] init];
    soapMessage = [NSMutableString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   "<soap:Body>\n"
                   "<getWeatherbyCityName xmlns=\"http://WebXml.com.cn/\">\n"
                   "<theCityName>%@</theCityName>\n"
                   "</getWeatherbyCityName>\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n",name];
    
    NSURL *url = [NSURL URLWithString:urlAddr];
    NSString *soapmLength = [NSString stringWithFormat: @"%d", [soapMessage length]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value: @"text/xml;charset=utf-8"  ];
    [request addRequestHeader:@"SOAPACtion" value: @"http://WebXml.com.cn/getWeatherbyCityName"  ];
    [request addRequestHeader:@"Content-Length" value: soapmLength  ];
    // Default becomes POST when you use appendPostData: / appendPostDataFromFile: / setPostBody:
    [request setRequestMethod:@"POST"];
    [request setUsername:[NSString stringWithFormat:@"%@",name]];
    [request setTimeOutSeconds:120];
    [request appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [request setCompletionBlock:^{
        NSLog(@"Success");
        NSLog(@"responseString:%@",request.responseString);
        //解析...
        weatherData=[NSMutableData dataWithData:request.responseData]  ;
        [self  startParsingWeather];
        //[soapMessage release];
    }  ];
    
    //如果出现异常会执行block中的代码
    [request setFailedBlock:^{
        iscomplet=2;//
        NSLog(@"Failed:::;");
        
        NSLog(@"error:::::%d",request.responseStatusCode);
        //提示   网络 重点或异常
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常!!!!!!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    
    }];

    [request startAsynchronous];
}





#pragma mark NSXMLParser
#pragma mark -
#pragma mark 给NSXMLParser赋值函数，开始解析xml
- (void) startParsingWeather {
	
	NSLog(@"startParsingWeather");
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:weatherData];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldResolveExternalEntities: YES];
	NSError *parseError = [parser parserError] ;
	//parseError = [parser parserError];
    if (parseError) {
		NSLog(@"parser parserError");
    }
	[parser parse];
	[parser release];
}

- (void) parserDidStartDocument: (NSXMLParser*) parser {
	NSLog(@"parserDidStartDocument");
	weatherArray = [[NSMutableArray alloc] init];//解析后的数据,选取值数组
}

#pragma mark -
#pragma mark 纪录元素开始标签，并出始化临时数组
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"string"]) {
		if(!tempString) {
			tempString = [[NSMutableString alloc] init];
		}
	}
}
#pragma mark -
#pragma mark 提取XML标签中的元素，反复取多次
- (void) parser: (NSXMLParser*) parser foundCharacters:(NSString*) string {
	//就是stringbuffer
	if(tempString) {
		
		[tempString appendString:string];
	}
}

#pragma mark -
#pragma mark 纪录元素结尾标签，并把临时数组中的元素存到字符串数组中
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
	if([elementName isEqualToString:@"string"])
	{
		[weatherArray addObject: tempString];
		[tempString release];
		tempString = nil;
	}
}

#pragma mark -
#pragma mark 结束分析，调用显示函数
- (void) parserDidEndDocument: (NSXMLParser*) parser {
	
    NSLog(@"结束分析，调用显示函数");
    NSLog(@"%d",weatherArray.count);
    //更新入库
    [self insertDatebase:weatherArray];
}


#pragma mark -
#pragma mark  更新入库
-(void)insertDatebase:(NSMutableArray *)array
{
    //先查到最大id
    NSLog(@"解析成功...插入数据库..........");
    NSLog(@"查询该城市最大id 数..........------------------");
    //查询该城市最大id 数
   NSArray *arr= [self getData:[array objectAtIndex:1]];
    if ([arr count]>0) {
        WeatherInfo *temp=[arr objectAtIndex:0];
        
    NSLog(@"数据库中%@最大id为%@",[array objectAtIndex:1],[temp id]);
    maxid=[[temp id] intValue]; 
    }else
    {
        maxid=0;
    }
    NSLog(@"查询该城市最大id 数....完毕......------------------");
    NSLog(@"开始插入数据................------------------");
    
    
  
    NSManagedObjectContext *context = [[CoreDataAPI defaultCoreDataAPI] managedObjectContext];

    WeatherInfo *weatherinfo = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherInfo" inManagedObjectContext:context];

    NSLog(@"插入数据....中......最大id为......-----------%d-------",maxid+1);
    weatherinfo.id=[NSNumber numberWithInt:maxid+1];
    weatherinfo.citycode=[array objectAtIndex:1];
    
    
    
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formater dateFromString:[array objectAtIndex:4]];//[NSDate  dateWithTimeInterval:8*60*60 sinceDate:[formater dateFromString:[array objectAtIndex:4]] ];
    [formater setDateFormat:@"HH:mm"];
    NSLog(@"date:::%@",[formater stringFromDate:date]);
    NSString *time=[formater stringFromDate:date];
    [formater release];
    

    NSString *day1=[NSString stringWithFormat:@"%@ %@",[array objectAtIndex:13],[array objectAtIndex:17]];
    NSString *day2=[NSString stringWithFormat:@"%@",[array objectAtIndex:18]];
    
    
    NSArray *av = [[array objectAtIndex:6] componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSArray *info=[[array   objectAtIndex:10] componentsSeparatedByString:@"；"];

    
    
    NSLog(@"天气实况：：：：");
     NSArray *temp1=[[info objectAtIndex:0] componentsSeparatedByString:@"："]  ;
     NSArray *temp2=[[info objectAtIndex:1] componentsSeparatedByString:@"："]  ;
     NSArray *temp3=[[info objectAtIndex:2] componentsSeparatedByString:@"："]  ;
     NSArray *temp4=[[info objectAtIndex:3] componentsSeparatedByString:@"："]  ;
     NSArray *temp5=[[info objectAtIndex:4] componentsSeparatedByString:@"："]  ;
    weatherinfo.temperature=[temp1 objectAtIndex:2]  ;
    weatherinfo.windinfo=[temp2 objectAtIndex:1];
    weatherinfo.warterinfo=[temp3 objectAtIndex:1];
    weatherinfo.airinfo=[temp4 objectAtIndex:1];
    weatherinfo.lineinfo=[temp5 objectAtIndex:1];

    NSLog(@"天气实况：：：：");
    weatherinfo.uptime= [NSString stringWithFormat:@"%@ %@",[av objectAtIndex:0],time] ;
    weatherinfo.temfw=[array objectAtIndex:5];
    weatherinfo.todaystate=[av objectAtIndex:1];
    
    
 
    
    
    //未来三天的天气状况
    weatherinfo.threedayinfo=[NSString stringWithFormat:@"%@ %@",day1,day2];
    weatherinfo.detailInfo=[array objectAtIndex:11];
    weatherinfo .state=[NSDecimalNumber decimalNumberWithString:@"1"] ;
    weatherinfo .creattime=[NSDate dateWithTimeInterval:8*60*60 sinceDate:[NSDate date]];//[NSDate dateWithTimeInterval:8*60*60 sinceDate:[NSDate date]];

    NSLog(@":creattime:::%@:::%@:::::%@", [NSDate date],weatherinfo .creattime ,[NSDate dateWithTimeInterval:8*60*60 sinceDate:[NSDate date]]);
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]); 
    }
    NSLog(@"插入数据................------完毕。。。。。------------");
      iscomplet=1;
    
}

#pragma mark -
#pragma mark  根据 城市 获取最后一条数据
-( NSArray *)getData:(NSString *)cityName
{
    NSLog(@"cityName=======%@",cityName);
    NSManagedObjectContext *context = [[CoreDataAPI defaultCoreDataAPI] managedObjectContext];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WeatherInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate;
    predicate = [NSPredicate predicateWithFormat:@"citycode =%@" argumentArray:[NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",cityName],nil]];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];//倒序
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *fetches=[NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]] ;
    return fetches  ;
}

//判断  网络情况








-(void)dealloc
{
    [_cityArray release];_cityArray=nil;
    [dateSource release];dateSource=nil;
    [tempString release];tempString=nil;
    [weatherArray release];weatherArray=nil;
    [weatherData release];weatherData=nil;
    [super dealloc];
}
@end
