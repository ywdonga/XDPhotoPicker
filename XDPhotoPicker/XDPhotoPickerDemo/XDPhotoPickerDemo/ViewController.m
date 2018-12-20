//
//  ViewController.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/20.
//  Copyright © 2018 XD. All rights reserved.
//

#import "ViewController.h"
#import "XDPhotoPickerNav.h"
#import "XDAlbumListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    XDAlbumListViewController *albumListViewController = [[XDAlbumListViewController alloc] init];
    XDPhotoPickerNav *photoPickerNav = [[XDPhotoPickerNav alloc] initWithRootViewController:albumListViewController];
    [self presentViewController:photoPickerNav animated:YES completion:nil];
    
}


@end
