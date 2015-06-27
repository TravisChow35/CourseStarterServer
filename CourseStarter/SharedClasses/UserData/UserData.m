//
//  UserData.m
//  Muraspec
//
//  Created by Amad Khilji on 4/28/14.
//  Copyright (c) 2014 SSA Soft. All rights reserved.
//

#import "UserData.h"

@interface UserData ()

@end

@implementation UserData

@synthesize fullName, username, email, profile_photo_url, twitter_handler, uuid;
@synthesize userID;

-(id)init {
    
    self = [super init];
    if (self) {
        userID = 0;
        fullName = @"";
        username = @"";
        email = @"";
        profile_photo_url = @"";
        twitter_handler = @"";
        uuid = @"";
    }
    return self;
}

-(id)initWithData:(NSDictionary*)userData {
    
    self = [super init];
    if (self) {
        userID = 0;
        fullName = @"";
        username = @"";
        email = @"";
        profile_photo_url = @"";
        twitter_handler = @"";
        uuid = @"";
        [self reloadWithData:userData andScreenName:nil];
    }
    return self;
}

-(void)reloadWithData:(NSDictionary*)userData andScreenName:(NSString*)screenName {
    
    if (userData && [userData isKindOfClass:[NSDictionary class]]) {
        if ([userData objectForKey:@"id"] && (NSNull*)[userData objectForKey:@"id"] != [NSNull null]) {
            userID = [[userData objectForKey:@"id"] integerValue];
        }
        if ([userData objectForKey:@"full_name"] && (NSNull*)[userData objectForKey:@"full_name"] != [NSNull null]) {
            fullName = [userData objectForKey:@"full_name"];
        }
        if ([userData objectForKey:@"username"] && (NSNull*)[userData objectForKey:@"username"] != [NSNull null]) {
            username = [userData objectForKey:@"username"];
        }
        if ([userData objectForKey:@"email"] && (NSNull*)[userData objectForKey:@"email"] != [NSNull null]) {
            email = [userData objectForKey:@"email"];
        }
        if ([userData objectForKey:@"profile_photo_url"] && (NSNull*)[userData objectForKey:@"profile_photo_url"] != [NSNull null]) {
            profile_photo_url = [userData objectForKey:@"profile_photo_url"];
        }
        if ([userData objectForKey:@"twitter_handle"] && (NSNull*)[userData objectForKey:@"twitter_handle"] != [NSNull null]) {
            twitter_handler = [userData objectForKey:@"twitter_handle"];
        }
        if ([userData objectForKey:@"uuid"] && (NSNull*)[userData objectForKey:@"uuid"] != [NSNull null]) {
            uuid = [userData objectForKey:@"uuid"];
        }
    }
    if (screenName) {
        username = screenName;
    }
}

-(void)loadUserData {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:USER_DATA]) {
        NSDictionary *data = [defaults objectForKey:USER_DATA];
        [self reloadWithData:data andScreenName:nil];
    }
}

-(void)saveUserData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userData = [NSMutableDictionary dictionary];
    [userData setObject:[NSNumber numberWithInteger:userID] forKey:@"id"];
    [userData setObject:fullName forKey:@"full_name"];
    [userData setObject:username forKey:@"username"];
    [userData setObject:email forKey:@"email"];
    [userData setObject:profile_photo_url forKey:@"profile_photo_url"];
    [userData setObject:twitter_handler forKey:@"twitter_handle"];
    [userData setObject:uuid forKey:@"uuid"];
    
    [defaults setObject:userData forKey:USER_DATA];
    [defaults synchronize];
}

-(void)deleteUserData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_DATA];
    [defaults synchronize];
    
    userID = 0;
    fullName = @"";
    username = @"";
    email = @"";
    profile_photo_url = @"";
    twitter_handler = @"";
    uuid = @"";
}

@end
