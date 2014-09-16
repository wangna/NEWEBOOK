//
//  Meaasge.m
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import "Message.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#define URLgetbooks @"http://192.168.8.168/IEBOOK/getBooks"
#define URLgetCatInfos @"http://192.168.8.168/IEBOOK/getCatInfos"
#define URLgetBook @"http://192.168.8.168/IEBOOK/getBook"
static NSInteger endNum;
@implementation Message
@synthesize arrData;
-(void)getFirstMessage:(BOOL)more :(NSString *)keyWords
{
    NSURL *url=[NSURL URLWithString:URLgetbooks];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    if (more==0) {
        endNum=2;
        endIndex=[NSString stringWithFormat:@"%d",endNum];
    }
    
    if (more) {
        endNum=endNum+2;
        endIndex=[NSString stringWithFormat:@"%d",endNum];
        NSLog(@"endIndex++%@",endIndex);
    }
    
    //请求
    [request setPostValue:@"" forKey:@"catId"];
    [request setPostValue:keyWords forKey:@"keyWords"];
    [request setPostValue:@"Buy_times" forKey:@"orderby"];
    [request setPostValue:@"0" forKey:@"startIndex"];
    [request setPostValue:endIndex forKey:@"endIndex"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(ASIHttpRequsetFailed:)];
    [request setDidFinishSelector:@selector(ASIHttpRequest:)];
    [request startAsynchronous];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"view");
    
}
-(void)getFirNext:(NSString *)bookID
{
    NSURL *url=[NSURL URLWithString:URLgetBook];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:bookID forKey:@"id"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(ASIHttpRequestFailed:)];
    [request setDidFinishSelector:@selector(ASIHttpRequest_1:)];
    [request startAsynchronous];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
}

-(void)getSecondMessage
{
    NSLog(@"second");
    NSURL *url=[NSURL URLWithString:URLgetCatInfos];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"0" forKey:@"parentId"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(ASIHttpRequestFailed:)];
    [request setDidFinishSelector:@selector(ASIHttpRequest2:)];
    [request startAsynchronous];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];

}
-(void)getSecNext:(NSString *)catId
{
    NSURL *url=[NSURL URLWithString:URLgetbooks];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:catId forKey:@"catId"];
    [request setPostValue:@"" forKey:@"keyWords"];
    [request setPostValue:@"Buy_times" forKey:@"orderby"];
    [request setPostValue:@"0" forKey:@"startIndex"];
    [request setPostValue:@"10" forKey:@"endIndex"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(ASIHttpRequestFailed:)];
    [request setDidFinishSelector:@selector(ASIHttpRequest2_1:)];
    [request startAsynchronous];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];

}
-(void)getmessage:(NSString *)order
{
    NSURL *url=[NSURL URLWithString:URLgetbooks];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    endIndex=@"10";
    NSLog(@"order+++%@",order);
    //请求
    [request setPostValue:@"" forKey:@"catId"];
    [request setPostValue:@"" forKey:@"keyWords"];
    [request setPostValue:order forKey:@"orderby"];
    [request setPostValue:@"0" forKey:@"startIndex"];
    [request setPostValue:endIndex forKey:@"endIndex"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(ASIHttpRequsetFailed:)];
    [request setDidFinishSelector:@selector(ASIHttpRequest_order:)];
    [request startAsynchronous];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
 
}
#pragma  mark-request
-(void)ASIHttpRequsetFailed:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HUDHIDE" object:nil];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
//    if (request) {
//        [request release];
//       
//    }
    NSError *error=[request error];
    NSLog(@"the error is%@",error);
}
-(void)ASIHttpRequest:(ASIHTTPRequest *)request
{
    
    self.arrData=[[NSMutableDictionary alloc]initWithCapacity:0];
    //成功请求到数据，并转换成string格式
    NSString *content=[request responseString];
//    NSLog(@"string=%@   ",content);
    self.arrData=[content objectFromJSONString];
//    NSLog(@"arrdata+++%@",[content objectFromJSONString]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DATA" object:self.arrData];

}
-(void)ASIHttpRequest_1:(ASIHTTPRequest *)request
{
    
    self.arrData=[[NSMutableDictionary alloc]initWithCapacity:0];
    //成功请求到数据，并转换成string格式
    NSString *content=[request responseString];
    //    NSLog(@"string=%@   ",content);
    self.arrData=[content objectFromJSONString];
    //    NSLog(@"arrdata+++%@",[content objectFromJSONString]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DATA_1" object:self.arrData];
    
}
-(void)ASIHttpRequest2:(ASIHTTPRequest *)request
{
    self.arrData=[[NSMutableDictionary alloc]initWithCapacity:0];
    //成功请求到数据，并转换成string格式
    NSString *content=[request responseString];
    //    NSLog(@"string=%@   ",content);
    self.arrData=[content objectFromJSONString];
    //    NSLog(@"arrdata+++%@",[content objectFromJSONString]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DATA2" object:self.arrData];
    
}
-(void)ASIHttpRequest2_1:(ASIHTTPRequest *)request
{
    self.arrData=[[NSMutableDictionary alloc]initWithCapacity:0];
    //成功请求到数据，并转换成string格式
    NSString *content=[request responseString];
    //    NSLog(@"string=%@   ",content);
    self.arrData=[content objectFromJSONString];
    NSLog(@"arrdata+++%@",[content objectFromJSONString]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DATA2_1" object:self.arrData];
    
}
-(void)ASIHttpRequest_order:(ASIHTTPRequest *)request
{
    self.arrData=[[NSMutableDictionary alloc]initWithCapacity:0];
    //成功请求到数据，并转换成string格式
    NSString *content=[request responseString];
    //    NSLog(@"string=%@   ",content);
    self.arrData=[content objectFromJSONString];
    NSLog(@"arrdata+++%@",[content objectFromJSONString]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DATA_order" object:self.arrData];

}

@end
