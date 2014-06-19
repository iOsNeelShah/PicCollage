//
//  PickerView.h
//  ImageUploading
//
//  Created by Neel Shah on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PickerControllerTypeLib,
    PickerControllerTypeCam,
    PickerControllerTypeBoth,
}
PickerControllerType;

@interface ImagePickerView : UIImagePickerController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    PickerControllerType type;
    
    UIPopoverController *popOverForIpad;
    
    UIImage *imgPicker;
    UIViewController *ViewToShowPicker;
    UIButton *btniPadSeletedFrame;
}

@property (nonatomic, assign) PickerControllerType type;
@property(nonatomic,copy)void (^onImageSelect)(UIImage * imgSelected);

-(void)OpenActionSheet:(UIViewController *)ViewCont BtniPadPopOverFrame:(UIButton *)BtnTemp;

@end
