//
//  XDPhotoListViewController.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPhotoListViewController.h"
#import "XDPhotoListCell.h"
#import "XDPreviewViewController.h"
#import "UIView+XDPhoto.h"

#define XDPhotoSW [UIScreen mainScreen].bounds.size.width
#define XDPhotoSH [UIScreen mainScreen].bounds.size.height

#define RowCount 4
#define RowSp 3

@interface XDPhotoListViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <XDPhotoModel *>* photoModelArray;
@property (nonatomic, weak) XDPhotoModel *curentPhotoModel;
//相册实体
@property (nonatomic, strong) XDAlbumModel *albumModel;
//相册管理
@property (nonatomic, strong) XDPhotoManager *photoManager;
/* 预览按钮 */
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
/* 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation XDPhotoListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerNib:[UINib nibWithNibName:XDPhotoListCellID bundle:nil] forCellWithReuseIdentifier:XDPhotoListCellID];
    self.collectionView.contentInset = UIEdgeInsetsMake(RowSp, RowSp, RowSp, RowSp);
    [self checkAuthor];
}

- (void)dealloc{
    self.curentPhotoModel.thumbPhoto = nil;
    NSLog(@"相册XDPhotoListViewController 销毁 ❌❌❌");
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
                [weakSelf getAlbumModelList];
            }
        });
    }];
}

//获取相册 及里面的照片
- (void)getAlbumModelList{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.photoManager getAllPhotoAlbums:^(XDAlbumModel* firstAlbumModel) {
            weakSelf.albumModel = firstAlbumModel;
            [weakSelf.photoManager getPhotoListWithAlbumModel:weakSelf.albumModel complete:^(NSArray <XDPhotoModel *>* _Nonnull allList) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photoModelArray = allList;
                    [self.collectionView reloadData];
                });
            }];
        }];
    });
}


#pragma mark - public methods

#pragma mark - request methods

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoModelArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XDPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XDPhotoListCellID forIndexPath:indexPath];
    cell.photoModel = self.photoModelArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XDPreviewViewController *previewViewController = [[XDPreviewViewController alloc] init];
    previewViewController.photoModelArray = self.photoModelArray;
    
    previewViewController.curentIndex = indexPath.item;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    previewViewController.originFrame = [cell frameWithKeyWindow];

    previewViewController.setIndexBackBlock = ^CGRect(NSInteger index) {
        NSIndexPath *curentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UICollectionViewCell *curentCell = [collectionView cellForItemAtIndexPath:curentIndexPath];
        if(!curentCell){
            [collectionView scrollToItemAtIndexPath:curentIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            [self.collectionView setNeedsDisplay];
        }
        curentCell = [collectionView cellForItemAtIndexPath:curentIndexPath];
        CGRect curentRect = [curentCell frameWithKeyWindow];
        NSLog(@"-->%g/%g", curentRect.origin.x, curentRect.origin.y);
        return curentRect;
    };
    [self presentViewController:previewViewController animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.curentPhotoModel = self.photoModelArray[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    XDPhotoModel *photoModel = self.photoModelArray[indexPath.item];
    photoModel.thumbPhoto = nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = (XDPhotoSW-(RowCount+1)*RowCount)/RowCount;
    return CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - event response

#pragma mark - getters and setters
- (XDPhotoManager *)photoManager{
    if(!_photoManager){
        _photoManager = [[XDPhotoManager alloc] init];
    }
    return _photoManager;
}

@end
