//
//  XDPreviewViewController.m
//  XDPhotoPickerDemo
//
//  Created by Dyl on 2018/12/22.
//  Copyright © 2018 XD. All rights reserved.
//

#import "XDPreviewViewController.h"

@interface XDPreviewViewController ()
<UIViewControllerTransitioningDelegate>

@end

@implementation XDPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
