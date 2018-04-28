//
//  RNTopModal.m
//  RNTopModal
//
//  Created by Bell Zhong on 2018/1/17.
//  Copyright © 2018年 shimo.im. All rights reserved.
//

#import "RNTopModal.h"

#import <React/RCTAssert.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import <React/RCTShadowView.h>
#import <React/RCTTouchHandler.h>

#if __has_include(<React/RCTUIManagerUtils.h>)
#import <React/RCTUIManagerUtils.h>
#endif

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

@interface RNTopModal ()

@property (nonatomic, assign) BOOL initialized;
@property (nonatomic, assign) BOOL presented;
@property (nonatomic, strong) UIWindow *topWindow;

@end

@implementation RNTopModal {
    __weak RCTBridge *_bridge;
    
    RCTTouchHandler *_touchHandler;
    UIView *_contentView;
    __weak UIWindow *_oldKeyWindow;
}

RCT_NOT_IMPLEMENTED(-(instancetype)initWithFrame
                    : (CGRect)frame)
RCT_NOT_IMPLEMENTED(-(instancetype)initWithCoder
                    : coder)

#pragma mark - RCTView

- (instancetype _Nonnull)initWithBridge:(RCTBridge *_Nullable)bridge {
    if ((self = [super initWithFrame:CGRectZero])) {
        _bridge = bridge;
        _initialized = NO;
        _touchHandler = [[RCTTouchHandler alloc] initWithBridge:bridge];
        
        _oldKeyWindow = [UIApplication sharedApplication].keyWindow;
        
        _topWindow = [[UIWindow alloc] initWithFrame:_oldKeyWindow ? _oldKeyWindow.frame : [UIScreen mainScreen].bounds];
        _topWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _topWindow.backgroundColor = [UIColor clearColor];
        _topWindow.windowLevel = UIWindowLevelAlert;
        [_topWindow makeKeyAndVisible];
        
        [self handleOrientationChange];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationChange) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex {
    RCTAssert(_contentView == nil, @"Modal view can only have one subview");
    
    [super insertReactSubview:subview atIndex:atIndex];
    
    [_touchHandler attachToView:subview];
    
    subview.frame = self.topWindow.bounds;
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.topWindow addSubview:subview];
    _contentView = subview;
}

- (void)removeReactSubview:(UIView *)subview {
    RCTAssert(subview == _contentView, @"Cannot remove view other than modal view");
    [super removeReactSubview:subview];
    
    [_touchHandler detachFromView:subview];
    [subview removeFromSuperview];
    _contentView = nil;
}

- (void)didUpdateReactSubviews {
    // Do nothing, as subview (singular) is managed by `insertReactSubview:atIndex:`
}

#pragma mark - RCTInvalidating

- (void)invalidate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_contentView removeFromSuperview];
        _contentView = nil;
        [_topWindow resignKeyWindow];
        _topWindow = nil;
        [_oldKeyWindow makeKeyAndVisible];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Orientation

/**
 @see https://stackoverflow.com/a/31556970/6283925
 */
- (void)handleOrientationChange {
    if (self.topWindow) {
        // rotate the UIWindow manually
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        [self.topWindow setTransform:[self transformForOrientation:orientation]];
        
        // resize the UIWindow according to the new screen size
        if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]) {
            // iOS 8 and later
            CGRect screenRect = [UIScreen mainScreen].nativeBounds;
            CGRect topWindowFrame = self.topWindow.frame;
            topWindowFrame.origin.x = 0;
            topWindowFrame.origin.y = 0;
            topWindowFrame.size.width = screenRect.size.width / [UIScreen mainScreen].nativeScale;
            topWindowFrame.size.height = screenRect.size.height / [UIScreen mainScreen].nativeScale;
            self.topWindow.frame = topWindowFrame;
        } else {
            // iOs 7 or below
            CGRect screenRect = [UIScreen mainScreen].bounds;
            CGRect topWindowFrame = self.topWindow.frame;
            topWindowFrame.origin.x = 0;
            topWindowFrame.origin.y = 0;
            topWindowFrame.size.width = screenRect.size.width;
            topWindowFrame.size.height = screenRect.size.height;
            self.topWindow.frame = topWindowFrame;
        }
    }
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-DegreesToRadians(90));
            
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(DegreesToRadians(90));
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(DegreesToRadians(180));
            
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(DegreesToRadians(0));
    }
}

@end
