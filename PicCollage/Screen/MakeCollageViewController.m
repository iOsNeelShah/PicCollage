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
	
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UIButton Action

-(IBAction)btnBackSaveTap
{
	IBbtnBack.hidden=TRUE;
	IBbtnGetImage.hidden=TRUE;
	
	UIImage *tempImage = [self captureScreenInRect:self.view.frame];
	
	[APP_DELEGATE saveImage:tempImage isEdit:FALSE index:0];
	
	[self.navigationController popViewControllerAnimated:NO];
	imagePickerView=nil;
}

-(IBAction)btnOpenAction
{
	__block __weak ImagePickerView *imgPicker=imagePickerView;
	[imgPicker OpenActionSheet:self BtniPadPopOverFrame:IBbtnGetImage];
    imgPicker.onImageSelect=^(UIImage *imgSelected){
        //Work with Image Here
        [self setImageInView:imgSelected];
		imgPicker=nil;
    };
}


#pragma mark - Private Methods

-(void)setImageInView:(UIImage *)image
{
	UIImageView *imageview;
	imageview = [[UIImageView alloc] initWithFrame:CGRectMake(arc4random() % (320-250), arc4random() % (460-250), image.size.width/6, image.size.height/6)];
	imageview.contentMode = UIViewContentModeScaleAspectFit;
	
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
