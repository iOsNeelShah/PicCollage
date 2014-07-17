//
//  MakeCollageViewController.h
//  PicCollage
//
//  Created by Neel Shah on 19/06/14.
//  Copyright (c) 2014 com.solutionanalysts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePickerView;
@interface MakeCollageViewController : UIViewController<UIGestureRecognizerDelegate>
{
	IBOutlet UIButton *IBbtnBack;
	IBOutlet UIButton *IBbtnGetImage;
	
	UIPinchGestureRecognizer *pinchRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
    UIPanGestureRecognizer *panRecognizer;
    UITapGestureRecognizer *tapRecognizer;
	UILongPressGestureRecognizer *longPressGesture;
	
	CGFloat lastScale;
	CGFloat lastRotation;
	
	CGFloat firstX;
	CGFloat firstY;
	
	int iIndexValue;
	
	UIImageView *pieceForReset;
}

@property (nonatomic, strong)ImagePickerView *imagePickerView;

@property (nonatomic,readwrite)BOOL isEdit;
@property (nonatomic,readwrite)int iIndex;

@end
