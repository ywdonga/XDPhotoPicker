//
//  XDPhotoManager.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPhotoManager.h"
#import "XDAlbumModel.h"
#import "XDPhotoModel.h"

@implementation XDPhotoManager

//获取系统所有相册
- (void)getAllPhotoAlbums:(void(^)(XDAlbumModel *firstAlbumModel))firstModel{
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if(collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary){
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            // 是否按创建时间排序
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            @autoreleasepool {
                // 获取照片集合
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                XDAlbumModel *albumModel = [[XDAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                albumModel.index = 0;
                if (firstModel) {
                    firstModel(albumModel);
                }
                *stop = YES;
            }
        }
    }];
}

//获取指定相册的所有图片
- (void)getPhotoListWithAlbumModel:(XDAlbumModel *)albumModel complete:(void (^)(NSArray <XDPhotoModel *>*allList))complete{
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *selectList = [NSMutableArray arrayWithArray:self.selectedList];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        XDPhotoModel *photoModel = [[XDPhotoModel alloc] init];
        photoModel.asset = asset;
        @autoreleasepool {
            //处理选中---------------
            if (selectList.count > 0) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"localIdentifier = %@", asset.localIdentifier];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    XDPhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    [self.selectedList replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.selectIndexStr = model.selectIndexStr;
                }
            }
            //处理所有相片---------------
            if (asset.mediaType == PHAssetMediaTypeImage) {
                photoModel.subType = XDPhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {//处理GIF
                    photoModel.type = XDPhotoModelMediaTypePhotoGif;
                }else{
                    photoModel.type = XDPhotoModelMediaTypePhoto;
                }
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {//处理视频
                photoModel.subType = XDPhotoModelMediaSubTypeVideo;
                photoModel.type = XDPhotoModelMediaTypeVideo;
                // 默认视频都是可选的
                [self changeModelVideoState:photoModel];
            }
            photoModel.currentAlbumIndex = albumModel.index;
            [allArray addObject:photoModel];
        }
    }];
    !complete?:complete(allArray);
}

#pragma mark - 获取asset对应的图片
//快速获取预览图
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
//    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    option.networkAccessAllowed = NO;
    return [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        !completion?:completion(image, info);
    }];
}


#pragma mark - < 改变模型的视频状态 >
- (void)changeModelVideoState:(XDPhotoModel *)model {
    model.videoDuration = model.asset.duration;
    if (model.type == XDPhotoModelMediaTypeVideo) {
        if (model.asset.duration < 1) {
            model.videoState = XDPhotoModelVideoStateUndersize;
        }else if (model.asset.duration >= 1 + 1) {
            model.videoState = XDPhotoModelVideoStateOversize;
        }
    }else if (model.type == XDPhotoModelMediaTypeCameraVideo) {
        if (model.videoDuration < 1) {
            model.videoState = XDPhotoModelVideoStateUndersize;
        }else if (model.videoDuration >= 1 + 1) {
            model.videoState = XDPhotoModelVideoStateOversize;
        }
    }
}

//通过url获取视频时长
+ (CGFloat)videoDurationWithUrl:(NSURL *)videoUrl{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    return seconds;
}

//获取视频Url
+ (void)videoUrlWithAsset:(PHAsset *)phAsset back:(void(^)(NSURL *url))backUrl{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        !backUrl?:backUrl(urlAsset.URL);
    }];
}

@end
