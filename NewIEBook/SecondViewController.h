//
//  SecondViewController.h
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MBProgressHUD.h"
@interface SecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
   NSInteger num;
}
@property(nonatomic,retain)NSMutableDictionary *arrData;
@property(nonatomic,retain)Message *message;
@property(nonatomic,retain)UITableView *tableview;

- (IBAction)backtoShelf:(id)sender;

@end
