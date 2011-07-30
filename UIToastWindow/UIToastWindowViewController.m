//
//  UIToastWindowViewController.m
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIToastWindowViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIToastWindow.h"


@implementation UIToastWindowViewController

@synthesize textView;
@synthesize testButton;
@synthesize segControl;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
  [super viewDidLoad];
}

- (IBAction)makeToast:(id)sender {
  [self.textView resignFirstResponder];
  UIToastWindowPosition position;
  switch (self.segControl.selectedSegmentIndex) {
    case 0:
      position = UIToastWindowPositionTop;
      break;
    case 1:
      position = UIToastWindowPositionBottom;
      break;
    default:
      break;
  }
  
  UIToastWindow *toast = [[UIToastWindow alloc] initWithMessage:self.textView.text duration:0.5 position:position];
  [toast show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

@end
