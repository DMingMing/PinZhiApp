//
//  Public.m
//  PinZhiApp
//
//  Created by MingMing on 16/12/10.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "Public.h"

@implementation Public
//适配字体大小
+(CGFloat)fontWithDevice:(CGFloat)fontSize{
    float with = [UIScreen mainScreen].bounds.size.width;
    if (with == 414) {
        fontSize = fontSize+3;
    }else if (with == 375){
        fontSize = fontSize+1.5;
    }else if (with == 320){
        fontSize = fontSize;
    }else if (with>414){
        fontSize = fontSize+20;
    }
    return fontSize;
}
@end
