//
//  XDPhotoListCell.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/21.
//  Copyright © 2018 XD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDPhotoModel.h"

#define XDPhotoListCellID @"XDPhotoListCell"

NS_ASSUME_NONNULL_BEGIN

@interface XDPhotoListCell : UICollectionViewCell

@property(strong, nonatomic)XDPhotoModel *photoModel;

@end

NS_ASSUME_NONNULL_END
