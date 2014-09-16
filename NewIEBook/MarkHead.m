//
//  MarkHead.m
//  NewIEBook
//
//  Created by WO on 13-5-16.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "MarkHead.h"

@implementation MarkHead
@synthesize btn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)contentView
{
    self.backgroundColor=[UIColor grayColor];
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(10, 10, 50, 30);
    btn.showsTouchWhenHighlighted=YES;
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
//    CALayer *layerbtn=[btn layer];
//    [layerbtn setBorderColor:[[UIColor blackColor]CGColor]];
//    [layerbtn setBorderWidth:1.0];
	
    
//	UILabel *GtNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
//
//    GtNumLabel.text =@"编辑";
//	
//	GtNumLabel.font = [UIFont systemFontOfSize:17.0];
//	GtNumLabel.backgroundColor = [UIColor clearColor];
//	GtNumLabel.textColor = [UIColor colorWithRed:5.0/255.0 green:10.0/255.0 blue:20.0/255.0 alpha:1.0];
//	[btn addSubview:GtNumLabel];
	[self addSubview:btn];
//	[GtNumLabel release];
	

}
-(void)press
{
    NSLog(@"press");
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
