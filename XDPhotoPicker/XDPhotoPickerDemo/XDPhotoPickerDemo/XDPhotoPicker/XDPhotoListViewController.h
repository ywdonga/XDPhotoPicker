//
//  XDPhotoListViewController.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDAlbumModel.h"
#import "XDPhotoManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface XDPhotoListViewController : UIViewController

//相册实体
@property (nonatomic, strong) XDAlbumModel *albumModel;
//相册管理
@property (strong, nonatomic) XDPhotoManager *manager;

@end

NS_ASSUME_NONNULL_END
