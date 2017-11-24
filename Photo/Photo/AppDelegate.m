//
//  AppDelegate.m
//  Photo
//
//  Created by zhuangzhe on 2017/8/2.
//  Copyright © 2017年 腕表之家. All rights reserved.
//

#import "AppDelegate.h"
#import "AlbumViewController.h"
#import "ARViewController.h"
#import <easyar/engine.oc.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];//
    
//    AlbumViewController *albumVC = [[AlbumViewController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:albumVC];
//    [self.window setRootViewController:navi];
    if (![easyar_Engine initialize:@"3cYSJ1eY18DNAri9zbKRyTRjMBk8NcWAzf5rjmmMCh38QbrfqmGLWmesY4Dt6cLcclQshHchRAoWNLMsltgVQ7fnLKFQstdetfcacWpsekKX8fwuhg7hffmtgRhztLsEN7R5Dxjk3gUiwLl80vlpm7IFDNOk9PAaXP0judkEsYJVZRRqtmE12NeIqWbDRyja4IZYG8cM"]) {
        NSLog(@"Initialization Failed.");
    }
    ARViewController *ar = [[ARViewController alloc] init];
    [self.window setRootViewController:ar];
    //
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
