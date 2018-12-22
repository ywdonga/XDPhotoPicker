//
//  XdPhotoTransitionAnimator.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XdPhotoTransitionAnimator : NSObject
<UIViewControllerAnimatedTransitioning>

//动画时间
@property (nonatomic, assign) CGFloat duration;

//图片原位置
@property (nonatomic, assign) CGRect originFrame;

//展示或消失
@property (nonatomic, assign) BOOL presenting;


@end

NS_ASSUME_NONNULL_END
