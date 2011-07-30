//
//  UIToastAlert.h
//  UIToastAlert
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import <UIKit/UIKit.h>


CGRect get_screen_rect();

typedef enum UIToastAlertPosition {
  UIToastAlertPositionTop = 1 << 0,
  UIToastAlertPositionBottom = 1 << 1
} UIToastAlertPosition;

@interface UIToastAlert : UIView {
  NSTimeInterval _animationDuration;
  NSTimeInterval _showDuration;
  
  UILabel *_messageLabel;
  NSTimer *_dismissTimer;
  
  UIColor *_tintColor;
  
  BOOL _lightText;
  
  UIToastAlertPosition _position;
}

@property (nonatomic, assign) NSTimeInterval _showDuration;
@property (nonatomic, assign) NSTimeInterval _animationDuration;
@property (nonatomic, retain) NSTimer *_dismissTimer;
@property (nonatomic, retain) UILabel *_messageLabel;
@property (nonatomic, retain) UIColor *_tintColor;
@property (nonatomic, assign) BOOL _lightText;
@property (nonatomic, assign) UIToastAlertPosition _position;

+ (UIToastAlert *)toastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position withDuration:(NSTimeInterval)duration;
+ (UIToastAlert *)shortToastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position;
+ (UIToastAlert *)longToastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position;
+ (UIToastAlert *)toastForMessage:(NSString *)message;

- (id)initWithMessage:(NSString *)message showDuration:(NSTimeInterval)showDuration 
         fadeDuration:(NSTimeInterval)fadeDuration 
             position:(UIToastAlertPosition)position 
            tintColor:(UIColor *)tintColor 
            lightText:(BOOL)lightText;
- (void)show;
@end
