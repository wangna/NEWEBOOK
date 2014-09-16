//
//  FirNextViewController.h
//  NewIEBook
//
//  Created by WO on 13-3-14.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import <sqlite3.h>
#import "MBProgressHUD.h"
@interface FirNextViewController : UIViewController<MBProgressHUDDelegate>
{
    NSString *strID;
    NSArray *products_;
    MBProgressHUD *hudBuy;
}
@property(nonatomic)sqlite3 *sqlite;
@property(nonatomic,retain)NSMutableDictionary *arrData;
@property(nonatomic,retain)Message *message;
//@property(nonatomic,retain)UITableView *tableview;
- (id)init :(NSString *)bookID;
- (void)registIapObservers;


@end
