//
//  EPubViewController.m
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//
#define NSLog //
#import "EPubViewController.h"
#import "ChapterListViewController.h"
#import "SearchResultsViewController.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"
#import "BookmarkViewController.h"
#import "MBProgressHUD.h"
@interface EPubViewController ()
- (void) gotoNextSpine;
- (void) gotoPrevSpine;
- (void) gotoNextPage;
- (void) gotoPrevPage;

- (int) getGlobalPageCount;

- (void) gotoPageInCurrentSpine: (int)pageIndex;
- (void) updatePagination;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end

@implementation EPubViewController
@synthesize loadedEpub,  webView,hud;
@synthesize currentPageLabel, pageSlider, searching;
@synthesize currentSearchResult,index,sqlite,bookname,arrPage;
#pragma mark-Epubdelegate
-(void)foundRootPath:(NSString *)rootPath
{
    NSString *strOPFFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/%@",[self applicationDocumentsDirectory],rootPath];
    NSFileManager *filemanager=[[NSFileManager alloc]init];
    self._rootPath=[strOPFFilePath stringByReplacingOccurrencesOfString:[strOPFFilePath lastPathComponent] withString:@""];
    NSLog(@"self._rootPath=====%@",self._rootPath);
    NSString *ncxPath=[NSString stringWithFormat:@"%@/toc.ncx",self._rootPath];
    NSLog(@"ncxPath=====%@",ncxPath);
    [loadedEpub parseXMLFileAt:ncxPath];
    if ([filemanager fileExistsAtPath:strOPFFilePath]) {
        [loadedEpub parseXMLFileAt:strOPFFilePath];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"OPF File not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    [filemanager release];
    
}
-(NSString *)returnPath
{
    return self._rootPath;
}
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
//add2
#pragma mark -delegate

- (void) loadEpub:(NSURL*) epubURL{
    
    currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    pagesInCurrentSpineCount = 0;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    //add2
    
    //将每个html文档转换成txt存入数组，目录数组，元素数组
    self.loadedEpub = [[EPub alloc] init];
    self.loadedEpub.delegate=self;
    NSLog(@"。。。。。。");
    [loadedEpub EpubPath:[epubURL path]];
    NSLog(@"path+++++%@",[epubURL path]);
    NSLog(@"delegate=====%d",loadedEpub.delegate!=nil);
    self.bookname=[loadedEpub.bookname stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    //add1
    
    
    epubLoaded = YES;
    NSLog(@"loadEpub");
    
	[self updatePagination];
}

- (void) updatePagination{
    //☆☆☆☆☆
	if(epubLoaded){
        //bool类型paginating默认为0
        if(!paginating){
            arrPage=[[NSMutableArray alloc]initWithCapacity:0];

            NSLog(@"Pagination Started!页面初始化开始");
            NSUserDefaults *userDefaults1=[NSUserDefaults standardUserDefaults];
            NSInteger font=[userDefaults1 integerForKey:@"textFont"];
            
            if (font<100) {
                currentTextSize = 100;
            }
            else currentTextSize=font;
            paginating = YES;
            totalPagesCount=0;
            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
            //Chapter  delegate：self
            [[loadedEpub.spineArray objectAtIndex:0] setDelegate:self];
            //chapter，调用方法webview 大小  字体大小
            NSLog(@"currentTextSize------%d",currentTextSize);
            
            NSLog(@"webView.bounds++++++%f+++++++%f",webView.bounds.size.height,webView.bounds.size.width);
            [[loadedEpub.spineArray objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
            [currentPageLabel setText:@"?/?"];
            
        }
	}
}
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    //☆☆☆☆☆
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
	//☆☆☆☆☆
	webView.hidden = YES;
	
	self.currentSearchResult = theResult;
	[chaptersPopover dismissPopoverAnimated:YES];
	[searchResultsPopover dismissPopoverAnimated:YES];
	//spinePath是Chapter 调用set 方法
	NSURL* url = [NSURL fileURLWithPath:[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath]];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
    NSLog(@"paginating;;;;;;;;%d",paginating);
    pageButton.title=[NSString stringWithFormat:@"第%d页",[self getGlobalPageCount]];
    
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
        
	}
}


- (void) chapterDidFinishLoad:(Chapter *)chapter{
    ////☆☆☆☆☆chapter中 调用
        NSString *str=[NSString stringWithFormat:@"%d",chapter.pageCount];
    [self.arrPage addObject:str];
    NSLog(@"arrPage+++%@",self.arrPage);
    totalPagesCount+=chapter.pageCount;
    
    NSLog(@"chapterDidFinishLoad:");
	if(chapter.chapterIndex + 1 < [loadedEpub.spineArray count]){
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
		[currentPageLabel setText:[NSString stringWithFormat:@"?/%d", totalPagesCount]];
	} else {
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
		paginating = NO;
        [self.hud removeFromSuperview];
		NSLog(@"Pagination Ended!");
	}
}

- (int) getGlobalPageCount{
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [[loadedEpub.spineArray objectAtIndex:i] pageCount];
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}


- (void) gotoPageInCurrentSpine:(int)pageIndex{
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;
	}
	
	float pageOffset = pageIndex*webView.bounds.size.width;
    
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
	
	if(!paginating){
        NSLog(@"getGlobalPageCount+++++%d+++++%d",[self getGlobalPageCount],totalPagesCount);
        
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
	}
	
	webView.hidden = NO;
	
}

- (void) gotoNextSpine {
	if(!paginating){
		if(currentSpineIndex+1<[loadedEpub.spineArray count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0];
		}
	}
}

- (void) gotoPrevSpine {
	if(!paginating){
		if(currentSpineIndex-1>=0){
			[self loadSpine:--currentSpineIndex atPageIndex:0];
		}
	}
}

- (void) gotoNextPage {
	if(!paginating){
        if (currentPageInSpineIndex+1==pagesInCurrentSpineCount&&currentSpineIndex+1==[loadedEpub.spineArray count]) {
            MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"已是最后一页";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            return;        }
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:0.5f];
        [animation setType:@"pageCurl"];
        
        //[animation setType:kcat];
        [animation setSubtype:@"fromRight"];
        
		if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
            
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
		} else {
			[self gotoNextSpine];
		}
        
        [[webView layer] addAnimation:animation forKey:@"WebPageCurl"];
        pageButton.title=[NSString stringWithFormat:@"第%d页",[self getGlobalPageCount]];
        
	}
}

