//
//  AppDelegate.h
//  PicCollage
//
//  Created by Neel Shah on 18/06/14.
//  Copyright (c) 2014 com.solutionanalysts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain)NSMutableArray *mArrSavedImageName;

- (NSTimeInterval)saveImage:(UIImage*)image isEdit:(BOOL)isEdit index:(int)arrayIndex;

@end
