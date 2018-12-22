//
//  UIView+XDPhoto.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XDPhoto)

//获取试图在window上的位置
- (CGRect)frameWithKeyWindow;

@end

NS_ASSUME_NONNULL_END
