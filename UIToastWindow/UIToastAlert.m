//
//  UIToastAlert.m
//  UIToastAlert
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import "UIToastAlert.h"
#import <QuartzCore/QuartzCore.h>

#define kUIToastWindowLongDuration 2.0
#define kUIToastWindowShortDuration 0.5

#define kAlertFadePixelAmount 30
#define kAlertFadeDuration 0.3f
#define kAlertDefaultPadding 10.0f
#define kAlertDefaultWidth UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 200.0f : 400.0f
#define kAlertDefaultBaseColor [UIColor colorWithHue:(231.0/360.0) saturation:0.90 brightness:0.25 alpha:1.0]

CGRect get_screen_rect() {
  CGRect screenRect; 
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    screenRect =  UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 1024, 768);
  } else {
    screenRect = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? CGRectMake(0, 0, 320, 480) : CGRectMake(0, 0, 480, 320);
  }
  return screenRect;
}


@interface UIToastAlert (Private)
- (void)setup;
- (void)dismiss;
@end

@implementation UIToastAlert

@synthesize _showDuration;
@synthesize _animationDuration;
@synthesize _position;
@synthesize _messageLabel;
@synthesize _dismissTimer;
@synthesize _tintColor;
@synthesize _lightText;

#pragma mark - Setup
+ (Class)layerClass
{
	return [CAGradientLayer class];
}

- (id)initWithMessage:(NSString *)message showDuration:(NSTimeInterval)showDuration fadeDuration:(NSTimeInterval)fadeDuration position:(UIToastAlertPosition)position tintColor:(UIColor *)tintColor lightText:(BOOL)lightText {
  self = [super init];
  if (self) {
    
    //Configure the message label
    self._messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self._messageLabel.text = message;
    self._messageLabel.backgroundColor = [UIColor clearColor];
    self._messageLabel.textColor = [UIColor whiteColor];
    self._messageLabel.textAlignment = UITextAlignmentCenter;
    self._messageLabel.shadowOffset = CGSizeMake(0, -1);
    self._messageLabel.shadowColor = [UIColor blackColor];
    self._messageLabel.numberOfLines = 0;
    [self._messageLabel sizeToFit];
    [self addSubview:self._messageLabel];
    
    self.alpha = 0;
    
    //Configure the options
    self._showDuration = showDuration;
    self._animationDuration = fadeDuration;
    self._lightText = lightText;
    self._position = position;
    
    //Configure the gradient layer
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors =
		[NSArray arrayWithObjects:
     (__bridge id)[UIColor colorWithWhite:1.0 alpha:0.80].CGColor,
     (__bridge id)kAlertDefaultBaseColor.CGColor,
     nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00], [NSNumber numberWithFloat:0.20], nil];
    
    gradientLayer.borderColor = [[UIColor whiteColor] CGColor];
    gradientLayer.borderWidth = 2.0f;
    gradientLayer.cornerRadius = 7.0f;
    
    gradientLayer.shadowColor = [[UIColor blackColor] CGColor];
    gradientLayer.shadowOpacity = 2.0f;
    gradientLayer.shadowOffset = CGSizeMake(0, 0);
    gradientLayer.masksToBounds = NO;
    
    self._messageLabel.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self layoutSubviews];
  }
  return self;
}

- (void)setup {
  self.backgroundColor = self._tintColor ? self._tintColor : kAlertDefaultBaseColor;
  self._showDuration = self._showDuration ? self._showDuration : kUIToastWindowShortDuration;
  self._animationDuration = self._animationDuration ? self._animationDuration : kAlertFadeDuration;
  CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
  UIColor *tintColorToUse = self._tintColor ? self._tintColor : kAlertDefaultBaseColor;
  gradientLayer.colors =
  [NSArray arrayWithObjects:
   (__bridge id)[UIColor colorWithWhite:1.0 alpha:0.80].CGColor,
   (__bridge id)tintColorToUse.CGColor,
   nil];
  
  if (self._lightText) {
    self._messageLabel.textColor = [UIColor blackColor];
    self._messageLabel.shadowColor = [UIColor whiteColor];
  }
}

