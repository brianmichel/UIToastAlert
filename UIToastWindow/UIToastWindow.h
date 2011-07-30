//
//  UIToastWindow.h
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UIToastWindowPosition {
  UIToastWindowPositionTop = 1 << 0,
  UIToastWindowPositionBottom = 1 << 1
} UIToastWindowPosition;

@interface UIToastWindow : UIView {
  NSTimeInterval _animationDuration;
  NSTimeInterval _showDuration;
  
  UILabel *_messageLabel;
  NSTimer *_dismissTimer;
  
  UIColor *_tintColor;
  
  BOOL _lightText;
  
  UIToastWindowPosition _position;
}

@property (nonatomic, assign) NSTimeInterval _showDuration;
@property (nonatomic, assign) NSTimeInterval _animationDuration;
@property (nonatomic, retain) NSTimer *_dismissTimer;
@property (nonatomic, retain) UILabel *_messageLabel;
@property (nonatomic, retain) UIColor *_tintColor;
@property (nonatomic, assign) BOOL _lightText;
@property (nonatomic, readonly) UIToastWindowPosition _position;

+ (UIToastWindow *)shortToastForMessage:(NSString *)message atPosition:(UIToastWindowPosition)position;
+ (UIToastWindow *)longToastForMessage:(NSString *)message atPosition:(UIToastWindowPosition)position;

- (id)initWithMessage:(NSString *)message duration:(NSTimeInterval)duration position:(UIToastWindowPosition)position;
- (void)show;
@end
