//
//  UserData.h
//  Muraspec
//
//  Created by Amad Khilji on 4/28/14.
//  Copyright (c) 2014 SSA Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (atomic, readonly) NSString *fullName, *username, *email, *profile_photo_url, *twitter_handler, *uuid;
@property (atomic, readonly) NSInteger userID;

-(id)init;
-(id)initWithData:(NSDictionary*)userData;
-(void)reloadWithData:(NSDictionary*)userData andScreenName:(NSString*)screenName;
-(void)loadUserData;
-(void)saveUserData;
-(void)deleteUserData;

@end
