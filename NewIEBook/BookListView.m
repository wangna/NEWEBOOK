//
//  BookListView.m
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "BookListView.h"
//#define NSLog //
@implementation BookListView
@synthesize arrbook,nc;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isTableViewShow = NO;
        [self initView];
    }
    return self;
}
-(void) initView
{
    
    
    //    bookData = [BookData shareBookData];
    //上方bar条
    UIImageView* imageView = [[UIImageView alloc] initWithImage:
                              [UIImage imageNamed:@"shelf_top.png"]];
    CGRect rect = CGRectMake(0, 0, 775, 45);
    imageView.frame =rect;
    [self addSubview:imageView];
    [imageView release];
    
    //三横条书架
    rect = CGRectMake(0, 45, 775, 1004-45);
    FirstView = [[UIScrollView alloc]initWithFrame:rect];
    
    UIImage* rowImage = [UIImage imageNamed:@"shelf_row.png"];
    for (int i=0; i<5;i++) {
        rect=CGRectMake(0, (i-1)*313, 775, 313);
        UIImageView *row=[[UIImageView alloc]initWithFrame:rect];
        row.image=rowImage;
        [FirstView addSubview:row];
        [row release];
    }
    bookDb=[[BooksDB alloc]init];
    bookData=[bookDb getAllDatas];
    NSLog(@"bookData--%@",bookData);
    NSInteger total=[bookData count];
    if (total>9) {
        NSInteger num;
        if (total%3==0) {
            num=total/3-2;
        }
        else num=total/3+1-2;
        FirstView.contentSize=CGSizeMake(775, 1004-65+313*num);
        
        for (int i=0; i<num;i++) {
            rect=CGRectMake(0, (i+3)*313, 775, 313);
            UIImageView *row1=[[UIImageView alloc]initWithFrame:rect];
            row1.image=rowImage;
            [FirstView addSubview:row1];
            [row1 release];
            
        }
    }
    //书架条都加到scrollview上
    [self addSubview:FirstView];
    
    [FirstView release];
    
    for(int i=0;i<[bookData count];i++)
    {
        
        //每一本书的位置
        rect = CGRectMake(51+(i%3*249), 50+(i/3)*313, 180, 220);
        //取出每一本书
        //        SingleBook* singleBook = [bookData.books objectAtIndex:i];
        //button 来做每一本书
        UIButton* button= [[UIButton alloc]initWithFrame:rect];
        button.tag = i;
        NSString *bookname=[[bookData objectAtIndex:i]objectForKey:@"bookname"];
        NSLog(@"bookname===%@",bookname);
        [button setImage:[UIImage imageNamed:bookname] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doReadBook:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"book_cover_shadow"]];
//        imageView.backgroundColor=[UIColor whiteColor];
        imageView.frame=CGRectMake(51+(i%3*249)+178, 50+(i/3)*313-2, 15, 223);
        
        [FirstView addSubview:imageView];
        [FirstView addSubview:button];
        [FirstView bringSubviewToFront:button];
        [button release];
        [imageView release];
    }
    
    //    imageView = [[UIImageView alloc] initWithImage:
    //                 [UIImage imageNamed:@"background.jpg"]];
    //    rect = CGRectMake(768, 0, 768, 1004);
    //    imageView.frame =rect;
    //    [self addSubview:imageView];
    //    [imageView release];
    
    rect = CGRectMake(768, 45, 768, 1004-45);
    //    secondView = [[SecondView alloc]initWithFrame:rect];
    //    [self addSubview:secondView];
    //    firstView=[[FirstViewController alloc]initWithNibName:nil bundle:nil];
    //    firstView.view.frame=rect;
    //    [self addSubview:firstView.view];
}
-(void)doReadBook:(id)sender
{
    UIButton* but = (UIButton*)sender;
    NSInteger i = but.tag;
 
	[self readBook:i];
 
}
-(void)readBook:(NSInteger)i
{
    readView=[[EPubViewController alloc]initWithNibName:@"EPubViewController" bundle:nil];
    [self.nc pushViewController:readView animated:YES];
    readView.index=i;
    NSLog(@"integer----%d",readView.index);
    bookdata=[[BooksDB alloc]init];
    self.arrbook=[bookdata getAllDatas];
    //    NSLog(@"book====%@",bookname);
    //    NSLog(@"epub.......%@",[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:bookname ofType:@"epub"]]);
    
    NSString *bookname=[[self.arrbook objectAtIndex:readView.index]objectForKey:@"bookname"];
    [readView loadEpub:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:bookname ofType:@"epub"]]];
    MBProgressHUD *HUD= [[MBProgressHUD alloc] initWithView:readView.view];
    [readView.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    readView.hud=HUD;
    //    //            [HUD hide:YES afterDelay:1.5];
    //    [HUD showWhileExecuting:@selector(chapterDidFinishLoad:) onTarget:readView withObject:nil animated:YES];
    //    [HUD release];
    [readView release];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
