//
//  UIToastWindowAppDelegate.h
//  UIToastWindow
//
//  Created by Brian Michel on 7/30/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIToastWindowViewController;

@interface UIToastWindowAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIToastWindowViewController *viewController;

@end
