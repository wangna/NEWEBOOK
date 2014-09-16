//
//  BookDB.h
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface BooksDB : NSObject
@property(nonatomic)sqlite3 *sqlite;
@property(nonatomic,retain)NSMutableArray *allDatas;
-(NSArray *)getAllDatas;
-(NSArray *)getShopCart;
@end
