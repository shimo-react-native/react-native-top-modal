//
//  RNTopModalManager.m
//  RNTopModal
//
//  Created by Bell Zhong on 2018/1/17.
//  Copyright © 2018年 shimo.im. All rights reserved.
//

#import "RNTopModalManager.h"
#import "RNTopModal.h"

@implementation RNTopModalManager {
    NSHashTable *_hostViews;
}

RCT_EXPORT_MODULE();

- (UIView *)view {
    RNTopModal *view = [[RNTopModal alloc] initWithBridge:self.bridge];
    if (!_hostViews) {
        _hostViews = [NSHashTable weakObjectsHashTable];
    }
    [_hostViews addObject:view];
    return view;
}

#pragma mark - RCTInvalidating

- (void)invalidate {
    for (RNTopModal *hostView in _hostViews) {
        [hostView invalidate];
    }
    [_hostViews removeAllObjects];
}

@end
