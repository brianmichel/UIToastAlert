//
//  UIToastWindow.m
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIToastWindow.h"
#import <QuartzCore/QuartzCore.h>

#define kAlertFadePixelAmount 30
#define kAlertFadeDuration 0.3f
#define kAlertDefaultPadding 10.0f
#define kAlertDefaultWidth UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 200.0f : 400.0f
#define kAlertDefaultBaseColor [UIColor colorWithHue:(231.0/360.0) saturation:0.90 brightness:0.25 alpha:1.0]

@interface UIToastWindow (Private)
- (void)dismiss;
@end

@implementation UIToastWindow

@synthesize _duration;
@synthesize _position;
@synthesize _messageLabel;
@synthesize _dismissTimer;

+ (Class)layerClass
{
	return [CAGradientLayer class];
}
  
- (id)initWithMessage:(NSString *)message duration:(NSTimeInterval)duration position:(UIToastWindowPosition)position {
  self = [super init];
  if (self) {
    self._messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self._messageLabel.text = message;
    self._messageLabel.backgroundColor = [UIColor clearColor];
    self._messageLabel.textColor = [UIColor whiteColor];
    self._messageLabel.textAlignment = UITextAlignmentCenter;
    self._messageLabel.shadowOffset = CGSizeMake(0, -1);
    self._messageLabel.shadowColor = [UIColor darkGrayColor];
    self._messageLabel.numberOfLines = 0;
    [self._messageLabel sizeToFit];
    [self addSubview:self._messageLabel];
    
    self.windowLevel = UIWindowLevelAlert;
    self.alpha = 0;
    
    self._duration = duration;
    _position = position;
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors =
		[NSArray arrayWithObjects:
     (__bridge id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor,
     (__bridge id)kAlertDefaultBaseColor.CGColor,
     nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.20], nil];

    gradientLayer.borderColor = [[UIColor whiteColor] CGColor];
    gradientLayer.borderWidth = 2.0f;
    gradientLayer.cornerRadius = 7.0f;
    
    gradientLayer.shadowColor = [[UIColor blackColor] CGColor];
    gradientLayer.shadowOpacity = 2.0f;
    gradientLayer.shadowOffset = CGSizeMake(0, 0);
    gradientLayer.masksToBounds = NO;

    [self layoutSubviews];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize contraintRect = CGSizeMake(kAlertDefaultWidth - (kAlertDefaultPadding * 2), CGFLOAT_MAX);
  
  CGSize sizeOfLabel = [self._messageLabel.text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:contraintRect lineBreakMode:UILineBreakModeWordWrap];
  
  CGSize sizeOfWindow = CGSizeMake(sizeOfLabel.width + (kAlertDefaultPadding * 2), sizeOfLabel.height + (kAlertDefaultPadding * 2));
  
  self._messageLabel.frame = CGRectMake(0, 0, sizeOfLabel.width, sizeOfLabel.height);
  
  self.frame = CGRectMake(0, 0, sizeOfWindow.width, sizeOfWindow.height);
  switch (self._position) {
    case UIToastWindowPositionTop:
      self.frame = CGRectMake(round([UIScreen mainScreen].bounds.size.width/2 - self.frame.size.width/2), [UIScreen mainScreen].bounds.origin.y + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
      break;
    case UIToastWindowPositionBottom:
      self.frame = CGRectMake(round([UIScreen mainScreen].bounds.size.width/2 - self.frame.size.width/2), [UIScreen mainScreen].bounds.origin.y + [UIScreen mainScreen].bounds.size.height - self.frame.size.height - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
      break;
    default:
      break;
  }
  
  self._messageLabel.frame = CGRectMake(kAlertDefaultPadding, kAlertDefaultPadding, self._messageLabel.frame.size.width, self._messageLabel.frame.size.height);
  self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

- (void)show {
  [self makeKeyAndVisible];
  
  [UIView animateWithDuration:kAlertFadeDuration animations:^(void){
    switch (self._position) {
      case UIToastWindowPositionTop:
        self.frame = CGRectMake(round([UIScreen mainScreen].bounds.size.width/2 - self.frame.size.width/2), self.frame.origin.y + self.frame.size.height + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        break;
      case UIToastWindowPositionBottom:
        self.frame = CGRectMake(round([UIScreen mainScreen].bounds.size.width/2 - self.frame.size.width/2), [UIScreen mainScreen].bounds.size.height - self.frame.size.height - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        break;
      default:
        break;
    }
  } completion:^(BOOL finished) {
    [self._dismissTimer invalidate];
    self._dismissTimer = [NSTimer scheduledTimerWithTimeInterval:self._duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
  }];
}

- (void)dismiss {
  [self._dismissTimer invalidate];
  [UIView animateWithDuration:kAlertFadeDuration animations:^(void){
    switch (self._position) {
      case UIToastWindowPositionTop:
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
        break;
      case UIToastWindowPositionBottom:
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
        break;
      default:
        break;
    }
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

- (void)dealloc {
  [_dismissTimer invalidate];
}


@end
