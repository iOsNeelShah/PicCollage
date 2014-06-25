//
//  MakeCollageViewController.m
//  PicCollage
//
//  Created by Neel Shah on 19/06/14.
//  Copyright (c) 2014 com.solutionanalysts. All rights reserved.
//

#import "MakeCollageViewController.h"
#import "ImagePickerView.h"
#import "UIImage+Resize.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (NSCoding)
- (id)initWithCoderImage:(NSCoder *)decoder;
- (void)encodeWithCoderImage:(NSCoder *)encoder;
@end

@implementation UIImage (NSCoding)
- (id)initWithCoderImage:(NSCoder *)decoder {
    NSData *pngData = [decoder decodeObjectForKey:@"PNGRepresentation"];
    self = [[UIImage alloc] initWithData:pngData];
    return self;
}
- (void)encodeWithCoderImage:(NSCoder *)encoder {
    [encoder encodeObject:UIImageJPEGRepresentation(self,0) forKey:@"PNGRepresentation"];
}
@end


@interface MakeCollageViewController ()

@end

@implementation MakeCollageViewController

@synthesize imagePickerView;

@synthesize isEdit,sPlistName,iIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	imagePickerView=[[ImagePickerView alloc] init];
	imagePickerView.type=PickerControllerTypeBoth;
	
	//Prepare to animate
	self.view.alpha = 0;
	self.view.transform = CGAffineTransformMakeScale(0.6,0.6);
	//Animate
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	self.view.alpha = 1;
	self.view.transform = CGAffineTransformMakeScale(1,1);
	[UIView commitAnimations];
	
	
	mArrPlistData=[[NSMutableArray alloc] init];
	iIndexValue=20000;
	
	if (isEdit) {
		NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [sysPaths objectAtIndex:0];
		
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",sPlistName]];
		
		NSLog(@"Plist File Path: %@", filePath);
		
		// Step2: Define mutable dictionary
		
		NSMutableDictionary *plistDict;
		
		// Step3: Check if file exists at path and read data from the file if exists
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
		{
			plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
		}
		NSLog(@"plistDict==%@",[plistDict description]);
		
		mArrPlistData=[NSMutableArray arrayWithArray:[plistDict objectForKey:@"scraps"]];
		
		for (int i=0; i<[mArrPlistData count]; i++) {
			NSURL *referenceURL =[NSURL URLWithString:[[[mArrPlistData objectAtIndex:i] objectForKey:@"image"] objectForKey:@"source_url"]];
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
				
				
				NSDictionary *dicFrame=[[mArrPlistData objectAtIndex:i] objectForKey:@"frame"];
				NSDictionary *dicTransform=[[mArrPlistData objectAtIndex:i] objectForKey:@"transform"];
				
				UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake([[dicFrame objectForKey:@"x"] doubleValue], [[dicFrame objectForKey:@"y"] doubleValue], [[dicFrame objectForKey:@"base_width"] doubleValue], [[dicFrame objectForKey:@"base_height"] doubleValue])];
				
				imgView.center=CGPointMake([[dicFrame objectForKey:@"center_x"] doubleValue], [[dicFrame objectForKey:@"center_y"] doubleValue]);
				
				imgView.image=[[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(500,500) interpolationQuality:kCGInterpolationDefault];
				
				imgView.contentMode = UIViewContentModeScaleAspectFit;
				
				CGAffineTransform transform = CGAffineTransformMake([[dicTransform objectForKey:@"a"] doubleValue], [[dicTransform objectForKey:@"b"] doubleValue],[[dicTransform objectForKey:@"c"] doubleValue], [[dicTransform objectForKey:@"d"] doubleValue], 0, 0);
				
//				float scale = sqrt(transform.a*transform.a + transform.d*transform.d);
				
				imgView.transform = transform;
				
//				imgView.transform = CGAffineTransformScale(transform, scale,  scale);
				
				imgView.userInteractionEnabled=TRUE;
				
				imgView.tag=iIndexValue;
				
				pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
				[pinchRecognizer setDelegate:self];
				[imgView addGestureRecognizer:pinchRecognizer];
				
				rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
				[rotationRecognizer setDelegate:self];
				[imgView addGestureRecognizer:rotationRecognizer];
				
				
				panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
				[panRecognizer setMinimumNumberOfTouches:1];
				//[panRecognizer setMaximumNumberOfTouches:1];
				[panRecognizer setDelegate:self];
				[imgView addGestureRecognizer:panRecognizer];
				
				
				tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
				//[tapRecognizer setNumberOfTapsRequired:1];
				tapRecognizer.numberOfTapsRequired = 1;
				tapRecognizer.numberOfTouchesRequired = 1;
				[tapRecognizer setDelegate:self];
				[imgView addGestureRecognizer:tapRecognizer];

				
				[self.view addSubview:imgView];
				
				[self.view bringSubviewToFront:IBbtnGetImage];
				[self.view bringSubviewToFront:IBbtnBack];
				
				
				iIndexValue++;
				
			} failureBlock:^(NSError *error) {
				
			}];
			
			library=nil;

		}
	}
	else
	{
		lastRotation=0.0;
		lastScale=1.0;
	}
	
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UIButton Action

