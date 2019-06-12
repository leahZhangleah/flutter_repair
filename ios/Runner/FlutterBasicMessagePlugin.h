//
//  FlutterBasicMessagePlugin.h
//  Runner
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#ifndef FlutterBasicMessagePlugin_h
#define FlutterBasicMessagePlugin_h


#endif /* FlutterBasicMessagePlugin_h */
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>


@interface FlutterBasicMessagePlugin : NSObject<FlutterPlugin>

-(void) send:(NSString *) msg;


@end
