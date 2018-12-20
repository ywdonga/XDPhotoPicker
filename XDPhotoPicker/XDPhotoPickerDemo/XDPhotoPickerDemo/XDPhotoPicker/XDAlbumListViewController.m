//
//  XDAlbumListViewController.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDAlbumListViewController.h"
#import "XDPhotoListViewController.h"//相片列表
#import "XDPhotoManager.h"//相册管理

@interface XDAlbumListViewController ()

@property (nonatomic, strong) XDPhotoManager *photoManager;

@end

@implementation XDAlbumListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 获取当前应用对照片的访问授权状态
    [self checkAuthor];
}


#pragma mark - private methods
//检查授权
- (void)checkAuthor{
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在设置-隐私-相册中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }else {
                [weakSelf getAlbumModelList:YES];
            }
        });
    }];
}

//前往相册控制器
- (void)getAlbumModelList:(BOOL)isFirst {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        self.photoManager = [[XDPhotoManager alloc] init];
        [self.photoManager getAllPhotoAlbums:^(id  _Nonnull firstAlbumModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                XDAlbumModel *model = firstAlbumModel;
                XDPhotoListViewController *vc = [[XDPhotoListViewController alloc] init];
                vc.manager = weakSelf.photoManager;
                vc.title = model.albumName;
                vc.albumModel = model;
                [weakSelf.navigationController pushViewController:vc animated:NO];
            });
        }];
    });
}

#pragma mark - public methods

#pragma mark - request methods

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - event response

#pragma mark - getters and setters
- (XDPhotoManager *)photoManager{
    if(!_photoManager){
        _photoManager = [[XDPhotoManager alloc] init];
    }
    return _photoManager;
}

@end
