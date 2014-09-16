//
//  Meaasge.h
//  chapterReader
//
//  Created by WO on 13-3-12.
//
//
#import <Foundation/Foundation.h>
#import "JSONKit.h"
@interface Message : NSObject
{
    NSString *endIndex;
}

@property(nonatomic,retain)NSMutableDictionary *arrData;
-(void)getFirstMessage:(BOOL)more :(NSString *)keyWords;
-(void)getFirNext:(NSString *)bookID;

-(void)getSecondMessage;
-(void)getSecNext:(NSString *)catId;
-(void)getmessage:(NSString *)order;

@end
