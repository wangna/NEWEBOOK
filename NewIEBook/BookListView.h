//
//  BookListView.h
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooksDB.h"
#import "EPubViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface BookListView : UIScrollView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UIScrollView *FirstView;
    //    SecondView *secondView;
    //    FirstViewController *firstView;
    UITableView* bookTableView;
    BOOL isTableViewShow;
    BooksDB *bookDb;
    NSArray *bookData;
    EPubViewController *readView;
    BooksDB *bookdata;
}
@property(nonatomic,assign) UINavigationController* nc;
@property(nonatomic,retain)NSArray *arrbook;
@end
