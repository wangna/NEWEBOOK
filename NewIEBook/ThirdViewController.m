//
//  ThirdViewController.m
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import "ThirdViewController.h"
#import "FormerCost.h"
#import "FirNextViewController.h"
@interface ThirdViewController ()

@end

@implementation ThirdViewController
@synthesize tableview,message,arrData;
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
    // Do any additional setup after loading the view from its nib.
//    self.message=[[Message alloc]init];
//    [message getFirstMessage:@"Buy_times"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:@"DATA_order" object:nil];
    self.message=[[Message alloc]init];
    [message getmessage:@"Buy_times"];

    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithFrame:CGRectMake(20, 60, 728, 45)];
    [segment insertSegmentWithTitle:@"购买次数" atIndex:0 animated:YES];
    [segment insertSegmentWithTitle:@"试读次数" atIndex:1 animated:YES];
    [segment insertSegmentWithTitle:@"收藏次数" atIndex:2 animated:YES];
    [segment insertSegmentWithTitle:@"价格" atIndex:3 animated:YES];
    segment.segmentedControlStyle=UISegmentedControlStylePlain;
    [segment setSelectedSegmentIndex:0];
    segment.momentary=NO;
    [segment addTarget:self action:@selector(segButtonClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];

    [self tableshow];

    
}
-(void)tableshow
{
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(20,120,728,900) style:UITableViewStylePlain];
    tableview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
}
-(void)segButtonClick:(UISegmentedControl *)seg
{
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode=MBProgressHUDModeIndeterminate;
    [HUD show:YES];
    NSInteger index=seg.selectedSegmentIndex;
    NSLog(@"index%d",index);
    switch (index) {
        case 0:
            self.message=[[Message alloc]init];
            [message getmessage:@"Buy_times"];
            break;
        case 1:
            self.message=[[Message alloc]init];
            [message getmessage:@"Try_times"];
            break;
        case 2:
            self.message=[[Message alloc]init];
            [message getmessage:@"Collection_times"];
            break;
        case 3:
            self.message=[[Message alloc]init];
            [message getmessage:@"Price"];
            break;
        default:
            break;
    }

}
-(void)getData:(NSNotification *)note
{
    self.arrData=[note object];
    num=[[self.arrData objectForKey:@"ebooklist"]count];
//    [tableview reloadData];
    [self tableshow];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    NSDictionary *dicData=[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row];
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *thumb=[dicData objectForKey:@"thumbUrl"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]];
    UIImage *image= [UIImage imageWithData:imageData];
    cell.imageView.image=image;
    //    NSData *titleData=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"title"];
    //    NSString *title=[[NSString alloc] initWithData:titleData encoding:NSASCIIStringEncoding];
    cell.textLabel.text=[dicData objectForKey:@"title"];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"作者：%@",[dicData objectForKey:@"author"]];
    cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    NSInteger grade=[[dicData objectForKey:@"grade"]integerValue];
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
    NSString *marketPrice=[NSString stringWithFormat:@"市场价：￥%@",[dicData objectForKey:@"marketPrice"]];
//    NSLog(@"marketPrice+++%@",marketPrice);
    FormerCost *formcost=[[FormerCost alloc]initWithFrame:CGRectMake(550, 30,60,40) andText:marketPrice];
    [cell.contentView addSubview:formcost];
    NSString *Price=[NSString stringWithFormat:@"￥%@",[dicData objectForKey:@"price"]];
    UILabel *labelPrice=[[UILabel alloc]initWithFrame:CGRectMake(550, 60, 65, 45)];
    labelPrice.backgroundColor=[UIColor clearColor];
    labelPrice.text=Price;
    labelPrice.font=[UIFont fontWithName:@"STHeitiSC-Light" size:labelPrice.frame.size.height/2];
    [cell.contentView addSubview:labelPrice];
    [HUD hide:YES];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect");
    NSInteger row=[indexPath row];
    NSString *strID=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"id"];
    FirNextViewController *firNext=[[FirNextViewController alloc]init:strID];
    [self.navigationController pushViewController:firNext animated:YES];
    //    MBProgressHUD *nextHUD=[[MBProgressHUD alloc]initWithView:firNext.view];
    //    [firNext.view addSubview:nextHUD];
    //    nextHUD.labelText=@"正在加载";
    //    nextHUD.mode=MBProgressHUDModeIndeterminate;
    //    [nextHUD show:YES];
    //    nextHUD=firNext.nexthud;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backtoShelf:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
@end
