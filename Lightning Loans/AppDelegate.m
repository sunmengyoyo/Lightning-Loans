//
//  AppDelegate.m
//  Lightning Loans
//
//  Created by 孙萌 on 16/4/2.
//  Copyright © 2016年 Sun Meng. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置程序的默认颜色
    [self.window setTintColor:[UIColor redColor]];
    //设置leancloud app Id
#warning 更新自己的id
    [AVOSCloud setApplicationId:@"bi1EpwgcIhXeWytA3wxY7kOz-gzGzoHsz"
                      clientKey:@"1Iitfo7VojWBrbJ4RVt0CBee"];
    //统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //是否是第一次开启 viewapplear也会调用getFirstViewURL 设置此置避免两次调用
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLaunch"];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *firstNav = [tabBarController.viewControllers firstObject];
    FirstViewController *firstVc = [firstNav.viewControllers firstObject];
    [firstVc getFirstViewURL:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedIndex = 0;
    UINavigationController *firstNav = [tabBarController.viewControllers firstObject];
    FirstViewController *firstVc = [firstNav.viewControllers firstObject];
    [firstVc getFirstViewURL:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
