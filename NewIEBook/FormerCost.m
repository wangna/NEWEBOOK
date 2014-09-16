//
//  FormerCost.m
//  DrawLine
//
//  Created by 君君 on 13-3-12.
//  Copyright (c) 2013年 Junjun. All rights reserved.
//

#import "FormerCost.h"
#import "lastCost.h"
@implementation FormerCost

- (id)initWithFrame:(CGRect)frame andText:(NSString*)text
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.textColor = [ UIColor blackColor];
        self.font =  [UIFont fontWithName:@"STHeitiSC-Light" size:frame.size.height/2];
        self.textAlignment = NSTextAlignmentCenter ;
        NSLog(@"text+++%@",text);
        self.text  = text;
        
        CGSize proNameSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:frame.size.height/2] constrainedToSize:CGSizeMake( 1000, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        
        self.frame =CGRectMake (self.frame.origin.x,self.frame.origin.y  , proNameSize.width ,proNameSize.height);
        
        
        lastCost *last = [[lastCost alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 2)];
        [self addSubview:last];
    }
    return self;
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
