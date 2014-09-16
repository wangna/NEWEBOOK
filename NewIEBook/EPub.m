//
//  EPub.m
//  AePubReader
//
//  Created by Federico Frappi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define NSLog //
#import "EPub.h"
#import "ZipArchive.h"
#import "Chapter.h"
//#import "Debug.h"
@interface EPub()

- (void) parseEpub;
- (void) unzipAndSaveFileNamed:(NSString*)fileName;
- (NSString*) applicationDocumentsDirectory;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;

@end

@implementation EPub

@synthesize spineArray,delegate,bookname,publisher,arrChapter;

- (id) init{
	if((self=[super init])){
		
	}
	return self;
}
-(void)EpubPath:(NSString *)path
{
   
    epubFilePath = [path retain];
     
    NSLog(@"epubFilePath;;;;;;%@",epubFilePath);
    spineArray = [[NSMutableArray alloc] init];
    NSLog(@"delegate!=nil=;;;%d",delegate!=nil);
     
    [self parseEpub];
  
    NSLog(@"时间？？？？？");
}
- (void) parseEpub{
    //☆☆☆☆☆
    //解压epub 文件
//    START_TIMER;
    
	[self unzipAndSaveFileNamed:epubFilePath];
//opf文件的绝对地址
//    END_TIMER(@"时间");
	NSString* opfPath = [self parseManifestFile];
    [self parseXMLFileAt:opfPath];

//	[self parseOPF:opfPath];
//    [self parseXMLFileAt:opfPath];
}

