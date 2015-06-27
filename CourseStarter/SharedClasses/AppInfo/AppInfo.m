//
//  AppInfo.m
//  ThugLife
//
//  Created by SSASOFT on 2/12/15.
//  Copyright (c) 2015 SSASoft. All rights reserved.
//

#import "AppInfo.h"

@interface AppInfo ()



@end

@implementation AppInfo

@synthesize coursesList;
@synthesize user;

static AppInfo *singletonInstance;
+(AppInfo*)sharedInfo {
    
    @synchronized ([AppInfo class]) {
        
        if (!singletonInstance) {
            singletonInstance = [[AppInfo alloc] init];
        }
    }
    
    return singletonInstance;
}

+(id)alloc {
    
    @synchronized ([AppInfo class]) {
        
        NSAssert(singletonInstance == nil, @"Error, trying to allocate another instance of singleton class.");
        return [super alloc];
    }
}

-(id)init {
    
    if (self = [super init]) {
        
        coursesList = [[NSMutableArray alloc] init];
        user = [[UserData alloc] init];
    }
    
    return self;
}

#pragma mark
#pragma mark Private Methods



#pragma mark
#pragma mark Public Methods

-(BOOL)isLoggedIn {

    if (user && user.userID > 0 && user.fullName.length > 0 && user.twitter_handler.length > 0) {
        return YES;
    }
    return NO;
}

-(void)logoutUser {
    
    [coursesList removeAllObjects];
    if (user) {
        [user deleteUserData];
    }
}

-(void)loadResources {
    
    [user loadUserData];
}

-(void)saveResources {

    [user saveUserData];
}

-(void)addCourses:(NSArray*)list {
    
    if (list && [list isKindOfClass:[NSArray class]]) {
        [coursesList removeAllObjects];
        [coursesList addObjectsFromArray:list];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        [coursesList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
}

-(void)addCourse:(NSDictionary*)course {
    
    if (course && [course isKindOfClass:[NSDictionary class]]) {
        [coursesList addObject:course];
    }
}

-(void)updateCourseWithID:(NSInteger)course_id andAmount:(NSInteger)amount {
    
    for (int i=0; i<[coursesList count]; i++) {
        NSDictionary *course = [coursesList objectAtIndex:i];
        if ([[course objectForKey:@"id"] integerValue] == course_id) {
            NSMutableDictionary *updatedCourse = [NSMutableDictionary dictionaryWithDictionary:course];
            [updatedCourse setObject:[NSNumber numberWithInteger:amount] forKey:@"amount"];
            [coursesList replaceObjectAtIndex:i withObject:updatedCourse];
            break;
        }
    }
}

-(NSMutableArray*)getCasualCourseList {

    NSMutableArray *list = [NSMutableArray array];
    for (int i=0; i<[coursesList count]; i++) {
        NSDictionary *course = [coursesList objectAtIndex:i];
        if ([[course objectForKey:@"course_type"] caseInsensitiveCompare:@"casual"] == NSOrderedSame) {
            [list addObject:course];
        }
    }
    return list;
}

-(NSMutableArray*)getAcademicCourseList {
    
    NSMutableArray *list = [NSMutableArray array];
    for (int i=0; i<[coursesList count]; i++) {
        NSDictionary *course = [coursesList objectAtIndex:i];
        if ([[course objectForKey:@"course_type"] caseInsensitiveCompare:@"academic"] == NSOrderedSame) {
            [list addObject:course];
        }
    }
    return list;
}

#pragma mark
#pragma mark Static Methods

+(void)configureAppTheme {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:52.0/255.0 green:161.0/255.0 blue:222.0/255.0 alpha:1.0]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:navbarTitleTextAttributes
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

@end
