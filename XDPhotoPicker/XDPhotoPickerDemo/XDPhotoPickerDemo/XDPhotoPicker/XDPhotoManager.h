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
- (void)getPhotoListWithAlbumModel:(XDAlbumModel *)albumModel complete:(void (^)(NSArray <XDPhotoModel *>*allList))complete;

#pragma mark - 获取asset对应的图片
//快速获取预览图
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *))completion;

//通过url获取视频时长
+ (CGFloat)videoDurationWithUrl:(NSURL *)videoUrl;
//获取视频Url
+ (void)videoUrlWithAsset:(PHAsset *)phAsset back:(void(^)(NSURL *url))backUrl;

@end

NS_ASSUME_NONNULL_END
