//
//  AppDelegate.m
//  DSBaseViewController-Example
//
//  Created by WeiHan on 12/15/16.
//  Copyright © 2016 Will Han. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate () <UINavigationControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupDDLog];

    // Setup configuration for DSBaseViewController.
    NSDictionary *options = @{
        DSBaseViewControllerOptionBackgroundColor: [UIColor colorWithRed:0.9f
                                                                   green:0.9f
                                                                    blue:0.9f
                                                                   alpha:1.0],
//        DSBaseViewControllerOptionBackBarButtonImage: [UIImage imageNamed:@"back_bar_icon"]
    };

    [BaseViewController setupWithOption:options];


    MainViewController *mainVC = [MainViewController new];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:mainVC];

    naviController.delegate = self;
    self.window.rootViewController = naviController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    PostMessage(@"");
    PostMessage([NSString stringWithFormat:@"%s, vc: %@", __func__, [viewController description]]);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    PostMessage([NSString stringWithFormat:@"%s, vc: %@", __func__, [viewController description]]);
//    PostMessage(@"");
}

#pragma mark - Private

- (void)setupDDLog
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