#pragma mark - Layout
- (void)layoutSubviews {
  [super layoutSubviews];
  [self setup];
  
  CGRect screenRect = get_screen_rect();
  CGSize contraintRect = CGSizeMake(kAlertDefaultWidth - (kAlertDefaultPadding * 2), CGFLOAT_MAX);
  
  CGSize sizeOfLabel = [self._messageLabel.text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:contraintRect lineBreakMode:UILineBreakModeWordWrap];
  
  CGSize sizeOfWindow = CGSizeMake(round(sizeOfLabel.width + (kAlertDefaultPadding * 2)), round(sizeOfLabel.height + (kAlertDefaultPadding * 2)));
  
  self._messageLabel.frame = CGRectMake(0, 0, sizeOfLabel.width, sizeOfLabel.height);
  
  self.frame = CGRectMake(0, 0, sizeOfWindow.width, sizeOfWindow.height);
  switch (self._position) {
    case UIToastAlertPositionTop:
      self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), screenRect.origin.y + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
      break;
    case UIToastAlertPositionBottom:
      self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), screenRect.origin.y + screenRect.size.height - self.frame.size.height - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
      break;
    default:
      [NSException raise:@"Invalid UIToastWindowPosition Value" format:@"Value for UIToastWindowPosition %i is invalid.", self._position];
      break;
  }
  
  self._messageLabel.frame = CGRectMake(kAlertDefaultPadding, kAlertDefaultPadding, self._messageLabel.frame.size.width, self._messageLabel.frame.size.height);
  self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
  //TODO: Make layer.locations dynamic based on height. (looks pants otherwise.)
  //As the toast gets smaller you need to push the second stop down to get more of the white spread.
}

#pragma mark - Actions
- (void)show {
  CGRect screenRect = get_screen_rect();
  UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
  [window.rootViewController.view addSubview:self];

  [UIView animateWithDuration:self._animationDuration animations:^(void){
    switch (self._position) {
      case UIToastAlertPositionTop:
        self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), self.frame.origin.y + self.frame.size.height + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        break;
      case UIToastAlertPositionBottom:
        self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), screenRect.size.height - self.frame.size.height - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        break;
      default:
        [NSException raise:@"Invalid UIToastWindowPosition Value" format:@"Value for UIToastWindowPosition %i is invalid.", self._position];
        break;
    }
  } completion:^(BOOL finished) {
    [self._dismissTimer invalidate];
    self._dismissTimer = [NSTimer scheduledTimerWithTimeInterval:self._showDuration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
  }];
}

- (void)dismiss {
  [self._dismissTimer invalidate];
  [UIView animateWithDuration:self._animationDuration animations:^(void){
    switch (self._position) {
      case UIToastAlertPositionTop:
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
        break;
      case UIToastAlertPositionBottom:
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
        break;
      default:
        [NSException raise:@"Invalid UIToastWindowPosition Value" format:@"Value for UIToastWindowPosition %i is invalid.", self._position];
        break;
    }
  } completion:^(BOOL finished) {
    //TODO Could a [self release] actually go here for non ARC Code?
    [self removeFromSuperview];
  }];
}

#pragma mark - Convenience Methods
+ (UIToastAlert *)shortToastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position {
  return [UIToastAlert toastForMessage:message atPosition:position withDuration:kUIToastWindowShortDuration];
}

+ (UIToastAlert *)longToastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position {
  return [UIToastAlert toastForMessage:message atPosition:position withDuration:kUIToastWindowLongDuration];
}

+ (UIToastAlert *)toastForMessage:(NSString *)message {
  return [[UIToastAlert alloc] initWithMessage:message showDuration:kUIToastWindowShortDuration fadeDuration:kAlertFadeDuration position:UIToastAlertPositionBottom tintColor:nil lightText:NO];
}

+ (UIToastAlert *)toastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position withDuration:(NSTimeInterval)duration {
  return [[UIToastAlert alloc] initWithMessage:message showDuration:duration fadeDuration:kAlertFadeDuration position:position tintColor:nil lightText:NO];
}

#pragma mark - Memory Management
- (void)dealloc {
  [_dismissTimer invalidate];
}


@end
