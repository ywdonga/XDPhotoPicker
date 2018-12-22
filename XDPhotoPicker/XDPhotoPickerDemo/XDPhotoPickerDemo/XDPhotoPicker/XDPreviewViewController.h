//
//  XDPreviewViewController.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDPreviewViewController : UIViewController

@property (nonatomic, strong) NSArray <XDPhotoModel *>* photoModelArray;
@property (nonatomic, assign) NSInteger curentIndex;

//图片原位置
@property (nonatomic, assign) CGRect originFrame;
//切换index回调
@property (nonatomic, copy) CGRect(^setIndexBackBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
