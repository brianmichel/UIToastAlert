//
//  UIToastWindow.h
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UIToastWindowPosition {
  UIToastWindowPositionTop = 1 << 0,
  UIToastWindowPositionBottom = 1 << 1
} UIToastWindowPosition;

@interface UIToastWindow : UIWindow {
  NSTimeInterval _animationDuration;
  NSTimeInterval _showDuration;
  
  UILabel *_messageLabel;
  
  UIToastWindowPosition _position;
  NSTimer *_dismissTimer;
}

@property (nonatomic, assign) NSTimeInterval _duration;
@property (nonatomic, retain) NSTimer *_dismissTimer;
@property (nonatomic, retain) UILabel *_messageLabel;
@property (nonatomic, readonly) UIToastWindowPosition _position;

- (id)initWithMessage:(NSString *)message duration:(NSTimeInterval)duration position:(UIToastWindowPosition)position;
- (void)show;
@end
