//
//  XDPhotoModel.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    XDPhotoModelMediaTypePhoto          = 0,    //!< 照片
    XDPhotoModelMediaTypeLivePhoto      = 1,    //!< LivePhoto
    XDPhotoModelMediaTypePhotoGif       = 2,    //!< gif图
    XDPhotoModelMediaTypeVideo          = 3,    //!< 视频
    XDPhotoModelMediaTypeAudio          = 4,    //!< 预留
    XDPhotoModelMediaTypeCameraPhoto    = 5,    //!< 通过相机拍的照片
    XDPhotoModelMediaTypeCameraVideo    = 6,    //!< 通过相机录制的视频
    XDPhotoModelMediaTypeCamera         = 7     //!< 跳转相机
} XDPhotoModelMediaType;

typedef enum : NSUInteger {
    XDPhotoModelMediaSubTypePhoto = 0,  //!< 照片
    XDPhotoModelMediaSubTypeVideo       //!< 视频
} XDPhotoModelMediaSubType;

typedef enum : NSUInteger {
    XDPhotoModelVideoStateNormal = 0,   //!< 普通状态
    XDPhotoModelVideoStateUndersize,    //!< 视频时长小于1秒
    XDPhotoModelVideoStateOversize      //!< 视频时长超出限制
} XDPhotoModelVideoState;

NS_ASSUME_NONNULL_BEGIN

@interface XDPhotoModel : NSObject

/**  照片PHAsset对象  */
@property (strong, nonatomic) PHAsset *asset;
/**  是否选中 */
@property (assign, nonatomic) BOOL selected;
/**  照片类型  */
@property (assign, nonatomic) XDPhotoModelMediaType type;
/**  照片子类型  */
@property (assign, nonatomic) XDPhotoModelMediaSubType subType;
/**  临时的列表小图  */
@property (strong, nonatomic) UIImage *thumbPhoto;
/**  临时的预览大图  */
@property (strong, nonatomic) UIImage *previewPhoto;
/**  模型所对应的选中下标 */
@property (copy, nonatomic) NSString *selectIndexStr;
/**  当前图片所在相册的下标 */
@property (assign, nonatomic) NSInteger currentAlbumIndex;

/**  如果当前为视频资源时的视频状态  */
@property (assign, nonatomic) XDPhotoModelVideoState videoState;
/**  相机拍摄之后的视频秒数 */
@property (nonatomic, assign) NSInteger videoDuration;

@end

NS_ASSUME_NONNULL_END