- (void)unzipAndSaveFileNamed:(NSString*)fileName{
	//☆☆☆☆☆
	ZipArchive* za = [[ZipArchive alloc] init];
//	NSLog(@"%@", fileName);
//	NSLog(@"unzipping %@", epubFilePath);
	if( [za UnzipOpenFile:epubFilePath]){
		NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub",[self applicationDocumentsDirectory]];
		NSLog(@"%@", strPath);
		//Delete all the previous files
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) {
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		[filemanager release];
		filemanager=nil;
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){
			// error handler here
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
														  message:@"Error while unzipping the epub"
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			alert=nil;
		}
		[za UnzipCloseFile];
	}					
	[za release];
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString*) parseManifestFile{
    //☆☆☆☆☆
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/UnzippedEpub/META-INF/container.xml", [self applicationDocumentsDirectory]];
	NSLog(@"%@", manifestFilePath);
    return manifestFilePath;
//	NSFileManager *fileManager = [[NSFileManager alloc] init];
//	if ([fileManager fileExistsAtPath:manifestFilePath]) {
//		//		NSLog(@"Valid epub");
//        //解析container.xml文档，获取opf。html文档的相对地址
//		CXMLDocument* manifestFile = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil] autorelease];
//		CXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
//		NSLog(@"9999%@", [NSString stringWithFormat:@"%@/UnzippedEpub/%@", [self applicationDocumentsDirectory], [opfPath stringValue]]);
//        //返回opf文件的绝对地址
//		return [NSString stringWithFormat:@"%@/UnzippedEpub/%@", [self applicationDocumentsDirectory], [opfPath stringValue]];
//	} else {
//		NSLog(@"ERROR: ePub not Valid");
//		return nil;
//	}
//	[fileManager release];
    
    //add1
    
        //add2
    
    
}
//add1
- (void)parseXMLFileAt:(NSString*)strPath{
    NSLog(@"strPath......%@",strPath);
    parser=[[NSXMLParser alloc]initWithContentsOfURL:[NSURL fileURLWithPath:strPath]];
    [parser setDelegate:self];
    NSLog(@"delegate'''parser'''%d",parser.delegate!=nil);
    [parser parse];
   
   

}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error Occured :%@",[parseError description]);
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"start==");
    if ([elementName isEqualToString:@"rootfile"]) {
        rootPath=[attributeDict valueForKey:@"full-path"];
        NSLog(@"rootPath------%@.delegate----%d.bool-----%d",rootPath,delegate!=nil,[delegate respondsToSelector:@selector(foundRootPath:)]);
        
        if ((delegate!=nil)&&([delegate respondsToSelector:@selector(foundRootPath:)])) {
        
            [delegate foundRootPath:rootPath];
        }
    }
    if ([elementName isEqualToString:@"navMap"]) {
        arrChapter=[[NSMutableArray alloc]initWithCapacity:0];
        NSLog(@"Map");
        ncx=1;
    }
    if([elementName isEqualToString:@"text"])
    {
       currentNode=@"text";
    }
    if([elementName isEqualToString:@"dc:title"])
    {
        currentNode=@"dc:title";
    }
    if([elementName isEqualToString:@"dc:publisher"])
    {
        currentNode=@"dc:publisher";
    }
    if([elementName isEqualToString:@"manifest"])
    {
        itemDic=[[NSMutableDictionary alloc]initWithCapacity:0];
    }
    if([elementName isEqualToString:@"item"])
    {
        [itemDic setValue:[attributeDict valueForKey:@"href"] forKey:[attributeDict valueForKey:@"id"]];
    }
    if([elementName isEqualToString:@"spine"])
    {
        chapterHref=[[NSMutableArray alloc]initWithCapacity:0];
    }
    if([elementName isEqualToString:@"itemref"])
    {
        [chapterHref addObject:[attributeDict valueForKey:@"idref"]];
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentNode isEqualToString:@"text"]) {
        NSLog(@"string++++%@",string);
        [arrChapter addObject:string];
        currentNode=@"";
    
    }
    if([currentNode isEqualToString:@"dc:title"])
    {
         NSLog(@"string++title++%@",string);
        self.bookname=string;
        currentNode=@"";
    }
    if([currentNode isEqualToString:@"dc:publisher"])
    {
        self.publisher=string;
        currentNode=@"";
    }
    else return;
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     NSLog(@"title===%@",arrChapter);
    if ([elementName isEqualToString:@"package"]) {
        NSMutableArray *tmpArray=[[NSMutableArray alloc]initWithCapacity:0];
        int count=0;
        NSLog(@"[chapterHref count]$$$$$$%@",chapterHref);
        for (int i=0; i<[chapterHref count]; i++) {
           
            NSString *item= [chapterHref objectAtIndex:i];
            NSLog(@"delegate returnPath=====%@%@",[delegate returnPath],[itemDic objectForKey:item]);
            Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", [delegate returnPath], [itemDic objectForKey:item]]
                                                          title:(NSString *)[arrChapter objectAtIndex:i]
                                                   chapterIndex:i];
            //每个html文档转化为txt挨个存入的数组
            [tmpArray addObject:tmpChapter];
            
        }
        self.spineArray = [NSArray arrayWithArray:tmpArray];
    }
}
//add2
//- (void) parseOPF:(NSString*)opfPath{
//    //用的DOM解析
//	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
//    //DOM解析出title publisher
////    CXMLElement* rootElement=[opfFile rootElement];
////    CXMLNode *nodeTitle=[[rootElement childAtIndex:1]childAtIndex:2];
////    strTitle=[nodeTitle stringValue];
////    
////    CXMLNode *nodePub=[[rootElement childAtIndex:1]childAtIndex:4];
////    strPublisher=[nodePub stringValue];
//    
//
//	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//	NSLog(@"itemsArray %@", itemsArray );
//    
//    NSString* ncxFileName;
//	
//    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
//	for (CXMLElement* element in itemsArray) {
//    //字典存储元素
//		[itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
//        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
//            //最后一次时ncxFileName是toc.ncx
//            ncxFileName = [[element attributeForName:@"href"] stringValue];
////          NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
//        }
//	}
//	
//    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
//    //文件夹OPS的地址
//	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
//    //解析toc.ncx文件。toc.ncx用来制作书的目录
//    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
//    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
//    for (CXMLElement* element in itemsArray) {
//        //取网页文档的名称
//        NSString* href = [[element attributeForName:@"href"] stringValue];
//        //src=网页名字，navLabel标签下的text标签值（即章节名）
//        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
//        NSLog(@"xpath===%@",xpath);
//        //从toc.ncx匹配src=网页名称
//        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//        NSLog(@"nav===%@",navPoints);
//        if([navPoints count]!=0){
//            CXMLElement* titleElement = [navPoints objectAtIndex:0];
//            NSLog(@"tltleelement=====%@",[titleElement stringValue]);
//            //key网页名对应章节名存入字典
//           [titleDictionary setValue:[titleElement stringValue] forKey:href];
//        }
//    }
//
//	
//	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
////	NSLog(@"itemRefsArray size: %d", [itemRefsArray count]);
//	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
//    int count = 0;
//	for (CXMLElement* element in itemRefsArray) {
//        //取出网页名
//        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
//
//        Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]
//                                                       title:[titleDictionary valueForKey:chapHref] 
//                                                chapterIndex:count++];
//        
//        //每个html文档转化为txt挨个存入的数组
//		[tmpArray addObject:tmpChapter];
//		
//		[tmpChapter release];
//	}
//	//存每个网页内容的数组，每一项都为Chapter类型
//	self.spineArray = [NSArray arrayWithArray:tmpArray]; 
//	NSLog(@"out for");
//	[opfFile release];
//	[tmpArray release];
//	[ncxToc release];
//	[itemDictionary release];
//	[titleDictionary release];
//}

- (void)dealloc {
    [spineArray release];
	[epubFilePath release];
    [super dealloc];
}

@end
