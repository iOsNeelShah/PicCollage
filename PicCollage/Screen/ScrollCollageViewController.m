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


#pragma mark - UIButton Actions

-(IBAction)btnAddNewTap
{
	@autoreleasepool {
		MakeCollageViewController *makeCollageViewController=[[MakeCollageViewController alloc] init];
		[self.navigationController pushViewController:makeCollageViewController animated:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