- (void) gotoPrevPage {
	if (!paginating) {
        if (currentPageInSpineIndex==0&&currentSpineIndex==0) {
//            self.navigationController.navigationBar.hidden=NO;
//            [self.navigationController popToRootViewControllerAnimated:YES];
            MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"这是第一页";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            return;
        }
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:0.5f];
        [animation setType:@"pageUnCurl"];
        //[animation setType:kcat];
        [animation setSubtype:@"fromRight"];
		if(currentPageInSpineIndex-1>=0){
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
		} else {
			if(currentSpineIndex!=0){
				int targetPage = [[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
				[self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
			}
		}
        [[webView layer] addAnimation:animation forKey:@"WebPageUnCurl"];
        pageButton.title=[NSString stringWithFormat:@"第%d页",[self getGlobalPageCount]];
        
	}
}
-(void)day
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"nday"];
    [userDefaults synchronize];
    
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
    [webView stringByEvaluatingJavaScriptFromString:jsString2];
    
}
-(void)night
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"nday"];
    [userDefaults synchronize];
    
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor blackColor]];
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}
-(void)domark
{
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    NSLog(@"newDateOne$$$$$$%@",newDateOne);
    float per=(currentPageInSpineIndex+1.0)/pagesInCurrentSpineCount;
    NSLog(@"spine$$$$%dpage$$$$%d$$$$TotalPage%.2f/",pagesInCurrentSpineCount,currentPageInSpineIndex,(float)per);
    BOOL success;
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path=[documentsDirectory stringByAppendingPathComponent:@"book.db"];
    success=[fileManger fileExistsAtPath:path];
    if (!success) {
        NSString *defalutPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"book.db"];
        success=[fileManger copyItemAtPath:defalutPath toPath:path error:&error];
        if (!success) {
            NSLog(@"fail copy");
        }
        else NSLog(@"success copy");
    }
    char *c=(char *)[path cStringUsingEncoding:NSUTF8StringEncoding];
    bookname=[loadedEpub.bookname stringByReplacingOccurrencesOfString:@"'" withString:@""];
    //
    sqlite3_stmt *statement = nil;
    if (sqlite3_open(c, &sqlite)==SQLITE_OK) {
        NSString *SQL=[NSString stringWithFormat:@"delete from bookmark where bookname='%@' and spine=%d and percent=%.2f",bookname,currentSpineIndex,per];
        NSLog(@"SQL+++%@",SQL);
        const char *sql=[SQL UTF8String];
        sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            //判断句柄是结束
                        NSLog(@"delete已存到数据库");
            
        }
        else{
                        NSLog(@"delete存储失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(sqlite);
    }

    //
    int rc=sqlite3_open(c, &sqlite);
    if (rc!=SQLITE_OK) {
        fprintf(stderr,"错误%s\n", sqlite3_errmsg(sqlite));
    }
    
    NSLog(@"book+++++%@   pages++++%d",bookname,pagesInCurrentSpineCount);
    NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO bookmark(date,spine,percent,bookname,pages)VALUES(\"%@\",\"%d\",\"%.2f\",\"%@\",\"%d\")",newDateOne,currentSpineIndex,per,bookname,pagesInCurrentSpineCount];
    NSLog(@"insertSQL===%@",insertSQL);
    sqlite3_stmt *statement1 = nil;
    const char *insert_stmt=[insertSQL UTF8String];
    sqlite3_prepare_v2(sqlite, insert_stmt, -1, &statement1, NULL);
    if (sqlite3_step(statement1)==SQLITE_DONE) {
        //判断句柄是结束
        NSLog(@"insert已存到数据库");
        MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText=@"书签添加成功";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        
    }
    else{
        NSLog(@"insert存储失败");
        NSLog(@"error====%@",error);
    }
    sqlite3_finalize(statement1);
    sqlite3_close(sqlite);
    
    
    NSURL *url = [NSURL URLWithString:path];
    [self addSkipBackupAttributeToItemAtURL:url];
    
}
//设置云同步
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
}
-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"单击");
    [self ShowHideNav];
    //isNavHideflage初始化赋值1
    if (isNavHideflage == NO)
    {
        //bar消失
        [self performSelector:@selector(HideNav) withObject:self afterDelay:15.0];
    }
    return;
}



