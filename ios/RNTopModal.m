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
        _keyWindow = NO;
        _touchHandler = [[RCTTouchHandler alloc] initWithBridge:bridge];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _topWindow = [[UIWindow alloc] initWithFrame:keyWindow ? keyWindow.frame : [UIScreen mainScreen].bounds];
        _topWindow.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        _topWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _topWindow.backgroundColor = [UIColor clearColor];
        _topWindow.windowLevel = UIWindowLevelAlert;
        [_topWindow setHidden:NO];
    }
    return self;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex {
    RCTAssert(_contentView == nil, @"Modal view can only have one subview");
    
    [super insertReactSubview:subview atIndex:atIndex];
    
    [_touchHandler attachToView:subview];
    
    subview.frame = self.topWindow.bounds;
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.topWindow.rootViewController.view addSubview:subview];
    _contentView = subview;
}

- (void)removeReactSubview:(UIView *)subview {
    RCTAssert(subview == _contentView, @"Cannot remove view other than modal view");
    [super removeReactSubview:_contentView];
    
    [_touchHandler detachFromView:_contentView];
    [_contentView removeFromSuperview];
    _contentView = nil;
}

- (void)didUpdateReactSubviews {
    // Do nothing, as subview (singular) is managed by `insertReactSubview:atIndex:`
}

#pragma mark - Setter

- (void)setKeyWindow:(BOOL)keyWindow {
    if (_keyWindow != keyWindow) {
        _keyWindow = keyWindow;
    }
    if (_keyWindow) {
        [_topWindow makeKeyWindow];
    } else {
        [_topWindow resignKeyWindow];
    }
}

#pragma mark - RCTInvalidating

- (void)invalidate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_contentView removeFromSuperview];
        _contentView = nil;
        if (_topWindow.keyWindow) {
            [_topWindow resignKeyWindow];
        }
        _topWindow = nil;
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
