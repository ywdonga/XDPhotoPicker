//
//  XDPhotoListCell.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/21.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPhotoListCell.h"
#import "XDPhotoManager.h"

@interface XDPhotoListCell ()

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation XDPhotoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhotoModel:(XDPhotoModel *)photoModel{
    _photoModel = photoModel;
    CGFloat imageHeight = 150;
    self.videoView.hidden = _photoModel.subType != XDPhotoModelMediaSubTypeVideo;
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02ld", _photoModel.videoDuration];
    [XDPhotoManager requestImageForAsset:_photoModel.asset size:CGSizeMake(imageHeight, imageHeight) completion:^(UIImage * _Nonnull img, NSDictionary * _Nonnull info) {
        self.picImageView.image = img;
    }];
}

@end
