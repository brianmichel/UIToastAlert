//
//  UIToastWindowViewController.m
//  UIToastAlert
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import "UIToastWindowViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIToastAlert.h"


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
  UIToastAlertPosition position;
  switch (self.segControl.selectedSegmentIndex) {
    case 0:
      position = UIToastAlertPositionTop;
      break;
    case 1:
      position = UIToastAlertPositionBottom;
      break;
    default:
      break;
  }

  UIToastAlert *toast = [UIToastAlert shortToastForMessage:self.textView.text atPosition:position];
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

- (void)dealloc {
  [textView release];
  [segControl release];
  [testButton release];
}

@end
