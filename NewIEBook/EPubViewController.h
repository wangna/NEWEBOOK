//
//  EPubViewController.h
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "EPub.h"
#import "Chapter.h"
#import <QuartzCore/QuartzCore.h>
#import<sqlite3.h>
#import "MBProgressHUD.h"
@class SearchResultsViewController;
@class SearchResult;
@interface EPubViewController : UIViewController<MBProgressHUDDelegate,UIWebViewDelegate, ChapterDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    UIToolbar *toolbar;
    
	UIWebView *webView;
    
    UIBarButtonItem* chapterListButton;
	
	UIBarButtonItem* decTextSizeButton;
	UIBarButtonItem* incTextSizeButton;
    
    UISlider* pageSlider;
    UILabel* currentPageLabel;
    
	EPub* loadedEpub;
	int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    
    BOOL mark;
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
    UIPopoverController* chaptersPopover;
    UIPopoverController* searchResultsPopover;
    
    SearchResultsViewController* searchResViewController;
    SearchResult* currentSearchResult;
    BOOL isNavHideflage;
    
    
    UIBarButtonItem *pageButton;

}
- (void) showChapterIndex:(id)sender;
- (void) increaseTextSizeClicked:(id)sender;
- (void) decreaseTextSizeClicked:(id)sender;
- (void) doneClicked:(id)sender;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;
-(void)foundRootPath:(NSString *)rootPath;
- (void) loadEpub:(NSURL*) epubURL;
-(NSString *)returnBookname;
- (IBAction)slidingStarted:(id)sender;
- (IBAction)slidingEnded:(id)sender;
@property(nonatomic,retain)MBProgressHUD *hud;
@property (retain, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (retain, nonatomic) IBOutlet UISlider *pageSlider;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic)NSInteger index;
@property (nonatomic, retain) EPub* loadedEpub;

@property (nonatomic, retain) SearchResult* currentSearchResult;
@property BOOL searching;
//add1
@property(nonatomic,retain)NSString *bookname;
@property(nonatomic)sqlite3 *sqlite;
@property(nonatomic,retain)NSString *_rootPath;
@property(nonatomic,retain)NSMutableArray *arrPage;
@end
