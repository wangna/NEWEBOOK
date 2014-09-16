//
//  LoadingView.m
//  TextReader
//
//  Created by Bruce on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}

- (void)animateEnlargePopView {
	self.transform = CGAffineTransformMakeScale(0.3, 0.3);
	self.alpha = 0.0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	
	self.transform = CGAffineTransformMakeScale(1.0, 1.0);
	self.alpha = 1.0;
	[UIView commitAnimations];
}

- (id)InitLoadWithRect: (CGRect)rect :(NSString *)imageurl :(BOOL)bAnimate{
	self = [super initWithFrame:rect];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
		if (imageurl) {
			mImageView.image = [UIImage imageNamed:imageurl];
		}
		else {
			mImageView.backgroundColor = [UIColor clearColor];
		}
		[self addSubview:mImageView];
		[mImageView release];
		
		if (bAnimate) {
			[self animateEnlargePopView];
		}
		else {
			mActInView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
			mActInView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
			mActInView.center = self.center;
			[mActInView startAnimating];
			[self addSubview:mActInView];
			[mActInView release];
		}
	}
	return self;
}

@end
