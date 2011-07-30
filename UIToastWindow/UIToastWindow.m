//
//  UIToastWindow.m
//  UIToastWindow
//
//  Created by Brian Michel on 7/28/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import "UIToastWindow.h"
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
    screenRect = [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 1024, 768);
  } else {
    screenRect = [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ? CGRectMake(0, 0, 320, 480) : CGRectMake(0, 0, 480, 320);
  }
  return screenRect;
}


@interface UIToastWindow (Private)
- (void)dismiss;
@end

@implementation UIToastWindow

@synthesize _duration;
@synthesize _position;
@synthesize _messageLabel;
@synthesize _dismissTimer;

#pragma mark - Setup
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
     (__bridge id)[UIColor whiteColor].CGColor,
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

    self.autoresizingMask = UIViewAutoresizingNone;
    
    [self layoutSubviews];
  }
  return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGRect screenRect = get_screen_rect();
  
  CGSize contraintRect = CGSizeMake(kAlertDefaultWidth - (kAlertDefaultPadding * 2), CGFLOAT_MAX);
  
  CGSize sizeOfLabel = [self._messageLabel.text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:contraintRect lineBreakMode:UILineBreakModeWordWrap];
  
  CGSize sizeOfWindow = CGSizeMake(sizeOfLabel.width + (kAlertDefaultPadding * 2), sizeOfLabel.height + (kAlertDefaultPadding * 2));
  
  self._messageLabel.frame = CGRectMake(0, 0, sizeOfLabel.width, sizeOfLabel.height);
  
  self.frame = CGRectMake(0, 0, sizeOfWindow.width, sizeOfWindow.height);
  switch (self._position) {
    case UIToastWindowPositionTop:
      self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), screenRect.origin.y + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
      break;
    case UIToastWindowPositionBottom:
      self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), screenRect.origin.y + screenRect.size.height - self.frame.size.height - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
      break;
    default:
      [NSException raise:@"Invalid UIToastWindowPosition Value" format:@"Value for UIToastWindowPosition %i is invalid.", self._position];
      break;
  }
  
  self._messageLabel.frame = CGRectMake(kAlertDefaultPadding, kAlertDefaultPadding, self._messageLabel.frame.size.width, self._messageLabel.frame.size.height);
  self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

#pragma mark - Actions
- (void)show {
  CGRect screenRect = get_screen_rect();
  [self makeKeyAndVisible];
  
  [UIView animateWithDuration:kAlertFadeDuration animations:^(void){
    switch (self._position) {
      case UIToastWindowPositionTop:
        self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), self.frame.origin.y + self.frame.size.height + kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        break;
      case UIToastWindowPositionBottom:
        self.frame = CGRectMake(round(screenRect.size.width/2 - self.frame.size.width/2), screenRect.size.height - self.frame.size.height - kAlertFadePixelAmount, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        break;
      default:
        [NSException raise:@"Invalid UIToastWindowPosition Value" format:@"Value for UIToastWindowPosition %i is invalid.", self._position];
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
        [NSException raise:@"Invalid UIToastWindowPosition Value" format:@"Value for UIToastWindowPosition %i is invalid.", self._position];
        break;
    }
  } completion:^(BOOL finished) {
    //TODO Could a [self release] actually go here for non ARC Code?
    [self removeFromSuperview];
  }];
}

#pragma mark - Convenience Methods
+ (UIToastWindow *)shortToastForMessage:(NSString *)message atPosition:(UIToastWindowPosition)position {
  return [[UIToastWindow alloc] initWithMessage:message duration:kUIToastWindowShortDuration position:position];
}

+ (UIToastWindow *)longToastForMessage:(NSString *)message atPosition:(UIToastWindowPosition)position {
  return [[UIToastWindow alloc] initWithMessage:message duration:kUIToastWindowLongDuration position:position];
}

#pragma mark - Memory Management
- (void)dealloc {
  [_dismissTimer invalidate];
}


@end
