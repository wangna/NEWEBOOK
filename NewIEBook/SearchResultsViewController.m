//
//  SearchResultsViewController.m
//  AePubReader
//
//  Created by Federico Frappi on 05/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define NSLog //
#import "SearchResultsViewController.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"

@interface SearchResultsViewController()

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index;

@end


@implementation SearchResultsViewController

@synthesize resultsTableView, epubViewController, currentQuery, results,chapterPage;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    SearchResult* hit = (SearchResult*)[results objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"...%@...", hit.neighboringText];
    NSInteger beforePage=0;
    for (int i=0;i<hit.chapterIndex; i++) {
        NSInteger Page=[[self.chapterPage objectAtIndex:i]integerValue];
        beforePage=beforePage+Page;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"章节 %d - 页码 %d", hit.chapterIndex+1, hit.pageIndex+1+beforePage];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRows===%d",[results count]);
    //第一次执行为0
    return [results count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowA");
    SearchResult* hit = (SearchResult*)[results objectAtIndex:[indexPath row]];

    [epubViewController loadSpine:hit.chapterIndex atPageIndex:hit.pageIndex highlightSearchResult:hit];    
}
//查找功能
- (void) searchString:(NSString*)query :(NSArray *)arr{
    //☆☆☆☆☆在EpubViewController中调用
    NSLog(@"searchString");
    self.results = [[NSMutableArray alloc] init];
    [resultsTableView reloadData];
    self.currentQuery=query;
    NSLog(@"query+++%@",query);
    NSLog(@"chapterPage++%@",arr);
    self.chapterPage=arr;
    [self searchString:query inChapterAtIndex:0];    
}

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
    //☆☆☆☆☆
    NSLog(@"searchString inChapterAtIndex");
    currentChapterIndex = index;
    
    Chapter* chapter = [epubViewController.loadedEpub.spineArray objectAtIndex:index];
    
    NSRange range = NSMakeRange(0, chapter.text.length);
    NSLog(@"range===%d======%d",range.location,range.length);
    //范围是本chapter 的范围
    range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
    int hitCount=0;
    //当前位置找到，有结果
    while (range.location != NSNotFound) {
        range = NSMakeRange(range.location+range.length, chapter.text.length-(range.location+range.length));
        range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
        hitCount++;
        NSLog(@"range==location=%d=====length=%d",range.location,range.length);

    }
    
    if(hitCount!=0){
        UIWebView* webView = [[UIWebView alloc] initWithFrame:chapter.windowSize];
        [webView setDelegate:self];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:chapter.spinePath]];
        [webView loadRequest:urlRequest];   
    } else {
        if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]){
        //若本 chapter没有找到，那么找下一个
            [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
        } else {
            epubViewController.searching = NO;
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
	[webView release];
}

- (void) webViewDidFinishLoad:(UIWebView*)webView{
    NSLog(@"webViewDidFinishLoad");
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
	"}";
	
    NSLog(@"w:%f h:%f", webView.bounds.size.width, webView.bounds.size.height);
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",[[epubViewController.loadedEpub.spineArray objectAtIndex:currentChapterIndex] fontPercentSize]];
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
    

	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
    [webView highlightAllOccurencesOfString:currentQuery];
    NSString* foundHits = [webView stringByEvaluatingJavaScriptFromString:@"results"];
    
    NSLog(@"00000000%@", foundHits);
    
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    
    NSArray* stringObjects = [foundHits componentsSeparatedByString:@";"];
    for(int i=0; i<[stringObjects count]; i++){
        NSArray* strObj = [[stringObjects objectAtIndex:i] componentsSeparatedByString:@","];
        if([strObj count]==3){
            [objects addObject:strObj];   
        }
    }
    
    NSArray* orderedRes = [objects sortedArrayUsingComparator:^(id obj1, id obj2){
                                            int x1 = [[obj1 objectAtIndex:0] intValue];
                                            int x2 = [[obj2 objectAtIndex:0] intValue];
                                            int y1 = [[obj1 objectAtIndex:1] intValue];
                                            int y2 = [[obj2 objectAtIndex:1] intValue];
                                            if(y1<y2){
                                                return NSOrderedAscending;
                                            } else if(y1>y2){
                                                return NSOrderedDescending;
                                            } else {
                                                if(x1<x2){
                                                    return NSOrderedAscending;
                                                } else if (x1>x2){
                                                    return NSOrderedDescending;
                                                } else {
                                                    return NSOrderedSame;
                                                }
                                            }
    }];
    
    [objects release];
    
    for(int i=0; i<[orderedRes count]; i++){
        NSArray* currObj = [orderedRes objectAtIndex:i];
            
        SearchResult* searchRes = [[SearchResult alloc] initWithChapterIndex:currentChapterIndex pageIndex:([[currObj objectAtIndex:1] intValue]/webView.bounds.size.height) hitIndex:0 neighboringText:[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"unescape('%@')", [currObj objectAtIndex:2]]] originatingQuery:currentQuery];
        //result   添加元素
        [results addObject:searchRes];
		[searchRes release];
    }
    
    [webView dealloc];
    
    [resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]){
        [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
    } else {
        epubViewController.searching = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	self.resultsTableView = nil;
	[results release];
	[currentQuery release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.resultsTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
