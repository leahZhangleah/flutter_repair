//
//  JCVideoRecordView.h
//  Runner
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#ifndef JCVideoRecordView_h
#define JCVideoRecordView_h


#endif /* JCVideoRecordView_h */
#import <Foundation/Foundation.h>
#import "JCVideoRecordManager.h"
typedef void(^JCVideoRecordViewDismissBlock)(void);
typedef void(^JCVideoRecordViewCompletionBlock)(NSURL *fileUrl);

@interface JCVideoRecordView : UIWindow

@property (nonatomic, copy) JCVideoRecordViewDismissBlock cancelBlock;
@property (nonatomic, copy) JCVideoRecordViewCompletionBlock completionBlock;
- (void)present;

@end
