//
//  BaseViewController.m
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import "BaseViewController.h"

UIImage * GetBackBarButtonImage(CGRect rect);


@interface BaseViewController ()

@property (nonatomic, assign) BOOL fReceivedMemoryWarning;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self _setupAppearance];

    if ([self conformsToProtocol:@protocol(BuildViewDelegate)]) {
        id<BuildViewDelegate> controller = (id<BuildViewDelegate>)self;

        if ([controller respondsToSelector:@selector(buildSubview:controller:)]) {
            [controller buildSubview:self.view controller:self];
        } else {
            DDLogError(@"%@ comformed BuildViewDelegate but did not implemented its delegate method!", NSStringFromClass([self class]));
        }
    }

    if (![self _hasInvalidStatusData]) {
        [self _loadDataSafely];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.willAppearBlock) {
        self.willAppearBlock(animated);
    }

    if (self.fReceivedMemoryWarning) {
        [self _loadDataSafely];
        self.fReceivedMemoryWarning = NO;
    } else {
        [self _reloadDataSafely];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.didAppearBlock) {
        self.didAppearBlock(animated);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.willDisappearBlock) {
        self.willDisappearBlock(animated);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (self.didDisappearBlock) {
        self.didDisappearBlock(animated);
    }

    [self _unloadDataSafely];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if (!self.visible && [self conformsToProtocol:@protocol(BuildViewDelegate)]) {
        DDLogVerbose(@"%@ - received memory warning.", [self class]);

        id<BuildViewDelegate> controller = (id<BuildViewDelegate>)self;

        if ([controller respondsToSelector:@selector(tearDown:)]) {
            [controller tearDown:self];
            self.fReceivedMemoryWarning = YES;
        }
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Public

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController *naviVC = self.navigationController;

    NSAssert(naviVC, @"No navigation controller in current view controller stack!");

    if (naviVC) {
        [naviVC pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popCurrentViewController
{
    return [self.navigationController popViewControllerAnimated:YES];
}

+ (UIColor *)backgroundColor
{
    return nil;
}

+ (UIImage *)backBarButtonImage
{
    return GetBackBarButtonImage(CGRectMake(0, 0, 40, 30));
}

#pragma mark - Property

- (BOOL)visible
{
    // http://stackoverflow.com/a/2777460/1677041
    return [self isViewLoaded] && self.view.window;
}

#pragma mark - Private

- (void)_setupAppearance
{
    UIColor *color = [[self class] backgroundColor];

    if (color) {
        self.view.backgroundColor = color;
    }

    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[[self class] backBarButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
        self.navigationItem.leftBarButtonItem = backBarButton;
    }
}

- (void)_loadDataSafely
{
    if ([self conformsToProtocol:@protocol(BuildViewDelegate)]) {
        id<BuildViewDelegate> controller = (id<BuildViewDelegate>)self;

        if ([controller respondsToSelector:@selector(loadDataForController:)]) {
            [controller loadDataForController:self];
        }
    }
}

- (void)_reloadDataSafely
{
    if ([self _hasInvalidStatusData]) {
        id<BuildViewDelegate> controller = (id<BuildViewDelegate>)self;
        [controller tearDown:self];
        [controller loadDataForController:self];
    }
}

- (void)_unloadDataSafely
{
    if ([self _hasInvalidStatusData]) {
        id<BuildViewDelegate> controller = (id<BuildViewDelegate>)self;
        [controller tearDown:self];
    }
}

- (BOOL)_hasInvalidStatusData
{
    BOOL result = NO;

    if ([self conformsToProtocol:@protocol(BuildViewDelegate)]) {
        id<BuildViewDelegate> controller = (id<BuildViewDelegate>)self;

        if ([controller respondsToSelector:@selector(shouldInvalidateDataForController:)]) {
            result = [controller shouldInvalidateDataForController:self];
        }
    }

    return result;
}

@end


#pragma mark - Functions

UIImage * GetBackBarButtonImage(CGRect rect)
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        CGContextRef context = UIGraphicsGetCurrentContext();

        UIGraphicsPushContext(context);
        UIGraphicsBeginImageContext(rect.size);

        UIBezierPath *bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint:CGPointMake(30.5, 66.5)];
        [bezierPath addLineToPoint:CGPointMake(2.5, 36.5)];
        [bezierPath addLineToPoint:CGPointMake(30.5, 2.5)];
        bezierPath.lineCapStyle = kCGLineCapRound;
        bezierPath.lineJoinStyle = kCGLineJoinRound;

        [UIColor.redColor setStroke];
        bezierPath.lineWidth = 4;
        [bezierPath stroke];

        CGContextAddPath(context, bezierPath.CGPath);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsPopContext();
        UIGraphicsEndImageContext();
    });

    return image;
}
