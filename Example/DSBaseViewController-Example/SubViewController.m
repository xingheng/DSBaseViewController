//
//  SubViewController.m
//  DSBaseViewController-Example
//
//  Created by WeiHan on 12/15/16.
//  Copyright © 2016 Will Han. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()

@end

@implementation SubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.willAppearBlock = ^(BOOL animated) {
        PostMessage([NSString stringWithFormat:@"%s: willAppearBlock", __func__]);
    };

    self.didAppearBlock = ^(BOOL animated) {
        PostMessage([NSString stringWithFormat:@"%s: didAppearBlock", __func__]);
    };

    self.willDisappearBlock = ^(BOOL animated) {
        PostMessage([NSString stringWithFormat:@"%s: willDisappearBlock", __func__]);
    };

    self.didDisappearBlock = ^(BOOL animated) {
        PostMessage([NSString stringWithFormat:@"%s: didDisappearBlock", __func__]);
    };

    self.title = self.description;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(navigateBarButtonTapped:)];

    PostMessage([NSString stringWithFormat:@"%@ - %s", self.description, __func__]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    PostMessage([NSString stringWithFormat:@"%@ - %s", self.description, __func__]);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@-%ld", NSStringFromClass([self class]), self.tag];
}

#pragma mark - Actions

- (void)navigateBarButtonTapped:(id)sender
{
    if (self.tag > 10) {
        return;
    }

    SubViewController *subVC = [SubViewController new];

    subVC.tag = self.tag + 1;

    [self.navigationController pushViewController:subVC animated:YES];
}

#pragma mark - BuildViewDelegate

- (void)buildSubview:(UIView *)containerView controller:(BaseViewController *)viewController
{
    PostMessage([NSString stringWithFormat:@"%@ - %s", self.description, __func__]);
}

- (void)loadDataForController:(BaseViewController *)viewController
{
    PostMessage([NSString stringWithFormat:@"%@ - %s", self.description, __func__]);
}

- (void)tearDown:(BaseViewController *)viewController
{
    PostMessage([NSString stringWithFormat:@"%@ - %s", self.description, __func__]);
}

@end
