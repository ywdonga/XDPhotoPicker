//
//  XDPreviewCell.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPreviewCell.h"
#import "XDPhotoManager.h"

@interface XDPreviewCell ()
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation XDPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhotoModel:(XDPhotoModel *)photoModel{
    _photoModel = photoModel;
    self.picImageView.image = _photoModel.thumbPhoto;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.picImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
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

@end
