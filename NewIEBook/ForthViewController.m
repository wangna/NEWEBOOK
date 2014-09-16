//
//  ForthViewController.m
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//

#import "ForthViewController.h"

@interface ForthViewController ()

@end

@implementation ForthViewController
@synthesize bookdb;
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
    bookdb=[[BooksDB alloc]init];
    // Do any additional setup after loading the view from its nib.
    arrshop=[bookdb getShopCart];
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
