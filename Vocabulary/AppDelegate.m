
/*
 *  This file is part of 记词助手.
 *
 *	记词助手 is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License Version 2 as 
 *  published by the Free Software Foundation.
 *
 *	记词助手 is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with 记词助手.  If not, see <http://www.gnu.org/licenses/>.
 */

//
//  AppDelegate.m
//  Vocabulary
//
//  Created by 缪和光 on 12-10-18.
//  Copyright (c) 2012年 缪和光. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "TestViewController.h"
#import "HomeViewController.h"
#import "UINavigationController+Rotation_IOS6.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //友盟统计
    [MobClick startWithAppkey:@"50b828715270152727000018" reportPolicy:REALTIME channelId:@"91Store"];
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    //载入必要的预存设置
    _finishTodaysLearningPlan = [[NSUserDefaults standardUserDefaults]boolForKey:kFinishTodaysPlan];
    _planExpireTime = [[NSUserDefaults standardUserDefaults]objectForKey:kPlanExpireTime];
//    NSString *uriStr = [[NSUserDefaults standardUserDefaults]objectForKey:kTodaysPlanWordListIdURIRepresentation];
    
//    _todaysPlanWordListIdURIRepresentation = [NSURL URLWithString:uriStr];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    HomeViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *ntv = [[UINavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = ntv;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    CoreDataHelper *helper = [CoreDataHelper sharedInstance];
    [helper saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    CoreDataHelper *helper = [CoreDataHelper sharedInstance];
    [helper saveContext];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"crush");
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

- (void)setFinishTodaysLearningPlan:(BOOL)finishTodaysPlan
{
    _finishTodaysLearningPlan = finishTodaysPlan;
    [[NSUserDefaults standardUserDefaults]setBool:finishTodaysPlan forKey:kFinishTodaysPlan];
}

- (void)setPlanExpireTime:(NSDate *)planExpireTime
{
    _planExpireTime = planExpireTime;
    [[NSUserDefaults standardUserDefaults]setObject:planExpireTime forKey:kPlanExpireTime];
}

//- (void)setTodaysPlanWordListIdURIRepresentation:(NSURL *)todaysPlanWordListIdURIRepresentation
//{
//    _todaysPlanWordListIdURIRepresentation = todaysPlanWordListIdURIRepresentation;
//    [[NSUserDefaults standardUserDefaults]setObject:[todaysPlanWordListIdURIRepresentation absoluteString]forKey:kTodaysPlanWordListIdURIRepresentation];
//}

- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSLog(@"online config has fininshed and params = %@", notification.userInfo);
    NSString *newHelpDocVersion = [MobClick getConfigParams:@"helpDocVersion"];
    NSString *currentHelpVersion = [[NSUserDefaults standardUserDefaults]stringForKey:@"kCurrHelpDocVersion"];
    
    if (newHelpDocVersion.length > 0) {
        
        if (![newHelpDocVersion isEqualToString:currentHelpVersion]) {
            BOOL isNotFirstRun = [[NSUserDefaults standardUserDefaults]boolForKey:@"kIsNotFirstRun"];
            if (isNotFirstRun) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"帮助文档更新了，请查看" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];
                });
            }
            [[NSUserDefaults standardUserDefaults]setObject:newHelpDocVersion forKey:@"kCurrHelpDocVersion"];
        }
        
        
    }
}
@end
