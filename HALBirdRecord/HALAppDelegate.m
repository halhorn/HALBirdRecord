//
//  HALAppDelegate.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALAppDelegate.h"
#import "HALActivityListViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALFamilyBirdKindList.h"
#import "UIDevice+HALOSVersion.h"
#import "HALSecretSettings.h"

@implementation HALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [HALGAManager setup];
    [HALGAManager sendState];

    // 事前に鳥リストを読み込み
    [HALBirdKindLoader sharedLoader];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    HALActivityListViewController *viewController = [HALActivityListViewController viewControllerFromNib];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.translucent = NO;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    [self setupUIAppearance];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [HALGAManager sendState];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupUIAppearance
{
    UINavigationBar<UIAppearance> *navBarAppearance = [UINavigationBar appearance];
    UIButton<UIAppearance> *buttonAppearance = [UIButton appearance];
    [buttonAppearance setTitleColor:kHALButtonTextColor forState:UIControlStateNormal];
    [UISegmentedControl appearance].tintColor = kHALSegmentedControlColor;
    if ([UIDevice currentDevice].majorVersion >= 7) {
        // iOS7
        navBarAppearance.barTintColor = kHALNavigationBarBackgroundColor;
        navBarAppearance.tintColor = kHALNavigationBarButtonTextColor;
    } else {
        // iOS6
        UIBarButtonItem<UIAppearance> *barButtonItemAppearance = [UIBarButtonItem appearance];
        navBarAppearance.tintColor = kHALNavigationBarBackgroundColor;
        [barButtonItemAppearance setTitleTextAttributes:
         @{
           UITextAttributeTextColor : [UIColor whiteColor],
           UITextAttributeTextShadowColor : [UIColor clearColor],
           }
                                                    forState:UIControlStateNormal];
        barButtonItemAppearance.tintColor = kHALNavigationBarButtonBackgroundColorForiOS6;
    }
    navBarAppearance.titleTextAttributes =
     @{
       UITextAttributeTextColor : kHALNavigationBarTitleTextColor,
       UITextAttributeTextShadowColor : [UIColor clearColor],
       };
}

@end
