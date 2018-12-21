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

@end

NS_ASSUME_NONNULL_END
