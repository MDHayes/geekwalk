//
//  GWAppDelegate.m
//  GlasgowWalking
//
//  Created by Chris Sloey on 17/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "GWAppDelegate.h"
#import "GWWalkOverviewViewController.h"
#import "GWWalksViewModel.h"
#import "GWWalkViewModel.h"
#import "Walk.h"
#import "Attraction.h"
#import "RoutePoint.h"
#import "QTouchposeApplication.h"

@implementation GWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Hockey App Setup
//    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"f988bf5d93a1cede8c519309b4b28545"
//                                                           delegate:self];
//    [[BITHockeyManager sharedHockeyManager] startManager];
//    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
//    [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:BITAuthenticatorIdentificationTypeDevice];
//    
    // Flurry analytics
    [Flurry setCrashReportingEnabled:NO];
    [Flurry startSession:@"QKR64836SRMMHKSSCXXX"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Set up magical record
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"WalkModel"];
    
    // For demo purposes, show the touches even when not mirroring to an external display.
    QTouchposeApplication *touchposeApplication = (QTouchposeApplication *)application;
    touchposeApplication.alwaysShowTouches = NO;

    NSString *loadedKey = @"DataLoadedDate";
    NSInteger lastLoadedTimestamp = [[NSUserDefaults standardUserDefaults] integerForKey:loadedKey];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Walks" ofType:@"plist"];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:plistPath error:nil];
    NSDate *dataUpdatedDate = [attributes fileModificationDate];
    NSInteger dataUpdatedTimestamp = [dataUpdatedDate timeIntervalSince1970];

    if (lastLoadedTimestamp < dataUpdatedTimestamp) {
        [self preloadWalks];
        [[NSUserDefaults standardUserDefaults] setInteger:dataUpdatedTimestamp forKey:loadedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    // Show VC
    GWWalksViewModel *viewModel = [GWWalksViewModel new];
    GWWalkViewModel *walkVM = viewModel.walks[0];
    GWWalkOverviewViewController *overviewVC = [[GWWalkOverviewViewController alloc] initWithViewModel:walkVM];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:overviewVC];
    [Flurry logAllPageViews:navVC];
    navVC.navigationBar.tintColor = [UIColor whiteColor];
    [navVC.navigationBar setBarTintColor:[UIColor colorWithRed:228.0f/255.0f green:47.0f/255.0f blue:136.0f/255.0f alpha:1.0]];
    navVC.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.window setRootViewController:navVC];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if( [[BITHockeyManager sharedHockeyManager].authenticator handleOpenURL:url
                                                          sourceApplication:sourceApplication
                                                                 annotation:annotation]) {
        return YES;
    }
    
    /* Your own custom URL handlers */
    
    return NO;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)preloadWalks
{
    [Walk MR_truncateAll];

    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"Walks" ofType:@"plist"];
    NSArray *walks = [[NSArray alloc] initWithContentsOfFile:plistCatPath];

    // Create walks
    for (int i = 0; i < walks.count; i++) {
        NSDictionary *walkData = walks[i];
        Walk *walk = [Walk MR_createEntity];

        walk.name = walkData[@"name"];
        walk.details = walkData[@"description"];
        walk.distanceKm = walkData[@"distanceKM"];
        walk.overviewImage = walkData[@"overviewImage"];

        NSArray *routeData = walkData[@"route"];
        if (routeData) {
            for (int j = 0; j < routeData.count; j++) {
                NSDictionary *pointData = routeData[j];
                RoutePoint *point = [RoutePoint MR_createEntity];
                point.lat = pointData[@"lat"];
                point.lng = pointData[@"long"];
                [walk addPointsObject:point];
                NSLog(@"Adding point at %@, %@", point.lat, point.lng);
            }
        }

        // Attractions
        NSArray *attractions = walkData[@"attractions"];
        for (int j = 0; j < attractions.count; j++) {
            NSDictionary *attractionData = attractions[j];

            Attraction *attraction = [Attraction MR_createEntity];

            attraction.name = attractionData[@"name"];
            attraction.entryDescription = attractionData[@"entryDescription"];
            attraction.openingTimes = attractionData[@"openingTimes"];
            attraction.lat = attractionData[@"lat"];
            attraction.lng = attractionData[@"long"];
            attraction.typeImage = attractionData[@"typeImage"];
            attraction.image = attractionData[@"image"];
            attraction.details = attractionData[@"details"];
            [walk addAttractionsObject:attraction];
        }
    }

    [[NSManagedObjectContext MR_defaultContext]
     MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
         [Flurry logEvent:@"Data Load" withParameters:@{@"success": @(success)}];
         if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

@end
