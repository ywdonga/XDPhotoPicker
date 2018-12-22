//
//  XDPreviewViewController.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPreviewViewController.h"
#import "XdPhotoTransitionAnimator.h"
#import "XDPreviewCell.h"

@interface XDPreviewViewController ()
<UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) XDPhotoModel *curentPhotoModel;

@end

@implementation XDPreviewViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerNib:[UINib nibWithNibName:@"XDPreviewCell" bundle:nil] forCellWithReuseIdentifier:XDPreviewCellID];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.curentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.curentPhotoModel.previewPhoto = nil;
}

- (void)dealloc{
    NSLog(@"相册XDPreviewViewController 销毁 ❌❌❌");
}

//UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.pageControl.numberOfPages = self.photoModelArray.count;
    self.pageControl.hidden = (self.photoModelArray.count > 10);
    return self.photoModelArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XDPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XDPreviewCellID forIndexPath:indexPath];
    cell.photoModel = self.photoModelArray[indexPath.item];
    return cell;
}

//UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    XDPreviewCell *previewCell = (XDPreviewCell *)cell;
    self.curentPhotoModel = previewCell.photoModel;
    [previewCell showOriginalImage];
    self.pageControl.currentPage = indexPath.item;
    if(self.setIndexBackBlock){
        self.originFrame = self.setIndexBackBlock(indexPath.item);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    XDPreviewCell *previewCell = (XDPreviewCell *)cell;
    previewCell.photoModel.previewPhoto = nil;
}

//UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size;
}

//UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self generateAnimatorWithPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self generateAnimatorWithPresenting:NO];
}


- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (XdPhotoTransitionAnimator *)generateAnimatorWithPresenting:(BOOL)presenting {
    XdPhotoTransitionAnimator *animator = [[XdPhotoTransitionAnimator alloc] init];
    animator.presenting = presenting;
    animator.originFrame = self.originFrame;
    return animator;
}

@end
