//
//  FlutterBasicMessagePlugin.m
//  Runner
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FlutterBasicMessagePlugin.h"
@implementation FlutterBasicMessagePlugin

static FlutterBasicMessageChannel *channel;

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    channel = [FlutterBasicMessageChannel messageChannelWithName:@"com.mmd.flutterapp/plugin" binaryMessenger:[registrar messenger]];
}

-(void) send:(NSString *) msg{
    [channel sendMessage: msg];
}

@end
