//
//  FirNextViewController.m
//  NewIEBook
//
//  Created by WO on 13-3-14.
//  Copyright (c) 2013年 WN. All rights reserved.
//
#import "FirNextViewController.h"
#import "IAPHandler.h"
@interface FirNextViewController ()

@end

@implementation FirNextViewController
@synthesize arrData,message,sqlite;
- (id)init :(NSString *)bookID
{
    self = [super init];
    if (self) {
        // Custom initialization
        strID=bookID;
    }
    return self;
}

- (void)viewDidLoad
{
//    [self.view reloadInputViews];
  
    
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    self.title=@"图书细览";
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData_1:) name:@"DATA_1" object:nil];
    self.message=[[Message alloc]init];
    [message getFirNext:strID];
  

    
	// Do any additional setup after loading the view.
}
//IAP
- (void)viewWillUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)getData_1:(NSNotification *)note
{

    self.arrData=[note object];
    NSLog(@"2+++%@",self.arrData);
    [self drawView];
}
-(void)drawView
{
    NSString *thumbUrl=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"thumbUrl"];
    NSLog(@"thumb+++%@",thumbUrl);
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbUrl]];
    UIImage *image=[UIImage imageWithData:imageData];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 187, 240)];
    imageView.image=image;
    [self.view addSubview:imageView];
    NSString *bookname=[NSString stringWithFormat:@"书名:%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"title"]];
    NSString *auther=[NSString stringWithFormat:@"作者:%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"author"]];
    NSString *publisHorse=[NSString stringWithFormat:@"出版社:%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"publisHorse"]];
    NSString *publishDate=[NSString stringWithFormat:@"出版日期:%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"publishDate"]];
    NSString *size=[NSString stringWithFormat:@"图书大小:%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"size"]];
    NSString *marketPrice=[NSString stringWithFormat:@"纸书价格:￥%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"marketPrice"]];
    NSString *price=[NSString stringWithFormat:@"电子书价:￥%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"price"]];
    
    NSLog(@"bookname__%@",bookname);
    [self label:0 :bookname];
    [self label:1 :auther];
    [self label:2 :publisHorse];
    [self label:3 :publishDate];
    [self label:4 :size];
    [self label:5 :marketPrice];
    [self label:6 :price];
    
    UIButton *btnTry=[UIButton buttonWithType:UIButtonTypeCustom];
    btnTry.frame=CGRectMake(300, 60, 150, 45);
    [btnTry setImage:[UIImage imageNamed:@"try"] forState:UIControlStateNormal];
    [self.view addSubview: btnTry];
    
    UIButton *btnbuy=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbuy.frame=CGRectMake(500, 60, 150, 45);
    [btnbuy setImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
    [btnbuy addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: btnbuy];
    
    NSString *description=[NSString stringWithFormat:@"内容简介:%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"description"]];
    UITextField *textshow=[[UITextField alloc]initWithFrame:CGRectMake(320, 150, 350, 700)];
    textshow.text=description;
    [self.view addSubview:textshow];
    NSLog(@"nav++++%d",self.navigationController.navigationBarHidden);
    //IAP
    [self registIapObservers];
    [IAPHandler initECPurchaseWithHandler];
    //iap产品编号集合，这里你需要替换为你自己的iap列表
    NSArray *productIds = [NSArray arrayWithObjects:
                           @"com.lifeng.EbookShop_iPad3", nil];
    //从AppStore上获取产品信息
    [[ECPurchase shared]requestProductData:productIds];
}
//IAP
- (void)getedProds:(NSNotification*)notification
{
    NSLog(@"通过NSNotificationCenter收到信息：%@,", [notification object]);
}


- (void)buy
{
    hudBuy=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hudBuy];
    [hudBuy setAnimationType:MBProgressHUDModeIndeterminate];
    hudBuy.labelText=@"交易请求中,请等待";
    [hudBuy show:YES];
    [hudBuy hide:YES afterDelay:1.5];
    SKProduct *product = [products_ objectAtIndex:0];
    NSLog(@"购买商品：%@", product.productIdentifier);
    [[ECPurchase shared]addPayment:product];
}
//接收从app store抓取回来的产品，显示在表格上
-(void) receivedProducts:(NSNotification*)notification
{
    
    if (products_) {
        [products_ release];
        products_ = nil;
    }
    products_ = [[NSArray alloc]initWithArray:[notification object]];
    NSLog(@"count+++%d",[products_ count]);
    


}

// 注册IapHander的监听器，并不是所有监听器都需要注册，
// 这里可以根据业务需求和收据认证模式有选择的注册需要
- (void)registIapObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receivedProducts:)
                                                name:IAPDidReceivedProducts
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(failedTransaction:)
                                                name:IAPDidFailedTransaction
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(restoreTransaction:)
                                                name:IAPDidRestoreTransaction
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(completeTransaction:)
                                                name:IAPDidCompleteTransaction object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeTransactionAndVerifySucceed:)
//                                                name:IAPDidCompleteTransactionAndVerifySucceed
//                                              object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(completeTransactionAndVerifyFailed:)
//                                                name:IAPDidCompleteTransactionAndVerifyFailed
//                                              object:nil];
}

-(void)showAlertWithMsg:(NSString*)message1
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IAP反馈"
                                                   message:message1
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void) failedTransaction:(NSNotification*)notification
{
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易取消(%@)",[notification name]]];
}

-(void) restoreTransaction:(NSNotification*)notification
{
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易恢复(%@)",[notification name]]];
}

-(void )completeTransaction:(NSNotification*)notification
{
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易成功(%@)",[notification name]]];
    [self shopCart];
}

-(void) completeTransactionAndVerifySucceed:(NSNotification*)notification
{
    NSString *proIdentifier = [notification object];
    [self showAlertWithMsg:[NSString stringWithFormat:@"交易成功，产品编号：%@",proIdentifier]];
}

-(void) completeTransactionAndVerifyFailed:(NSNotification*)notification
{
    NSString *proIdentifier = [notification object];
    [self showAlertWithMsg:[NSString stringWithFormat:@"产品%@交易失败",proIdentifier]];
}


-(void)shopCart
{
    NSLog(@"shopCart");
    BOOL success;
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path=[documentsDirectory stringByAppendingPathComponent:@"book.db"];
    success=[fileManger fileExistsAtPath:path];
    if (!success) {
        NSString *defalutPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"book.db"];
        success=[fileManger copyItemAtPath:defalutPath toPath:path error:&error];
        if (!success) {
            NSLog(@"fail copy");
        }
        else NSLog(@"success copy");
    }
    char *c=(char *)[path cStringUsingEncoding:NSUTF8StringEncoding];
    int rc=sqlite3_open(c, &sqlite);
    if (rc!=SQLITE_OK) {
        fprintf(stderr,"错误%s\n", sqlite3_errmsg(sqlite));
    }
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    NSString *bookID=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:0] objectForKey:@"id"];
    NSLog(@"ID++%@  date++%@",bookID,newDateOne);
    NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO shopCart(bookID,Date)VALUES(\"%@\",\"%@\")",bookID,newDateOne];
    sqlite3_stmt *statement = nil;
    const char *insert_stmt=[insertSQL UTF8String];
    sqlite3_prepare_v2(sqlite, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement)==SQLITE_DONE) {
        //判断句柄是结束
        NSLog(@"insert已存到数据库");
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText=@"购物车添加成功";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        
    }
    else{
        NSLog(@"insert存储失败");
        NSLog(@"error====%@",error);
    }
    sqlite3_finalize(statement);
    sqlite3_close(sqlite);
    
    
    NSURL *url = [NSURL URLWithString:path];
    [self addSkipBackupAttributeToItemAtURL:url];
    
}
//设置云同步
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
}

-(void)label:(NSInteger)num :(NSString *)text
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 310+50*num, 250, 40)];
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    [self.view addSubview:label];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
//    if ([self.navigationController popViewControllerAnimated:YES]) {
//        NSLog(@"hide");
//        self.navigationController.navigationBarHidden=YES;
//    }
    if ([self.navigationController.viewControllers count]==1)
    {
        NSLog(@"hide");
        self.navigationController.navigationBarHidden=YES;
    }
}
@end
