//
//  JCRecordPlayerView.h
//  Runner
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#ifndef JCRecordPlayerView_h
#define JCRecordPlayerView_h


#endif /* JCRecordPlayerView_h */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+JCAddition.h"
typedef void(^JCRecordPlayerViewCancelBlock)(void);
typedef void(^JCRecordPlayerViewConfirmBlock)(void);

@interface JCRecordPlayerView : UIView
@property (nonatomic, copy) JCRecordPlayerViewCancelBlock cancelBlock;
@property (nonatomic, copy) JCRecordPlayerViewConfirmBlock confirmBlock;
@property (nonatomic, strong) NSURL *playUrl;
@end
