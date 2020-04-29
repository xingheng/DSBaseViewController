//
//  DSBaseViewController.m
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import "DSBaseViewController.h"

DSBaseViewControllerOptionKeyType const DSBaseViewControllerOptionBackgroundColor = @"DSBaseViewControllerOptionBackgroundColor";
DSBaseViewControllerOptionKeyType const DSBaseViewControllerOptionBackBarButtonImage = @"DSBaseViewControllerOptionBackBarButtonImage";

static UIColor *DSBaseViewControllerBackgroundColor;
static UIImage *DSBaseViewControllerBackBarButtonImage;

static LoadViewControllerBlock gLoadOptionBlock;


#pragma mark - DSBaseViewController

@interface DSBaseViewController ()

@property (nonatomic, assign) BOOL fReceivedMemoryWarning;

@end

@implementation DSBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self _setupAppearance];

    if ([self.buildDelegate respondsToSelector:@selector(buildSubview:controller:)]) {
        [self.buildDelegate buildSubview:self.view controller:self];
    } else {
        DDLogError(@"%@ doesn't comform the required delegate methods of BuildViewDelegate!", self.buildDelegate);
    }

    if (![self _hasInvalidStatusData]) {
        [self _loadDataSafely];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.appearStateBlock) {
        self.appearStateBlock(YES, NO, animated, self);
    }

    if (self.willAppearBlock) {
        self.willAppearBlock(animated);
    }

    if (self.fReceivedMemoryWarning) {
        [self _loadDataSafely];
        self.fReceivedMemoryWarning = NO;
    } else {
        if ([self _hasInvalidStatusData]) {
            [self _loadDataSafely];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.appearStateBlock) {
        self.appearStateBlock(YES, YES, animated, self);
    }

    if (self.didAppearBlock) {
        self.didAppearBlock(animated);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.appearStateBlock) {
        self.appearStateBlock(NO, NO, animated, self);
    }

    if (self.willDisappearBlock) {
        self.willDisappearBlock(animated);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (self.appearStateBlock) {
        self.appearStateBlock(NO, YES, animated, self);
    }

    if (self.didDisappearBlock) {
        self.didDisappearBlock(animated);
    }

    if ([self _hasInvalidStatusData]) {
        [self _unloadDataSafely];
    }
}

#pragma clang diagnostic pop

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if (!self.visible) {
        DDLogVerbose(@"%@ - received memory warning.", [self class]);

        [self _unloadDataSafely];
        self.fReceivedMemoryWarning = YES;
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

+ (void)setupWithOption:(NSDictionary<DSBaseViewControllerOptionKeyType, id> *)options
{
    for (DSBaseViewControllerOptionKeyType key in options) {
        if ([key isEqualToString:DSBaseViewControllerOptionBackgroundColor]) {
            DSBaseViewControllerBackgroundColor = options[key];
        } else if ([key isEqualToString:DSBaseViewControllerOptionBackBarButtonImage]) {
            DSBaseViewControllerBackBarButtonImage = options[key];
        } else {
            DDLogError(@"Unexpected option key for %@ configuration, key: %@", NSStringFromClass([self class]), key);
        }
    }
}

+ (void)setupWithOptionBlock:(LoadViewControllerBlock)loadOptionBlock
{
    gLoadOptionBlock = loadOptionBlock;
}

#pragma mark - Property

- (id<BuildViewDelegate>)buildDelegate
{
    if (!_buildDelegate) {
        _buildDelegate = self;
    }

    return _buildDelegate;
}

- (BOOL)visible
{
    // http://stackoverflow.com/a/2777460/1677041
    return self.isViewLoaded && self.view.window;
}

#pragma mark - Private

- (void)_setupAppearance
{
    if (gLoadOptionBlock) {
        gLoadOptionBlock(self);
    }

    if (DSBaseViewControllerBackgroundColor) {
        self.view.backgroundColor = DSBaseViewControllerBackgroundColor;
    }

    if (self.navigationController.viewControllers.count > 1) {
        UIImage *backBarImage = DSBaseViewControllerBackBarButtonImage;
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:backBarImage style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
        self.navigationItem.leftBarButtonItem = backBarButton;
    }
}

- (void)_loadDataSafely
{
    if ([self.buildDelegate respondsToSelector:@selector(loadDataForController:)]) {
        [self.buildDelegate loadDataForController:self];
    }
}

- (void)_unloadDataSafely
{
    if ([self.buildDelegate respondsToSelector:@selector(loadDataForController:)]) {
        [self.buildDelegate tearDown:self];
    }
}

- (BOOL)_hasInvalidStatusData
{
    BOOL result = NO;

    if ([self.buildDelegate respondsToSelector:@selector(shouldInvalidateDataForController:)]) {
        result = [self.buildDelegate shouldInvalidateDataForController:self];
    }

    return result;
}

#pragma mark - BuildViewDelegate

- (void)buildSubview:(UIView *)containerView controller:(DSBaseViewController *)viewController
{
}

- (void)loadDataForController:(DSBaseViewController *)viewController
{
}

- (void)tearDown:(DSBaseViewController *)viewController
{
}

- (BOOL)shouldInvalidateDataForController:(DSBaseViewController *)viewController
{
    return NO;
}

@end

#pragma mark - DSBaseViewController (NavigationController)

@implementation DSBaseViewController (NavigationController)

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

- (__kindof UIViewController *)popCurrentViewController
{
    return [self.navigationController popViewControllerAnimated:YES];
}

@end
