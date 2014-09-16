//
//  FirstViewController.h
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MBProgressHUD.h"
@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger num;
    NSArray *arrDic;
    NSString *key;
}
@property(nonatomic,retain)NSMutableDictionary *arrData;
@property(nonatomic,retain)Message *message;
@property(nonatomic,retain)UITableView *tableview;
@property(nonatomic,retain)MBProgressHUD *hud;
- (IBAction)backtoShelf:(id)sender;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@end
