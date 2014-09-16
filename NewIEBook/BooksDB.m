//
//  BookDB.m
//  NewIEBook
//
//  Created by WO on 13-3-13.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "BooksDB.h"

@implementation BooksDB
@synthesize sqlite,allDatas;
-(NSArray *)getAllDatas
{
    BOOL success;
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"book.db"];
    NSLog(@"defaultDbPath%@",path);
    
    success=[fileManger fileExistsAtPath:path];
    if (!success) {
        NSString *defaultDbPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingFormat:@"/book.db"];
        NSLog(@"defaultDbPath%@",defaultDbPath);
        
        success=[fileManger copyItemAtPath:defaultDbPath toPath:path error:&error];
        if (!success) {
                        NSLog(@"fail copy");
        }
                else NSLog(@"success copy");
    }
    
    char *c=(char *)[path cStringUsingEncoding:NSUTF8StringEncoding];
    int rc = sqlite3_open(c,&sqlite);
    if (rc != SQLITE_OK) {
        fprintf(stderr,"错误%s\n",sqlite3_errmsg(sqlite));
    }
    
    printf("数据库连接成功！\n");
    
    self.allDatas = [[NSMutableArray alloc] init] ;
    sqlite3_stmt *statement = nil;
    char *sql = "SELECT * FROM books";
    if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    
    //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。将此行所有信息存入字典，将字典存入数组，
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        
        NSMutableDictionary* currRow = [[NSMutableDictionary alloc] init ];
        
        char* bookname  = (char*)sqlite3_column_text(statement, 1);
        if (bookname)
        {
            [currRow setObject:[NSString stringWithUTF8String:bookname] forKey:@"bookname"];
        }
        
        char* publisher = (char*)sqlite3_column_text(statement, 2);
        if (publisher)
        {
            [currRow setObject:[NSString stringWithUTF8String:publisher] forKey:@"publisher"];
        }
        //        NSLog(@"currentrow===%@",currRow);
        [allDatas addObject:currRow];
        [currRow release];
        
    }
    
    sqlite3_finalize(statement);
    NSURL *url = [NSURL URLWithString:path];
    [self addSkipBackupAttributeToItemAtURL:url];
    //    NSLog(@"BOOKDATA=====%@",allDatas);
    NSArray *data=self.allDatas;
    [allDatas release];
    return data;
}
-(NSArray *)getShopCart
{
    BOOL success;
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"book.db"];
    NSLog(@"defaultDbPath%@",path);
    
    success=[fileManger fileExistsAtPath:path];
    if (!success) {
        NSString *defaultDbPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingFormat:@"/book.db"];
        NSLog(@"defaultDbPath%@",defaultDbPath);
        
        success=[fileManger copyItemAtPath:defaultDbPath toPath:path error:&error];
        if (!success) {
            NSLog(@"fail copy");
        }
        else NSLog(@"success copy");
    }
    
    char *c=(char *)[path cStringUsingEncoding:NSUTF8StringEncoding];
    int rc = sqlite3_open(c,&sqlite);
    if (rc != SQLITE_OK) {
        fprintf(stderr,"错误%s\n",sqlite3_errmsg(sqlite));
    }
    
    printf("数据库连接成功！\n");
    
    self.allDatas = [[NSMutableArray alloc] init] ;
    sqlite3_stmt *statement = nil;
    char *sql = "SELECT * FROM shopCart";
    if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    
    //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。将此行所有信息存入字典，将字典存入数组，
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        
        NSMutableDictionary* currRow = [[NSMutableDictionary alloc] init ];
        
        char* bookname  = (char*)sqlite3_column_text(statement, 0);
        if (bookname)
        {
            [currRow setObject:[NSString stringWithUTF8String:bookname] forKey:@"bookID"];
        }
        
        char* publisher = (char*)sqlite3_column_text(statement, 1);
        if (publisher)
        {
            [currRow setObject:[NSString stringWithUTF8String:publisher] forKey:@"Date"];
        }
        //        NSLog(@"currentrow===%@",currRow);
        [allDatas addObject:currRow];
        [currRow release];
        
    }
    
    sqlite3_finalize(statement);
    NSURL *url = [NSURL URLWithString:path];
    [self addSkipBackupAttributeToItemAtURL:url];
    //    NSLog(@"BOOKDATA=====%@",allDatas);
    NSArray *data=self.allDatas;
    [allDatas release];
    return data;

}
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
}

@end
