//
//  ViewController.m
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize nav1;
@synthesize nav2;
@synthesize nav3;
@synthesize nav4;
-(void)showLoadView
{
    
    
    mLoadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    mLoadingView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:mLoadingView];
    [mLoadingView release];
    
    mLogoView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    mLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mLogoView.image = [UIImage imageNamed:@"loading.png"];
    mLogoView.alpha = 0.0;
    [mLoadingView addSubview:mLogoView];
    [mLogoView release];
    
    [self ShowLoadingView];
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationController.navigationBarHidden=YES;
    [self showLoadView];
}
- (void)LoadingFinished1:(NSNotification *)notification
{
//    boolForClass=YES;
//    [self OnSegmentValueChange:nil];
    self.navigationController.navigationBarHidden=NO;
    UINavigationBar *navbar=self.navigationController.navigationBar;
    navbar.barStyle=UIBarStyleBlackTranslucent;
    UIView *aview=[navbar.subviews objectAtIndex:0];
    aview.hidden=NO;

    CGRect rect=CGRectMake(334, 0, 100, 44);
    UILabel *titleView=[[UILabel alloc]initWithFrame:rect];
    titleView.opaque=YES;
    titleView.backgroundColor=[UIColor clearColor];
    titleView.text=@"我的书架";
    titleView.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleView;
    [titleView release];
    
    UIImage *image=[UIImage imageNamed:@"button.png"];
    CGRect frame_1=CGRectMake(5, 5, 80, 30);
    
    UIButton *leftButton=[[UIButton alloc]initWithFrame:frame_1];
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    [leftButton setTitle:@"编辑" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(doList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]init];
    leftItem.customView=leftButton;
    [leftButton release];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    [leftItem release];
    UIButton* rightButton= [[UIButton alloc] initWithFrame:frame_1];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton setTitle:@"书城" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goShop) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"书城" style:UIBarButtonItemStyleBordered target:self action:@selector(goShop)];
    rightItem.customView = rightButton;
    [rightButton release];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];

    
	[mLoadingView removeFromSuperview];
    rect = CGRectMake(-2, 0, self.view.bounds.size.width+8, self.view.bounds.size.height);
    self.view.frame = rect;
    listView = [[BookListView alloc]initWithFrame:rect];
    listView.nc=self.navigationController;
    listView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    listView.pagingEnabled = YES;
    listView.delegate = self;
    listView.nc = self.navigationController;
    [self.view addSubview:listView];
    [listView release];
    //防止晃动
    for (id subview in self.view.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
}
- (void)ShowLoadingDidEnd {
	[self performSelector:@selector(LoadingFinished1:) withObject:nil afterDelay:1.0];
}

- (void)ShowLoadingView {
	[UIImageView beginAnimations:nil context:nil];
	[UIImageView setAnimationDuration:3.0f];
	[UIImageView setAnimationDelegate:self];
	[UIImageView setAnimationDidStopSelector:@selector(ShowLoadingDidEnd)];
	mLogoView.alpha = 1.0;
	[UIImageView commitAnimations];
}
-(void)goShop
{
    FirstViewController*firstView=[[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
    firstView.title=@"首页";
    firstView.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.nav1=[[UINavigationController alloc]initWithRootViewController:firstView];
    firstView.navigationController.navigationBarHidden=YES;
    
    SecondViewController *secondView=[[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
    secondView.title=@"分类";
    secondView.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.nav2=[[UINavigationController alloc]initWithRootViewController:secondView];
    secondView.navigationController.navigationBarHidden=YES;
    
    ThirdViewController*thirdView=[[ThirdViewController alloc]initWithNibName:@"ThirdViewController" bundle:nil];
    thirdView.title=@"排序";
    thirdView.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.nav3=[[UINavigationController alloc]initWithRootViewController:thirdView];
    thirdView.navigationController.navigationBarHidden=YES;

    ForthViewController *frothview=[[ForthViewController alloc]initWithNibName:@"ForthViewController" bundle:nil];
    frothview.title=@"购买";
    frothview.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.nav4=[[UINavigationController alloc]initWithRootViewController:frothview];
    frothview.navigationController.navigationBarHidden=YES;

    NSArray *items=[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nil];
    UITabBarController *tabbar=[[UITabBarController alloc]init];
    [tabbar setViewControllers:items];
    [NSThread sleepForTimeInterval:0.3];
    [self presentModalViewController:tabbar animated:YES];
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:firstView.view];
    [firstView.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    firstView.hud=HUD;
    //    [self.view addSubview:tabbar.view];
}
-(void)doList
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
