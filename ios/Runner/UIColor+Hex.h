//
//  UIColor+Hex.h
//  Runner
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#ifndef UIColor_Hex_h
#define UIColor_Hex_h


#endif /* UIColor_Hex_h */
#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
@end
