//
//  LKAppDelegate.m
//  BLOBDemo
//
//  Created by ljh on 14-7-17.
//  Copyright (c) 2014年 LJH. All rights reserved.
//

#import "LKAppDelegate.h"
#import "LKDBHelper.h"

//save the blob type
@interface LKBLOBTest : NSObject
@property(strong,nonatomic)UIImage* image;
@end

@implementation LKBLOBTest
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LKDBHelper alloc]initWithDBPath:[LKDBUtils getPathForDocuments:@"haha.db" inDir:@"blah"]];
    });
    return helper;
}
+(void)initialize
{
    [self setUserCalculateForCN:@"image"];
    [[self getUsingLKDBHelper] createTableWithModelClass:self];
}
-(id)userGetValueForModel:(LKDBProperty *)property
{
    NSData* data = UIImagePNGRepresentation(self.image);
    
    //In order to match with your original database column
    return data;
}
-(void)userSetValueForModel:(LKDBProperty *)property value:(id)value
{
    if([value isKindOfClass:[NSData class]])
    {
        NSData* data = value;
        UIImage* image = [UIImage imageWithData:data];
        self.image = image;
    }
}
@end


//save the file path type
@interface LKBLOBTestUseLKDB : NSObject
@property(strong,nonatomic)UIImage* image;
@end
@implementation LKBLOBTestUseLKDB
+(void)initialize
{
    [[self getUsingLKDBHelper] createTableWithModelClass:self];
}
+(LKDBHelper *)getUsingLKDBHelper
{
    return [LKBLOBTest getUsingLKDBHelper];
}
@end

@implementation LKAppDelegate
+(void)initialize
{
    NSString* dbpath = [[NSBundle mainBundle] pathForResource:@"BLOB" ofType:@"db"];
    [[NSFileManager defaultManager] copyItemAtPath:dbpath toPath:[LKDBUtils getPathForDocuments:@"haha.db" inDir:@"blah"] error:nil];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ///save image blob
    LKBLOBTest* test = [LKBLOBTest searchSingleWithWhere:nil orderBy:@"rowid"];
    test.rowid = 1000;
    NSLog(@"%@",test.image);
    [test saveToDB];

    
    ///save image file path
    LKBLOBTestUseLKDB* test2 = [LKBLOBTestUseLKDB new];
    test2.image = [UIImage imageNamed:@"41.png"];
    [test2 saveToDB];

    
    return YES;
}
@end
