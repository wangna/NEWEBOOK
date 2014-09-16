//
//  BookmarkViewController.h
//  chapterReader
//
//  Created by WO on 13-3-8.
//
//

#import <UIKit/UIKit.h>
#import "EPubViewController.h"
#import <sqlite3.h>
@interface BookmarkViewController : UITableViewController
{
    id delegate;
    EPubViewController *epubview;
    NSString *bookname;
    NSMutableArray *arrMark;
//    float perNum;
//    NSInteger spineNum;
//    NSInteger pagesNum;
}
@property(nonatomic,retain)id delegate;
@property(nonatomic)sqlite3 *sqlite;
@property(nonatomic,assign)EPubViewController *epubview;
@end