-(void) HideNav
{
    //viewdidload中isShowIndex赋值0，始终为0
    if(isNavHideflage == NO)
    {
        [self ShowHideNav];
    }
}
#pragma mark- showBar
-(void) ShowHideNav
{
    isNavHideflage=!isNavHideflage;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    //动画self.view页面无动画
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:webView cache:YES];
    //isNavHideflage为0，则bar出现，为1，bar消失
    pageButton.title=[NSString stringWithFormat:@"第%d页",[self getGlobalPageCount]];
    
    [self.navigationController setNavigationBarHidden:isNavHideflage animated:TRUE];
    [self.navigationController setToolbarHidden:isNavHideflage animated:TRUE];
    [UIView commitAnimations];
    
}


- (void) increaseTextSizeClicked:(id)sender{
	if(!paginating){
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
		if(currentTextSize+20<=200){
			currentTextSize+=20;
            [userDefaults1 setInteger:currentTextSize forKey:@"textFont"];
            [userDefaults1 synchronize];
			[self updatePagination];
			if(currentTextSize == 200){
				[incTextSizeButton setEnabled:NO];
			}
			[decTextSizeButton setEnabled:YES];
		}
        [userDefaults1 setInteger:currentTextSize forKey:@"textFont"];
        [userDefaults1 synchronize];
        
	}
}
- (void) decreaseTextSizeClicked:(id)sender{
	if(!paginating){
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
        
		if(currentTextSize-20>=100){
			currentTextSize-=20;
            [userDefaults1 setInteger:currentTextSize forKey:@"textFont"];
            [userDefaults1 synchronize];
			[self updatePagination];
			if(currentTextSize==100){
				[decTextSizeButton setEnabled:NO];
			}
			[incTextSizeButton setEnabled:YES];
		}
        [userDefaults1 setInteger:currentTextSize forKey:@"textFont"];
        [userDefaults1 synchronize];
        
	}
}




