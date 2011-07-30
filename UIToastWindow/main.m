//
//  main.m
//  UIToastWindow
//
//  Created by Brian Michel on 7/30/11.
//  Copyright 2011 Foureyes.me. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIToastWindowAppDelegate.h"

int main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  return UIApplicationMain(argc, argv, nil, NSStringFromClass([UIToastWindowAppDelegate class]));
  [pool drain];
}
