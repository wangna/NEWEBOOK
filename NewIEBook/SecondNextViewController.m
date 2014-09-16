//
//  SecondNextViewController.m
//  NewIEBook
//
//  Created by WO on 13-3-14.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "SecondNextViewController.h"
#import "FormerCost.h"
#import "FirNextViewController.h"
@interface SecondNextViewController ()

@end

@implementation SecondNextViewController
@synthesize message,tableview,arrData,hud;
- (id)init:(NSString *)sender :(NSString *)catName
{
    self = [super init];
    if (self) {
        // Custom initialization
        caid=sender;
        catN=catName;
        NSLog(@"caid==%@",caid);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    [self.hud removeFromSuperview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData2_1:) name:@"DATA2_1" object:nil];
    self.message=[[Message alloc]init];
    [message getSecNext:caid];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    self.title=catN;
}
-(void)getData2_1:(NSNotification *)note
{
    self.arrData=[note object];
    num=[[self.arrData objectForKey:@"ebooklist"]count];
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
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
    NSLog(@"grade---%d",grade);
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect");
    NSInteger row=[indexPath row];
    NSString *strID=[[[self.arrData objectForKey:@"ebooklist"]objectAtIndex:row]objectForKey:@"id"];
    FirNextViewController *firNext=[[FirNextViewController alloc]init:strID];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:firNext animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
       self.navigationController.navigationBarHidden=YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
