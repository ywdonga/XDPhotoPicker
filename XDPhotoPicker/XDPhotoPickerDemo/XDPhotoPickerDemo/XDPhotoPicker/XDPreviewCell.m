//
//  XDPreviewCell.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPreviewCell.h"
#import "XDPhotoManager.h"
#import "UITableView+WebVideoCache.h"
#import "UIView+WebVideoCache.h"

@interface XDPreviewCell ()
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, assign) BOOL isPlay;

@end

@implementation XDPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)dealloc{
    if(self.isPlay){
        [self stopPlayVideo];
    }
}

- (void)setPhotoModel:(XDPhotoModel *)photoModel{
    _photoModel = photoModel;
    self.picImageView.image = _photoModel.thumbPhoto;
    
    BOOL isVideo = _photoModel.subType == XDPhotoModelMediaSubTypeVideo;
    self.backScrollView.maximumZoomScale = isVideo?1:5;
    self.playButton.hidden = !isVideo;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.picImageView;
}

- (void)starPlayVideoWithUrl:(NSURL *)url{
    self.videoView.hidden = NO;
    self.isPlay = YES;
    [self.videoView jp_playVideoWithURL:url];
}

- (void)stopPlayVideo{
    self.videoView.hidden = YES;
    self.isPlay = NO;
    [self.videoView jp_pause];
}


- (IBAction)playButtonClick:(UIButton *)sender {
    if(self.isPlay){
        [self stopPlayVideo];
        return;
    }
    [self.activityIndicatorView startAnimating];
    [XDPhotoManager videoUrlWithAsset:self.photoModel.asset back:^(NSURL * _Nonnull url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicatorView stopAnimating];
            [self starPlayVideoWithUrl:url];
        });
    }];

}

- (void)showOriginalImage{
    if(self.photoModel.previewPhoto){
        self.picImageView.image = self.photoModel.previewPhoto;
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [self.activityIndicatorView startAnimating];
    [XDPhotoManager requestOriginalImageForAsset:self.photoModel.asset completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        [weakSelf.activityIndicatorView stopAnimating];
        weakSelf.photoModel.previewPhoto = image;
        weakSelf.picImageView.image = image;
    }];
}

- (void)resetScale{
    self.backScrollView.zoomScale = 1;
    self.playButton.hidden = NO;
    [self stopPlayVideo];
}

- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    [self.playButton setImage:_isPlay?nil:[UIImage imageNamed:@"xd_video_play"] forState:UIControlStateNormal];
}

@end
