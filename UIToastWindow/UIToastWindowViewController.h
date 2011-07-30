//
//  UIToastWindowViewController.h
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToastWindowViewController : UIViewController {
  IBOutlet UITextView *textView;
  IBOutlet UIButton *testButton;
  IBOutlet UISegmentedControl *segControl;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *testButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;

- (IBAction)makeToast:(id)sender;

@end
