//
//  AppDelegate.m
//  NewRelicSample
//
//  Created by Semih Gokceoglu on 2021-08-23.
//

#import "AppDelegate.h"
#import <NewRelicAgent/NewRelic.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSArray*)getStackTrace {
    NSMutableArray* stackTrace = [NSMutableArray new];
    [stackTrace addObject:@"test line 1"];
    [stackTrace addObject:@"test line 2"];
    [stackTrace addObject:@"test line 3"];
    [stackTrace addObject:@"test line 4"];
    [stackTrace addObject:@"test line 5"];
    
    return stackTrace;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NRLogger setLogLevels:NRLogLevelALL];
    [NewRelicAgent enableFeatures:NRFeatureFlag_HandledExceptionEvents];
    [NewRelicAgent startWithApplicationToken:@"your_token"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"sending handled exception...");
        
        @try {
            NSException *ex = [[NSException alloc] initWithName:@"SampleTextException" reason:@"sample test msg new" userInfo:nil];
            
            // Here attach sample lines to the exception somehow =>
            // [ex setStackTrace:[self getStackTrace]]
            @throw ex;
        } @catch(NSException* exception) {
            [NewRelicAgent recordHandledException:exception];
            NSLog(@"sending handled exception is sent...");
        }
    });
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
