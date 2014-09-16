//
//  FirstViewController.m
//  chapterReader
//
//  Created by WO on 13-3-12.
//

#import "FirstViewController.h"
#import "FormerCost.h"
#import "FirNextViewController.h"
@interface FirstViewController ()

@end
static NSInteger add;
@implementation FirstViewController
@synthesize arrData,message,tableview,searchBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
      
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:@"DATA" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hudHide) name:@"HUDHIDE" object:nil];
     key=@"";
    add=2;
    self.message=[[Message alloc]init];
    [message getFirstMessage:0 :key];
    NSLog(@"000");
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;  
        }   
    }
//    [self.hud removeFromSuperview];
//    [self.hud hide:YES];
}
-(void)hudHide
{
    [self.hud hide:YES];
}
-(void)getData:(NSNotification *)note
{
    [self hudHide];
    self.arrData=[note object];

    num=[[self.arrData objectForKey:@"ebooklist"]count];
    NSLog(@"NOTification+++%@",self.arrData);
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,44,768,960) style:UITableViewStylePlain];
    tableview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"num+++%d",num);
    return num+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (row==num) {
        NSLog(@"add++%d num++%d",add,num);
        if (add>num) {
            cell.textLabel.text=@"没有更多内容";
        }
        else
        cell.textLabel.text=@"查看更多";
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor grayColor];
        return cell;
    }
    else
    {
        NSString *thumb=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"thumbUrl"];
        NSLog(@"thumb+++%@",thumb);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]];
        UIImage *image= [UIImage imageWithData:imageData];
        cell.imageView.image=image;
        //    NSData *titleData=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"title"];
        //    NSString *title=[[NSString alloc] initWithData:titleData encoding:NSASCIIStringEncoding];
        cell.textLabel.text=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"title"];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"作者：%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"author"]];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        NSInteger grade=[[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"grade"]integerValue];
        for (int i=0; i<5; i++) {
            UIImageView *gtImage = [[UIImageView alloc]initWithFrame:CGRectMake(97+i*20, 90, 20, 20)];
            if (grade>=i+1) {
                gtImage.image = [UIImage imageNamed:@"quan.png"];
            }else if (grade>=i+0.5) {
                gtImage.image = [UIImage imageNamed:@"ban.png"];
            }else {
                gtImage.image = [UIImage imageNamed:@"wuL.png"];
            }
            [cell.contentView addSubview:gtImage];
        }
        NSString *marketPrice=[NSString stringWithFormat:@"市场价：￥%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"marketPrice"]];
        
        FormerCost *formcost=[[FormerCost alloc]initWithFrame:CGRectMake(550, 30,60,40) andText:marketPrice];
        [cell.contentView addSubview:formcost];
        NSString *Price=[NSString stringWithFormat:@"￥%@",[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"price"]];
        UILabel *labelPrice=[[UILabel alloc]initWithFrame:CGRectMake(550, 60, 65, 45)];
        labelPrice.backgroundColor=[UIColor clearColor];
        labelPrice.text=Price;
        labelPrice.font=[UIFont fontWithName:@"STHeitiSC-Light" size:labelPrice.frame.size.height/2];
        [cell.contentView addSubview:labelPrice];
        return cell;
 
    }
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect");
    NSInteger row=[indexPath row];
    
    if (row == num) {
        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.textLabel.text=@"正在加载......";
        loadMoreCell.textLabel.textAlignment=NSTextAlignmentCenter;
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    else
    {
        NSString *strID=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"id"];
        FirNextViewController *firNext=[[FirNextViewController alloc]init:strID];
        [self.navigationController pushViewController:firNext animated:YES];
 
    }
    
}
-(void)loadMore
{
//    message=[[Message alloc]init];
    [message getFirstMessage:1 :key];
    arrDic=[self.arrData objectForKey:@"ebooklist"];
    add+=2;
//    NSMutableArray *more;
//    more=[[NSMutableArray alloc] initWithCapacity:0];
//    for (int i=0; i<10; i++) {
//        [more addObject:[NSString stringWithFormat:@"cell ++%i",i]];
//    }
    //加载你的数据
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:arrDic waitUntilDone:NO];
}
-(void) appendTableWith:(NSMutableArray *)data
{
//    for (int i=0;i<[arrDic count];i++) {
//        [items addObject:[data objectAtIndex:i]];
//    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [arrDic count]-num; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[arrDic indexOfObject:[arrDic objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [tableview insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
   
}

//-(void)showXing
//{
//    for (int i=0; i<5; i++) {
//        UIImageView *gtImage = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*20, tGlable.frame.size.height+1, 20, 20)];
//        if (self.gScore>=i+1) {
//            gtImage.image = [UIImage imageNamed:@"quan.png"];
//        }else if (self.gScore>=i+0.5) {
//            gtImage.image = [UIImage imageNamed:@"ban.png"];
//        }else {
//            gtImage.image = [UIImage imageNamed:@"wuL.png"];
//        }
//        [self addSubview:gtImage];
//
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backtoShelf:(id)sender {
    NSLog(@"yes");
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
   
    [super dealloc];
}
- (void)viewDidUnload {
  
    [super viewDidUnload];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar{
    NSLog(@"search!!!!!");
    add=2;
    key=searchbar.text;
    [message getFirstMessage:0 :key];
    
}
//-(void)getData_key:(NSNotification *)note
//{
//    self.arrData=[note object];
//    num=[[self.arrData objectForKey:@"ebooklist"]count];
//    [tableview reloadData];
//}
@end
