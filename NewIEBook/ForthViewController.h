//
//  ForthViewController.h
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import <UIKit/UIKit.h>
#import "BooksDB.h"
@interface ForthViewController : UIViewController
{
    NSArray *arrshop;
}
@property(nonatomic,retain)BooksDB *bookdb;
- (IBAction)backtoShelf:(id)sender;
@end
