//
//  AppInfo.h
//  ThugLife
//
//  Created by SSASOFT on 2/12/15.
//  Copyright (c) 2015 SSASoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"

@interface AppInfo : NSObject {
    
}

@property (nonatomic, readonly) UserData    *user;
@property (nonatomic, readonly) NSMutableArray  *coursesList;

+(AppInfo*)sharedInfo;
+(void)configureAppTheme;

-(BOOL)isLoggedIn;
-(void)logoutUser;
-(void)loadResources;
-(void)saveResources;
-(void)addCourses:(NSArray*)list;
-(void)addCourse:(NSDictionary*)course;
-(void)updateCourseWithID:(NSInteger)course_id andAmount:(NSInteger)amount;
-(NSMutableArray*)getCasualCourseList;
-(NSMutableArray*)getAcademicCourseList;

@end