- (IBAction) slidingStarted:(id)sender{
    int targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount]];
}

- (IBAction) slidingEnded:(id)sender{
	int targetPage = (int)((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
	for(chapterIndex=0; chapterIndex<[loadedEpub.spineArray count]; chapterIndex++){
		pageSum+=[[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount];
        //		NSLog(@"Chapter %d, targetPage: %d, pageSum: %d, pageIndex: %d", chapterIndex, targetPage, pageSum, (pageSum-targetPage));
		if(pageSum>=targetPage){
			pageIndex = [[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
		}
	}
	[self loadSpine:chapterIndex atPageIndex:pageIndex];
}

- (void) showChapterIndex:(id)sender{
    NSLog(@"press");
    ChapterListViewController* chapterListView = [[ChapterListViewController alloc] initWithNibName:@"ChapterListViewController" bundle:[NSBundle mainBundle]];
    chapterListView.title=@"目录";
    [chapterListView setEpubViewController:self];
    BookmarkViewController *bookmarkView=[[BookmarkViewController alloc]initWithNibName:@"BookmarkViewController" bundle:nil];
    bookmarkView.title=@"书签";
    bookmarkView.delegate=self;
    NSArray *arrView=[NSArray arrayWithObjects:chapterListView,bookmarkView, nil];
//    [bookmarkView updateViewConstraints];
//	if(chaptersPopover==nil){
        UITabBarController *barview=[[UITabBarController alloc]initWithNibName:nil bundle:nil];
        [barview setViewControllers:arrView animated:NO];
        
		chaptersPopover = [[UIPopoverController alloc] initWithContentViewController:barview];
		[chaptersPopover setPopoverContentSize:CGSizeMake(350, 600)];
		[chapterListView release];
//	}
	if ([chaptersPopover isPopoverVisible]) {
		[chaptersPopover dismissPopoverAnimated:YES];
	}else{
        [chaptersPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
}
-(NSString *)returnBookname
{
    bookname=[loadedEpub.bookname stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSLog(@"bookname$$$$$$%@",bookname);
    return bookname;
}
-(void)backToShelf
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController setToolbarHidden:1 animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
	NSLog(@"web finish");
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
    
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
	[webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
    
	NSUserDefaults *menuUserDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"默认方法");
    if([menuUserDefaults boolForKey:@"nday"]){
        [webView setOpaque:NO];
        [webView setBackgroundColor:[UIColor blackColor]];
        [self.view setBackgroundColor:[UIColor blackColor]];
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
        [webView stringByEvaluatingJavaScriptFromString:jsString];
        
    }
    
    else{
     
        [webView setOpaque:NO];
        [webView setBackgroundColor:[UIColor whiteColor]];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
        [webView stringByEvaluatingJavaScriptFromString:jsString2];
    }
    
    
	if(currentSearchResult!=nil){
        //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
        [webView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
	}
	
	
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pagesInCurrentSpineCount = (int)((float)totalWidth/webView.bounds.size.width);
	
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
}




- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	if(searchResultsPopover==nil){
		searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResViewController];
		[searchResultsPopover setPopoverContentSize:CGSizeMake(400, 600)];
	}
	if (![searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover presentPopoverFromRect:searchBar.bounds inView:searchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	NSLog(@"Searching for %@", [searchBar text]);
	if(!searching){
		searching = YES;
		[searchResViewController searchString:[searchBar text]:self.arrPage];
        [searchBar resignFirstResponder];
	}
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"shouldAutorotate");
    [self updatePagination];
	return YES;
}

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationController.navigationBarHidden=YES;
    self.navigationController.toolbarHidden=YES;
    //初始化默认上下的bar是隐藏的
    isNavHideflage=YES;
	[webView setDelegate:self];
    
	UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
	NSLog(@"EpubViewDidload？？？？？？？？？？？");
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(gotoPrevPage)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [webView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [webView addGestureRecognizer:swipeLeft];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [singleTap release];
    
	
	[pageSlider setThumbImage:[UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
	[pageSlider setMinimumTrackImage:[[UIImage imageNamed:@"orangeSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
	[pageSlider setMaximumTrackImage:[[UIImage imageNamed:@"yellowSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    
	searchResViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:[NSBundle mainBundle]];
	searchResViewController.epubViewController = self;
    
    NSUserDefaults *userDefaults1=[NSUserDefaults standardUserDefaults];
    NSInteger font=[userDefaults1 integerForKey:@"textFont"];
    if (font<50) {
        currentTextSize = 50;
    }
    else currentTextSize=font;
    
    //加控件
    UIToolbar* toolBar = self.navigationController.toolbar;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] init];
    leftBarButtonItem.title = @"书架";
    leftBarButtonItem.target = self;
    leftBarButtonItem.action = @selector(backToShelf);
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *chapterItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(showChapterIndex:)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftBarButtonItem,chapterItem, nil];
    
    [leftBarButtonItem release];
    
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(590, 22, 234, 44)];
    searchBar.delegate=self;
    UIBarButtonItem *search=[[UIBarButtonItem alloc]initWithCustomView:searchBar];
    search.style=UIBarButtonItemStylePlain;
    UIBarButtonItem *markBar=[[UIBarButtonItem alloc]initWithTitle:@"书签" style:UIBarButtonItemStyleBordered target:self action:@selector(domark)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:markBar,search, nil];
    
    
    //为toolbar增加按钮
    UIBarButtonItem *dayButton = [[UIBarButtonItem alloc] initWithTitle:@"白天模式" style:UIBarButtonItemStyleBordered target:self action:@selector(day)];
    UIBarButtonItem *nigthButton = [[UIBarButtonItem alloc] initWithTitle:@"夜间模式" style:UIBarButtonItemStyleBordered target:self action:@selector(night)];
    pageButton = [[UIBarButtonItem alloc] init];
    pageButton.tintColor=[UIColor groupTableViewBackgroundColor];
    pageButton.title=@"          ";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"字体+" style:UIBarButtonItemStyleBordered target:self action:@selector(increaseTextSizeClicked:)];
    UIBarButtonItem *downButton = [[UIBarButtonItem alloc] initWithTitle:@"字体—" style:UIBarButtonItemStyleBordered target:self action:@selector(decreaseTextSizeClicked:)];
    [self setToolbarItems: [NSArray arrayWithObjects:dayButton,nigthButton,one,pageButton,one,addButton,downButton,nil]];
    [self.navigationController.toolbar sizeToFit];
    
    pageButton.title=[NSString stringWithFormat:@"第%d页",[self getGlobalPageCount]];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)viewDidUnload {

	self.webView = nil;

	self.pageSlider = nil;
	self.currentPageLabel = nil;
}


#pragma mark -
#pragma mark Memory management

/*
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

- (void)dealloc {
	self.webView = nil;

	self.pageSlider = nil;
	self.currentPageLabel = nil;
	[loadedEpub release];
	[chaptersPopover release];
	[searchResultsPopover release];
	[searchResViewController release];
	[currentSearchResult release];
    [super dealloc];
}

@end
