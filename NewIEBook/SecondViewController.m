//
//  SecondViewController.m
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import "SecondViewController.h"
#import "SecondNextViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize message,tableview;
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData2:) name:@"DATA2" object:nil];
    self.message=[[Message alloc]init];
    [message getSecondMessage];
}
-(void)getData2:(NSNotification *)note
{
    self.arrData=[note object];
    num=[[self.arrData objectForKey:@"ebookcategorylist"]count];
    NSLog(@"2+++%@",self.arrData);
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,44,768,960) style:UITableViewStylePlain];
    tableview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"num+++%d",num);
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *catName=[[[self.arrData objectForKey:@"ebookcategorylist"]objectAtIndex:row]objectForKey:@"catName"];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=catName;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect");
    NSInteger row=[indexPath row];
    NSString *catId=[[[self.arrData objectForKey:@"ebookcategorylist"]objectAtIndex:row]objectForKey:@"catId"];
    NSString *catName=[[[self.arrData objectForKey:@"ebookcategorylist"]objectAtIndex:row]objectForKey:@"catName"];
    SecondNextViewController *secNext=[[SecondNextViewController alloc]init:catId :catName];
    [self.navigationController pushViewController:secNext animated:YES];
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:secNext.view];
    [secNext.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    secNext.hud=HUD;
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
