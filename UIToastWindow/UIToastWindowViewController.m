//
//  UIToastWindowViewController.m
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
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
//  int random = arc4random() % 360;
//  
//  toast._tintColor = [UIColor colorWithHue:random * 0.01  saturation:1.0 brightness:1.0 alpha:1.0];
//  toast._lightText = random < 200 ? YES : NO;
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
  return YES;
}

@end
