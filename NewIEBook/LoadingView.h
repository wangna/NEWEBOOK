//
//  LoadingView.h
//  TextReader
//
//  Created by Bruce on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
	UIActivityIndicatorView *mActInView;
	UIImageView *mImageView;
}

- (id)InitLoadWithRect: (CGRect)rect :(NSString *)imageurl:(BOOL)bAnimate;
@end
