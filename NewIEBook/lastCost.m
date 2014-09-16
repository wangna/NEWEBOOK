//
//  lastCost.m
//  DrawLine
//
//  Created by 君君 on 13-3-12.
//  Copyright (c) 2013年 Junjun. All rights reserved.
//

#import "lastCost.h"

@implementation lastCost

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [[UIColor redColor] set];
    CGContextRef currentContext =UIGraphicsGetCurrentContext();//获取图形上下文
    
    CGContextSetLineWidth(currentContext, 2.0f);
    CGContextMoveToPoint(currentContext, 0, 2);
    CGContextAddLineToPoint(currentContext,self.frame.size.width, 2);
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    CGContextStrokePath(currentContext);
    
    


    
}

@end
