//
//  ScrollableViewController.h
//  DragonSourceCommon
//
//  Created by WeiHan on 1/28/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import "DSBaseViewController.h"

@interface ScrollableViewController : DSBaseViewController

/// The root view of view controller.
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/// The container view which all the subviews should be added to.
@property (nonatomic, strong, readonly) UIView *containerView;

/// The content inset between scrollView and containerView, defaults to UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// With autolayout, the subclass should give a valid view to lastBottomView which is used for layout children views within scroll view.
@property (nonatomic, strong) UIView *lastBottomView;

/// keyboard frame notification
///
/// CGRect values are converted to current root view's coordinates.
@property (nonatomic, copy) void (^ keyboardChangedBlock)(CGRect beginRect, CGRect endRect);

@end
