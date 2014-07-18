//
//  AppDelegate.m
//  PicCollage
//
//  Created by Neel Shah on 18/06/14.
//  Copyright (c) 2014 com.solutionanalysts. All rights reserved.
//

#import "AppDelegate.h"
#import "ScrollCollageViewController.h"

@implementation AppDelegate

@synthesize mArrSavedImageName;
@synthesize mArrSavedView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	//Get Image Name
	mArrSavedImageName=[[NSMutableArray alloc] initWithCapacity:10];
	
	NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_SAVEIMAGE_ARRAY];
    mArrSavedImageName = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data2];
	//End
	
	//Get View
	//Changes
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:PREF_SAVEVIEW_ARRAY];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:10];
    tmpArray = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    mArrSavedView = [[NSMutableArray alloc] init];
    if([tmpArray count]>0)
    {
        mArrSavedView = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];;
    }
    //End
	
	ScrollCollageViewController *scrollCollageViewController=[[ScrollCollageViewController alloc] init];
	
	UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:scrollCollageViewController];
	
	navi.navigationBarHidden=TRUE;
	
	self.window.rootViewController=navi;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma -
#pragma Saving/Loading/removing Images from documents directory

//saving an image

- (NSTimeInterval)saveImage:(UIImage*)image isEdit:(BOOL)isEdit index:(int)arrayIndex
{
	if (mArrSavedImageName==nil) {
		mArrSavedImageName=[[NSMutableArray alloc] initWithCapacity:10];
	}
    NSDate*date = [NSDate date];
    NSString *imagePath;
    NSData *imageDate;
    
    NSTimeInterval timeInterval;
    //NSLog(@"\n time = %f",timeInterval);
	
    if (isEdit) {
        imagePath = [DOCUMENTS_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[mArrSavedImageName objectAtIndex:arrayIndex]]];
        NSLog(@"ImagePath-----%@",imagePath);
		timeInterval = [[mArrSavedImageName objectAtIndex:arrayIndex] doubleValue];
        imageDate = [NSData dataWithData:UIImagePNGRepresentation(image)];
		
    }
    else
    {
		timeInterval = [date timeIntervalSince1970];
        imagePath = [DOCUMENTS_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.png",timeInterval]];
        imageDate = [NSData dataWithData:UIImagePNGRepresentation(image)];
    }
    
    if(imageDate)
    {
        [imageDate writeToFile: imagePath atomically: YES];
        
		if(isEdit == NO)
		{
			[mArrSavedImageName addObject:[NSString stringWithFormat:@"%f", timeInterval]];
		}
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData *data1=[NSKeyedArchiver archivedDataWithRootObject:mArrSavedImageName];
        [defaults setObject:data1 forKey:PREF_SAVEIMAGE_ARRAY];
		[defaults synchronize];
    }
	
	return timeInterval;
}

-(void)Deleteimage:(int)imageName
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",imageName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:imagePath error:NULL];
}

@end
