//
//  SecondNextViewController.h
//  NewIEBook
//
//  Created by WO on 13-3-14.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MBProgressHUD.h"
@interface SecondNextViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString *caid;
    NSString *catN;
    NSInteger num;
}
@property(nonatomic,retain)NSMutableDictionary *arrData;
@property(nonatomic,retain)Message *message;
@property(nonatomic,retain)UITableView *tableview;
@property(nonatomic,retain)MBProgressHUD *hud;
- (id)init:(NSString *)sender :(NSString *)catName;
@end
