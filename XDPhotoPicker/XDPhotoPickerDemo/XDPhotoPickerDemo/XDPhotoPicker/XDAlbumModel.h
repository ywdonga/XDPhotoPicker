//
//  XDAlbumModel.h
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDAlbumModel : NSObject


/** 相册名称 */
@property (copy, nonatomic) NSString *albumName;
/** 照片数量 */
@property (assign, nonatomic) NSInteger count;
/** 标记 */
@property (assign, nonatomic) NSInteger index;
/** 照片集合对象 */
@property (strong, nonatomic) PHFetchResult *result;

@end

NS_ASSUME_NONNULL_END
