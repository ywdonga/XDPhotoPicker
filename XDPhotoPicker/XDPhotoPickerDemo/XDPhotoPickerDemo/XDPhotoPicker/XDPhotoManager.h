//
//  XDPhotoManager.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "XDAlbumModel.h"
#import "XDPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDPhotoManager : NSObject

//选中的相片
@property (strong, nonatomic) NSMutableArray <XDPhotoModel *>*selectedList;

//获取相机交卷相册
- (void)getAllPhotoAlbums:(void(^)(XDAlbumModel *firstAlbumModel))firstModel;
//获取指定相册的所有图片
- (void)getPhotoListWithAlbumModel:(XDAlbumModel *)albumModel complete:(void (^)(NSArray *allList))complete;

@end

NS_ASSUME_NONNULL_END