-(IBAction)btnBackSaveTap
{
	IBbtnBack.hidden=TRUE;
	IBbtnGetImage.hidden=TRUE;
	
	UIImage *tempImage = [self captureScreenInRect:self.view.frame];
	
	
	NSTimeInterval time=[APP_DELEGATE saveImage:tempImage isEdit:isEdit index:iIndex];
	
	// Step1: Get plist file path
	
	NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [sysPaths objectAtIndex:0];
	
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.plist",time]];
	
	NSLog(@"Plist File Path: %@", filePath);
	
	// Step2: Define mutable dictionary
	
	NSMutableDictionary *plistDict;
	
	// Step3: Check if file exists at path and read data from the file if exists
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	}
	else
	{
		// Step4: If doesn't exist, start with an empty dictionary
		plistDict = [[NSMutableDictionary alloc] init];
	}
	
	NSLog(@"plist data: %@", [plistDict description]);
	
	// Step5: Set data in dictionary
	
	[plistDict setValue:mArrPlistData forKey: @"scraps"];
	
	// Step6: Write data from the mutable dictionary to the plist file
	
	BOOL didWriteToFile = [plistDict writeToFile:filePath atomically:YES];
	
	if (didWriteToFile)
	{
		NSLog(@"Write to .plist file is a SUCCESS!");
	}
	
	else
	{
		NSLog(@"Write to .plist file is a FAILURE!");
	}
	
	
	for (UIView *view in self.view.subviews) {
		[view removeFromSuperview];
	}
	
	[self.navigationController popViewControllerAnimated:NO];
	imagePickerView=nil;
}

-(IBAction)btnOpenAction
{
	__block __weak ImagePickerView *imgPicker=imagePickerView;
	[imgPicker OpenActionSheet:self BtniPadPopOverFrame:IBbtnGetImage];
    imgPicker.onImageSelect=^(UIImage *imgSelected,NSDictionary *dicInfo){
        //Work with Image Here
		NSLog(@"===%@",[dicInfo objectForKey:UIImagePickerControllerReferenceURL]);
		NSURL *referenceURL = [dicInfo objectForKey:UIImagePickerControllerReferenceURL];
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
			[self setImageInView:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]]];
			
			UIImageView *img=(UIImageView *)[self.view viewWithTag:iIndexValue];
			NSArray *arrDicValue=[self setFrameAndTransform:img];
			
			
			NSDictionary *dicImageURL=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[dicInfo objectForKey:UIImagePickerControllerReferenceURL]] forKey:@"source_url"];
			
			NSDictionary *dicValue=[NSDictionary dictionaryWithObjectsAndKeys:
									[arrDicValue objectAtIndex:1],@"transform",
									[arrDicValue objectAtIndex:0],@"frame",
									dicImageURL,@"image",
									nil];
			
			[mArrPlistData addObject:dicValue];
			
			dicValue=nil;
			dicImageURL=nil;
			arrDicValue=nil;
			
			NSLog(@"mArrPlistData===%@",mArrPlistData);
			
			iIndexValue++;
			
		} failureBlock:^(NSError *error) {
			
		}];
		library=nil;
		imgPicker=nil;
    };
}


#pragma mark - Private Methods

- (CGFloat)xscale:(CGAffineTransform)transform {
    return sqrt(transform.a * transform.a + transform.c * transform.c);
}

- (CGFloat)yscale:(CGAffineTransform)transform{
    return sqrt(transform.b * transform.b + transform.d * transform.d);
}

-(NSArray *)setFrameAndTransform:(UIImageView *)imgView
{
	NSDictionary *dicTransform=[NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithFloat:imgView.transform.a],@"a",
								[NSNumber numberWithFloat:imgView.transform.b],@"b",
								[NSNumber numberWithFloat:imgView.transform.c],@"c",
								[NSNumber numberWithFloat:imgView.transform.d],@"d",
								nil];
	
	NSDictionary *dicFrame=[NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithFloat:imgView.center.x],@"center_x",
							[NSNumber numberWithFloat:imgView.center.y],@"center_y",
							[NSNumber numberWithFloat:imgView.frame.origin.x],@"x",
							[NSNumber numberWithFloat:imgView.frame.origin.y],@"y",
							[NSNumber numberWithFloat:imgView.frame.size.width],@"base_width",
							[NSNumber numberWithFloat:imgView.frame.size.height],@"base_height",
							nil];
	
	
	return [NSArray arrayWithObjects:dicFrame,dicTransform, nil];
}

