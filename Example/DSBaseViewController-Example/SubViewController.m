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

    self.appearStateBlock = ^(BOOL appear, BOOL finished, BOOL animated, __kindof DSBaseViewController *controller) {
        if (appear) {
            if (finished) {
                PostMessage([NSString stringWithFormat:@"%@: did appear", controller.title]);
            } else {
                PostMessage([NSString stringWithFormat:@"%@: will appear", controller.title]);
            }
        } else {
            if (finished) {
                PostMessage([NSString stringWithFormat:@"%@: did disappear", controller.title]);
            } else {
                PostMessage([NSString stringWithFormat:@"%@: will disappear", controller.title]);
            }
        }
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
