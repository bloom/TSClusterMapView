//
//  TSPlatformCompatibility.h
//  DayOne
//
//  Created by BJ Homer on 2/22/16.
//  Copyright © 2016 Bloom Built, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_IOS
#define TS_TARGET_IOS 0
#define TS_TARGET_MAC 1
#else
#define TS_TARGET_MAC 0
#define TS_TARGET_IOS 1
#endif


#if TS_TARGET_MAC
#define UIView NSView
#define UIEdgeInsetsMake NSEdgeInsetsMake
#define UIGestureRecognizer NSGestureRecognizer
#define UIPanGestureRecognizer NSPanGestureRecognizer
#define UIGestureRecognizerDelegate NSGestureRecognizerDelegate

#define UIGestureRecognizerStateBegan NSGestureRecognizerStateBegan
#define UIGestureRecognizerStateEnded NSGestureRecognizerStateEnded

typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
    UIViewAnimationOptionCurveEaseIn
};

#endif