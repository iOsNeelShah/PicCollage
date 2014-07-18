//
//  PickerView.m
//  ImageUploading
//
//  Created by Neel Shah on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagePickerView.h"

#import <MobileCoreServices/UTCoreTypes.h>

@implementation ImagePickerView

@synthesize type,onImageSelect;


- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        // Initialization code
    }
    return self;
}


/*
Open ActionSheet Related to Selected Type.
 */
-(void)OpenActionSheet:(UIViewController *)ViewCont BtniPadPopOverFrame:(UIButton *)BtnTemp
{
    self.delegate=self;
    if (type==PickerControllerTypeBoth) {
        UIActionSheet *PickerActionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library",@"Camera", nil];
        [PickerActionSheet showInView:ViewCont.view];
        [PickerActionSheet release];
    }
    else if(type==PickerControllerTypeCam)
    {
        UIActionSheet *PickerActionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", nil];
        [PickerActionSheet showInView:ViewCont.view];
        [PickerActionSheet release];
    }
    else if(type==PickerControllerTypeLib)
    {
        UIActionSheet *PickerActionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", nil];
        [PickerActionSheet showInView:ViewCont.view];
        [PickerActionSheet release];
    }
    btniPadSeletedFrame=BtnTemp;
    ViewToShowPicker=ViewCont;
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    self.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage,nil];
    if (type==PickerControllerTypeBoth) {
        if (buttonIndex==0) {
            [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) 
            {
                if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
                    popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                    [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                }
                else
                {
                    popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                    [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
            else
            {
                [ViewToShowPicker presentViewController:self animated:YES completion:nil];
            }
        }
        else if(buttonIndex==1)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) 
                {
                    if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
                        popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                        [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                        
                    }
                    else
                    {
                        popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                        [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                }
                else
                {
                    [ViewToShowPicker  presentViewController:self animated:YES completion:nil];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No camera found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.delegate = self;
                [alert show];
                return;
            }
        }
    }
    else if(type==PickerControllerTypeCam)
    {
        if (buttonIndex==0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) 
                {
                    if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
                        popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                        [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                        
                    }
                    else
                    {
                        popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                        [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                }
                else
                {
                    [ViewToShowPicker  presentViewController:self animated:YES completion:nil];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No camera found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.delegate = self;
                [alert show];
                return;
            }
        }
    }
    else if(type==PickerControllerTypeLib)
    {
        if (buttonIndex==0) {
            [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) 
            {
                if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
                    popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                    [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                }
                else
                {
                    popOverForIpad =[[UIPopoverController alloc] initWithContentViewController:self]; 
                    [popOverForIpad presentPopoverFromRect:btniPadSeletedFrame.frame inView:ViewToShowPicker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
            else
            {
                [ViewToShowPicker  presentViewController:self animated:YES completion:nil];
            }
        }
    }
}

/*
 Method for doing correctOrienation to image taken from the Camera
 */

-(UIImage*)correctImageOrientation:(CGImageRef)image
{
    CGFloat width = CGImageGetWidth(image);//189;
    CGFloat height = CGImageGetHeight(image);//134;
    CGRect bounds = CGRectMake(0.0f, 0.0f, width, height);
    
    CGFloat boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(height, 0.0f);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0f);
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, - 1.0f, 1.0f);
    CGContextTranslateCTM(context, -height, 0.0f);
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), image);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

#pragma mark - imagePickerController Delegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil	];
    //[popoverController dismissPopoverAnimated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])
    {
        if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera) 
        {
            imgPicker=[self correctImageOrientation: [[info objectForKey:UIImagePickerControllerOriginalImage] CGImage]];
        }
        else
        {
            imgPicker=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    [imgPicker retain];
    self.onImageSelect(imgPicker,info);
    [self dismissViewControllerAnimated:YES completion:nil];
    [popOverForIpad dismissPopoverAnimated:YES];
}

@end
