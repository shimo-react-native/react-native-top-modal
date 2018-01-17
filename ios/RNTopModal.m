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

@interface RNTopModal ()

@property (nonatomic, assign) BOOL initialized;
@property (nonatomic, assign) BOOL presented;

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
        _touchHandler = [[RCTTouchHandler alloc] initWithBridge:bridge];
    }
    return self;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex {
    RCTAssert(_contentView == nil, @"Modal view can only have one subview");
    
    [super insertReactSubview:subview atIndex:atIndex];
    
    [_touchHandler attachToView:subview];
    
    UIWindow *topWindow = [self topWindow];
    
    subview.frame = topWindow.bounds;
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [topWindow addSubview:subview];
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
    });
}

#pragma mark - Private

- (UIWindow*)topWindow {
    return [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        return win1.windowLevel - win2.windowLevel;
    }] lastObject];
}

@end
