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
@interface ImageModel : NSObject
@property int _id;
@property(strong,nonatomic)NSString* fr;
@property(strong,nonatomic)NSString* ar;
@property(strong,nonatomic)UIImage* img;
@end

@implementation ImageModel
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LKDBHelper alloc]initWithDBPath:[LKDBUtils getPathForDocuments:@"ChentayyebFR.db" inDir:@"blah"]];
    });
    return helper;
}
+(void)initialize
{
    [self setUserCalculateForCN:@"img"];
    [[self getUsingLKDBHelper] createTableWithModelClass:self];
}
+(NSString *)getTableName
{
    return @"lexi";
}
-(id)userGetValueForModel:(LKDBProperty *)property
{
    NSData* data = UIImagePNGRepresentation(self.img);
    
    //In order to match with your original database column
    return data;
}
-(void)userSetValueForModel:(LKDBProperty *)property value:(id)value
{
    if([value isKindOfClass:[NSData class]])
    {
        NSData* data = value;
        UIImage* image = [UIImage imageWithData:data];
        self.img = image;
    }
}
@end

@implementation LKAppDelegate
+(void)initialize
{
    NSString* dbpath = [[NSBundle mainBundle] pathForResource:@"ChentayyebFR" ofType:@"db"];
    [[NSFileManager defaultManager] copyItemAtPath:dbpath toPath:[LKDBUtils getPathForDocuments:@"ChentayyebFR.db" inDir:@"blah"] error:nil];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSArray* models = [ImageModel searchWithWhere:nil orderBy:nil offset:0 count:0];
    
    int i =0;
    for (ImageModel* imageModel in models) {
        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(150*i%2, 50 * i/2, 140, 40)];
        view.image = imageModel.img;
        [_window addSubview:view];
        i++;
    }
    
    return YES;
}
@end
