//
//  BookmarkViewController.m
//  chapterReader
//
//  Created by WO on 13-3-8.
//
//

#import "BookmarkViewController.h"
#import "MarkHead.h"
@interface BookmarkViewController ()

@end

@implementation BookmarkViewController
@synthesize delegate,sqlite,epubview;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bookname=[self.delegate returnBookname];

    arrMark=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL success;
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"book.db"];
    NSLog(@"pathMark====%@",path);
    success=[fileManger fileExistsAtPath:path];
    if (!success) {
        NSString *defaultDbPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingFormat:@"/book.db"];
        success=[fileManger copyItemAtPath:defaultDbPath toPath:path error:&error];
        if (!success) {
            NSLog(@"fail copy");
        }
        else NSLog(@"success copy");
    }
    char *c=(char *)[path cStringUsingEncoding:NSUTF8StringEncoding];
    int rc = sqlite3_open(c,&sqlite);
    if (rc != SQLITE_OK) {
        fprintf(stderr,"错误%s\n",sqlite3_errmsg(sqlite));
    }
    printf("数据库连接成功！\n");
    sqlite3_stmt *statement = nil;
    char *sql = (char *)malloc(256);
    memset(sql, 0, 256);
    sprintf(sql,"SELECT * FROM bookmark where bookname='%s'",[bookname cStringUsingEncoding:NSStringEncodingConversionAllowLossy]) ;
//char *sql="select *from bookmark where bookname=89";
    if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    
//    BOOL success;
//    NSFileManager *fileManger=[NSFileManager defaultManager];
//    NSError *error;
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory=[paths objectAtIndex:0];
//    NSString *path=[documentsDirectory stringByAppendingPathComponent:@"book.db"];
//    success=[fileManger fileExistsAtPath:path];
//    if (!success) {
//        NSString *defalutPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"book.db"];
//        success=[fileManger copyItemAtPath:defalutPath toPath:path error:&error];
//        if (!success) {
//            NSLog(@"fail copy");
//        }
//        else NSLog(@"success copy");
//    }
//    char *c=(char *)[path cStringUsingEncoding:NSUTF8StringEncoding];
//    int rc=sqlite3_open(c, &sqlite);
//    if (rc!=SQLITE_OK) {
//        fprintf(stderr,"错误%s\n", sqlite3_errmsg(sqlite));
//    }
//    NSString *sql=[NSString stringWithFormat:@"select *from bookmark where bookname='%@\'",bookname];
//    sqlite3_stmt *statement = nil;

//    if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK) 
//    {
//        NSLog(@"Error: failed to prepare statement with message:get channels.");
//    }
    NSLog(@"sql===%s",sql);
    while (sqlite3_step(statement)==SQLITE_ROW)
    {
        NSMutableDictionary *dicBookmark=[[NSMutableDictionary alloc]initWithCapacity:0];
        char *date=(char *)sqlite3_column_text(statement, 1);
        if (date) {
            [dicBookmark setObject:[NSString stringWithUTF8String:date] forKey:@"date"];
        }
        char *spine=(char *)sqlite3_column_text(statement, 2);
        if (date) {
            [dicBookmark setObject:[NSString stringWithUTF8String:spine] forKey:@"spine"];
        }
        char *per=(char *)sqlite3_column_text(statement, 3);
        if (per) {
            [dicBookmark setObject:[NSString stringWithUTF8String:per] forKey:@"per"];
        }
        char *pages=(char *)sqlite3_column_text(statement, 5);
        if (date) {
            [dicBookmark setObject:[NSString stringWithUTF8String:pages] forKey:@"pages"];
        }
        [arrMark addObject:dicBookmark];
    }
    NSLog(@"count====%d",[arrMark count]);
     NSURL *url = [NSURL URLWithString:path];
     [self addSkipBackupAttributeToItemAtURL:url];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [arrMark count];
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MarkHead *headView=[[MarkHead alloc]initWithFrame:CGRectMake(0, 0, 350, 45)];
    [headView contentView];
    [headView.btn addTarget:self action:@selector(tableViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    return headView;
}
- (void)tableViewEdit:(id)sender{
    [self.view setEditing:!self.tableView.editing animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    NSString *dateText=[[arrMark objectAtIndex:row]objectForKey:@"date"];
//    NSString *per=[[arrMark objectAtIndex:row]objectForKey:@"per"];
   
    NSString *spine=[[arrMark objectAtIndex:row]objectForKey:@"spine"];
//    float perNum=[per floatValue];
//    NSLog(@"perNUm++++%f",perNum);
   NSInteger spineNum=[spine integerValue]+1;
    cell.textLabel.text =[NSString stringWithFormat:@"%@ 第%d章",dateText,spineNum];
    
//    NSLog(@"++++++%@",bookname);

    // Configure the cell...
    
    return cell;
}
#pragma mark-delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return YES;
}

//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
     //对数据库删除
   [self deleteData:row];
    [arrMark removeObjectAtIndex:indexPath.row];
   
 
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}
-(void)deleteData:(NSInteger)sender
{
    NSString  *per=[[arrMark objectAtIndex:sender]objectForKey:@"per"];
    NSString *spine=[[arrMark objectAtIndex:sender]objectForKey:@"spine"];
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
  
    //
    sqlite3_stmt *statement = nil;
    if (sqlite3_open(c, &sqlite)==SQLITE_OK) {
        NSString *SQL=[NSString stringWithFormat:@"delete from bookmark where bookname='%@' and spine=%@ and percent=%@",bookname,spine,per];
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
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    NSLog(@"didselect");
    NSInteger row=[indexPath row];
    NSLog(@"row+++%d",row);
    NSInteger pagesNum=[[[arrMark objectAtIndex:row]objectForKey:@"pages"] integerValue];
    NSLog(@"pageNum+++%d",pagesNum);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *spine=[[arrMark objectAtIndex:row]objectForKey:@"spine"];
    NSInteger spineNum=[spine integerValue];
    NSString *per=[[arrMark objectAtIndex:row]objectForKey:@"per"];
    float perNum=[per floatValue];
 NSLog(@"delegate+++%@",tableView.delegate);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [delegate loadSpine:spineNum atPageIndex:perNum*pagesNum-1 highlightSearchResult:nil];

}
//设置云同步
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
}
@end
