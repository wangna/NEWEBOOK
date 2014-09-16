//
//  EPubParser.h
//  AePubReader
//
//  Created by Federico Frappi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EPub : NSObject<NSXMLParserDelegate> {
	NSArray* spineArray;
	NSString* epubFilePath;
    NSString *strTitle;
    NSString *strPublisher;
    //add1
    NSXMLParser *parser;
    NSString *rootPath;
    NSMutableArray *arrChapter;
    BOOL ncx;
    NSString *currentNode;
    NSMutableDictionary *itemDic;
    NSMutableArray *chapterHref;
    //add2
}

@property(nonatomic, retain) NSArray* spineArray;
//add1
@property(nonatomic,retain)id delegate;
@property(nonatomic,retain)NSString *bookname;
@property(nonatomic,retain)NSString *publisher;
@property(nonatomic,retain)NSMutableArray *arrChapter;
- (void)parseXMLFileAt:(NSString*)strPath;
-(void)foundRootPath:(NSString *)rootPath;
-(NSString *)returnPath;
-(void)EpubPath:(NSString *)path;
//add2
- (id) init;


@end
