//
//  ScrollableViewController.m
//  DragonSourceCommon
//
//  Created by WeiHan on 1/28/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import "ScrollableViewController.h"

@interface ScrollableViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *containerViewEdgeConstraints;
@property (nonatomic, strong) NSLayoutConstraint *containerViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *containerViewHeightConstraint;

@end

@implementation ScrollableViewController

- (void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    UIView *containerView = [UIView new];

    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    containerView.translatesAutoresizingMaskIntoConstraints = NO;

    self.view = scrollView;
    self.containerView = containerView;
    [scrollView addSubview:containerView];

    self.contentInset = UIEdgeInsetsZero;
}

- (void)updateViewConstraints
{
    // Make sure the container's height constraint binds to minimal height
    //  of scrollView if the bottom constraint isn't ready.
    if (!self.containerViewBottomConstraint) {
        self.containerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        self.containerViewHeightConstraint.active = YES;
    }

    [super updateViewConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Enable the vertical bounce to wake up the scrollable gesture manually.
    // self.scrollView.alwaysBounceVertical = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Public

- (void)setLastBottomView:(UIView *)lastBottomView
{
    _lastBottomView = lastBottomView;
    NSParameterAssert(lastBottomView);

    self.containerViewHeightConstraint.active = NO;
    self.containerViewHeightConstraint = nil;

    if (self.containerViewBottomConstraint) {
        self.containerViewBottomConstraint.active = NO;
    }

    self.containerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastBottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.contentInset.bottom];
    self.containerViewBottomConstraint.active = YES;
}

#pragma mark - Property

- (UIScrollView *)scrollView
{
    return (UIScrollView *)self.view;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;

    if (self.containerViewEdgeConstraints) {
        [self.containerViewEdgeConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.active = NO;
        }];
        [self.containerViewEdgeConstraints removeAllObjects];
    } else {
        self.containerViewEdgeConstraints = [NSMutableArray new];
    }

    void (^ MakeEqualConstraint)(id, id, NSLayoutAttribute, CGFloat) = ^(id item1, id item2, NSLayoutAttribute attr, CGFloat constant) {
        NSLayoutConstraint *constraint =
            [NSLayoutConstraint constraintWithItem:item1
                                         attribute:attr
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:item2
                                         attribute:attr
                                        multiplier:1.0
                                          constant:constant];
        constraint.active = YES;
        [self.containerViewEdgeConstraints addObject:constraint];
    };

    UIView *scrollView = self.scrollView, *containerView = self.containerView;
    MakeEqualConstraint(containerView, scrollView, NSLayoutAttributeWidth, -contentInset.left - contentInset.right);
    MakeEqualConstraint(containerView, scrollView, NSLayoutAttributeTop, contentInset.top);
    MakeEqualConstraint(containerView, scrollView, NSLayoutAttributeLeft, contentInset.left);
    MakeEqualConstraint(containerView, scrollView, NSLayoutAttributeBottom, contentInset.bottom);
    MakeEqualConstraint(containerView, scrollView, NSLayoutAttributeRight, contentInset.right);
}

#pragma mark - Private

// http://stackoverflow.com/questions/26213681/ios-8-keyboard-hides-my-textview/26226732#26226732
- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];

    if (self.keyboardChangedBlock) {
        self.keyboardChangedBlock(keyboardFrameBegin, keyboardFrameEnd);
    }

    [UIView commitAnimations];
}

@end
