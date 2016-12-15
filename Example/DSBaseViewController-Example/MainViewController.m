//
//  MainViewController.m
//  DSBaseViewController-Example
//
//  Created by WeiHan on 12/15/16.
//  Copyright © 2016 Will Han. All rights reserved.
//

#import "MainViewController.h"
#import "SubViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UITextView *textview;

@end

@implementation MainViewController

InitForViewController(AddObserver(self, @selector(onNotificationReceived:)); )

- (void)loadView
{
    UITextView *textview = [UITextView new];

    textview.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textview.editable = NO;
    self.textview = textview;
    self.view = textview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSStringFromClass([self class]);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearBarButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(navigateBarButtonTapped:)];

    PostMessage([NSString stringWithFormat:@"%s", __func__]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    PostMessage([NSString stringWithFormat:@"%s", __func__]);
}

#pragma mark - Actions

- (void)clearBarButtonTapped:(id)sender
{
    self.textview.text = nil;
}

- (void)navigateBarButtonTapped:(id)sender
{
    SubViewController *subVC = [SubViewController new];

    subVC.tag = 1;

    [self.navigationController pushViewController:subVC animated:YES];
}

- (void)onNotificationReceived:(NSNotification *)notification
{
    self.textview.text = [NSString stringWithFormat:@"%@\n\n%@", self.textview.text, GetMessage(notification)];

    // http://stackoverflow.com/a/16698798/1677041
    NSRange bottom = NSMakeRange(self.textview.text.length - 1, 1);
    [self.textview scrollRangeToVisible:bottom];
}

#pragma mark - BuildViewDelegate

- (void)buildSubview:(UIView *)containerView controller:(BaseViewController *)viewController
{
    // Build subviews for current view controller (viewController).
    // This delegate method should be called once durning its life cycle, just act as UIViewController.
    // Since it custom the root self.view as UITextView, the containerView here is the one.

    PostMessage([NSString stringWithFormat:@"%s", __func__]);
}

- (void)loadDataForController:(BaseViewController *)viewController
{
    PostMessage([NSString stringWithFormat:@"%s", __func__]);
}

- (void)tearDown:(BaseViewController *)viewController
{
    PostMessage([NSString stringWithFormat:@"%s", __func__]);
}

- (BOOL)shouldInvalidateDataForController:(BaseViewController *)viewController
{
    PostMessage([NSString stringWithFormat:@"%s", __func__]);
    return YES;
}

@end
