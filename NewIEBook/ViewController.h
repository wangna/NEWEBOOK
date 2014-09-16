//
//  ViewController.h
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookListView.h"
#import "MBProgressHUD.h"
@interface ViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate>

{
     BookListView *listView;
    UIView *mLoadingView;
    UIImageView *mLogoView;
}
@property(nonatomic,retain)UINavigationController *nav1;
@property(nonatomic,retain)UINavigationController *nav2;
@property(nonatomic,retain)UINavigationController *nav3;
@property(nonatomic,retain)UINavigationController *nav4;
@end