-(void)setImageInView:(UIImage *)image
{
	UIImageView *imageview;
	imageview = [[UIImageView alloc] initWithFrame:CGRectMake(arc4random() % (320-250), arc4random() % (460-250), image.size.width/6, image.size.height/6)];
	imageview.contentMode = UIViewContentModeScaleAspectFit;
	
	imageview.backgroundColor=[UIColor redColor];
	
	CALayer *layer1 = [imageview layer];
	[layer1 setMasksToBounds:YES];
	[layer1 setBorderWidth:2.0];
	[layer1 setBorderColor:[[UIColor whiteColor] CGColor]];
	
	image= [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(500,500) interpolationQuality:kCGInterpolationDefault];
	
	//Prepare to animate
	imageview.alpha = 0;
	imageview.transform = CGAffineTransformMakeScale(0.2,0.2);
	//Animate
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	imageview.alpha = 1;
	imageview.userInteractionEnabled=TRUE;
	imageview.transform = CGAffineTransformMakeScale(1,1);
	imageview.transform = CGAffineTransformMakeRotation(arc4random() % 180);
	[UIView commitAnimations];
	
	[imageview setImage:image];
	
	pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[imageview addGestureRecognizer:pinchRecognizer];
	
	rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[imageview addGestureRecognizer:rotationRecognizer];
	
	
	panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	//[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[imageview addGestureRecognizer:panRecognizer];
	
	
	tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	//[tapRecognizer setNumberOfTapsRequired:1];
	tapRecognizer.numberOfTapsRequired = 1;
	tapRecognizer.numberOfTouchesRequired = 1;
	[tapRecognizer setDelegate:self];
	[imageview addGestureRecognizer:tapRecognizer];
	
	[self.view bringSubviewToFront:imageview];
	
	imageview.tag=iIndexValue;
	[self.view addSubview:imageview];
	
	[self.view bringSubviewToFront:IBbtnGetImage];
	[self.view bringSubviewToFront:IBbtnBack];
}

- (UIImage *)captureScreenInRect:(CGRect)captureFrame {
    CALayer *layer;
    layer = self.view.layer;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

#pragma mark - Gestures

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognize isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
	return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

-(void)scale:(id)sender {
	
	//[self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
	
	[self.view bringSubviewToFront:IBbtnGetImage];
    [self.view bringSubviewToFront:IBbtnBack];
    
	if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		NSArray *arrDicValue=[self setFrameAndTransform:(UIImageView *)[sender view]];
		
		NSMutableDictionary *mDic=[NSMutableDictionary dictionaryWithDictionary:[mArrPlistData objectAtIndex:[sender view].tag%20000]];
		[mDic setObject:[arrDicValue objectAtIndex:0] forKey:@"frame"];
		[mDic setObject:[arrDicValue objectAtIndex:1] forKey:@"transform"];
		
		[mArrPlistData replaceObjectAtIndex:[sender view].tag%20000 withObject:mDic];
		
		arrDicValue=nil;
		mDic=nil;
		
		lastScale = 1.0;
		return;
	}
	
	CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
	
	[[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)rotate:(id)sender {
	
	//[self.view bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
    
    [self.view bringSubviewToFront:IBbtnGetImage];
    [self.view bringSubviewToFront:IBbtnBack];
    
	
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		NSArray *arrDicValue=[self setFrameAndTransform:(UIImageView *)[sender view]];
		
		NSMutableDictionary *mDic=[NSMutableDictionary dictionaryWithDictionary:[mArrPlistData objectAtIndex:[sender view].tag%20000]];
		[mDic setObject:[arrDicValue objectAtIndex:0] forKey:@"frame"];
		[mDic setObject:[arrDicValue objectAtIndex:1] forKey:@"transform"];
		
		[mArrPlistData replaceObjectAtIndex:[sender view].tag%20000 withObject:mDic];
		
		arrDicValue=nil;
		mDic=nil;
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
	
	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    
}

-(void)move:(id)sender {
	
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	
	//[self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    [self.view bringSubviewToFront:IBbtnGetImage];
    [self.view bringSubviewToFront:IBbtnBack];
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		
		firstX = [[sender view] center].x;
		firstY = [[sender view] center].y;
	}
	else if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
	{
		NSArray *arrDicValue=[self setFrameAndTransform:(UIImageView *)[sender view]];
		
		NSMutableDictionary *mDic=[NSMutableDictionary dictionaryWithDictionary:[mArrPlistData objectAtIndex:[sender view].tag%20000]];
		[mDic setObject:[arrDicValue objectAtIndex:0] forKey:@"frame"];
		[mDic setObject:[arrDicValue objectAtIndex:1] forKey:@"transform"];
		
		[mArrPlistData replaceObjectAtIndex:[sender view].tag%20000 withObject:mDic];
		
		arrDicValue=nil;
		mDic=nil;
	}
	
	translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
	[[sender view] setCenter:translatedPoint];
}

-(void)tapped:(id)sender
{
    
    [self.view bringSubviewToFront:[(UITapGestureRecognizer*)sender view]];
    [self.view bringSubviewToFront:IBbtnGetImage];
    [self.view bringSubviewToFront:IBbtnBack];
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
