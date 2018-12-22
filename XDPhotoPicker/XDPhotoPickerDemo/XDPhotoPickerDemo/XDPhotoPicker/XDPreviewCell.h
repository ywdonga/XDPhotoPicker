//
//  XDPreviewCell.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDPhotoModel.h"

#define XDPreviewCellID @"XDPreviewCell"

NS_ASSUME_NONNULL_BEGIN

@interface XDPreviewCell : UICollectionViewCell

@property (nonatomic, strong) XDPhotoModel *photoModel;

- (void)showOriginalImage;

@end

NS_ASSUME_NONNULL_END
