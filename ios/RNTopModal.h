//
//  RNTopModal.h
//  RNTopModal
//
//  Created by Bell Zhong on 2018/1/17.
//  Copyright © 2018年 shimo.im. All rights reserved.
//

#import <React/RCTInvalidating.h>
#import <React/RCTView.h>
#import <React/RCTBridgeModule.h>

@interface RNTopModal : RCTView <RCTInvalidating>

@property (nullable, nonatomic, copy) RCTDirectEventBlock onShow;

/**
 Whether will makeKeyWindow.
 
 if YES, keyboard will dismiss in iPad.
 */
@property (nonatomic, assign) BOOL keyWindow;

- (instancetype _Nonnull)initWithBridge:(RCTBridge *_Nullable)bridge;

@end
