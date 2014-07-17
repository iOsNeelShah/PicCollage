//
//  ScrollCollageViewController.m
//  PicCollage
//
//  Created by Neel Shah on 19/06/14.
//  Copyright (c) 2014 com.solutionanalysts. All rights reserved.
//

#import "ScrollCollageViewController.h"
#import "MakeCollageViewController.h"

@interface ScrollCollageViewController ()

@end

@implementation ScrollCollageViewController

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
	
	IBscrollImagesView.delegate = self;
	[IBscrollImagesView setBackgroundColor:[UIColor clearColor]];
	[IBscrollImagesView setCanCancelContentTouches:NO];
	
	IBscrollImagesView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	IBscrollImagesView.clipsToBounds = YES;
	IBscrollImagesView.scrollEnabled = YES;
	IBscrollImagesView.pagingEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	for(UIView *view in [IBscrollImagesView subviews])
    {
        [view removeFromSuperview];
    }
	
	CGFloat cx = 0;
	
	for (int i = 0;i < [APP_DELEGATE.mArrSavedImageName count] ; i++)
    {
		
		NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.png",[[APP_DELEGATE.mArrSavedImageName objectAtIndex:i] doubleValue]]];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		
		if (image == nil)
		{
			
		}
		else
		{
			
			UIButton *btnCustomStoreImage = [UIButton buttonWithType:UIButtonTypeCustom];
			//imageView.highlighted = NO;
			
			btnCustomStoreImage.contentMode = UIViewContentModeScaleToFill;
			
			[btnCustomStoreImage setImage:image forState:UIControlStateNormal];
			[btnCustomStoreImage setImage:image forState:UIControlStateHighlighted];
			
			btnCustomStoreImage.tag = i;
			[btnCustomStoreImage addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			CALayer *layer = [btnCustomStoreImage layer];
			[layer setMasksToBounds:YES];
			[layer setBorderWidth:5.0];
			[layer setBorderColor:[[UIColor whiteColor] CGColor]];
			
			CGRect rect = btnCustomStoreImage.frame;
			if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
			{
				rect.size.height = 355;
				rect.size.width = 200;
				rect.origin.x = ((IBscrollImagesView.frame.size.width - 200) / 2) + cx;
				rect.origin.y = ((IBscrollImagesView.frame.size.height - 230) / 2);
			}
			else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			{
				rect.size.height = 600;
				rect.size.width = 400;
				rect.origin.x = ((IBscrollImagesView.frame.size.width - 400) / 2) + cx;
				rect.origin.y = ((IBscrollImagesView.frame.size.height - 460) / 2);
			}
			
			btnCustomStoreImage.frame = rect;
			[IBscrollImagesView addSubview:btnCustomStoreImage];
			cx += IBscrollImagesView.frame.size.width;
		}
	}
	
	[IBscrollImagesView setContentSize:CGSizeMake(cx, [IBscrollImagesView bounds].size.height)];
}


#pragma mark - UIButton Actions

-(IBAction)btnAddNewTap
{
	@autoreleasepool {
		MakeCollageViewController *makeCollageViewController=[[MakeCollageViewController alloc] init];
		[self.navigationController pushViewController:makeCollageViewController animated:YES];
	}
}

-(void)imageClicked:(UIButton *)sender
{
	@autoreleasepool {
		MakeCollageViewController *makeCollageViewController=[[MakeCollageViewController alloc] init];
		makeCollageViewController.isEdit=TRUE;
		makeCollageViewController.iIndex=sender.tag;
		[self.navigationController pushViewController:makeCollageViewController animated:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
