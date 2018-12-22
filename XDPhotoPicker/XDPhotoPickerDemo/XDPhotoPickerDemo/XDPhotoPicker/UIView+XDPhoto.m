
//
//  UIView+XDPhoto.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import "UIView+XDPhoto.h"

@implementation UIView (XDPhoto)

- (CGRect)frameWithKeyWindow{
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    return rect;
}

@end
