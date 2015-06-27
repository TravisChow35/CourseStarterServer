//
//  AppConstants.h
//  ThugLife
//
//  Created by SSASOFT on 2/12/15.
//  Copyright (c) 2015 SSASoft. All rights reserved.
//

#ifndef ThugLife_AppConstants_h
#define ThugLife_AppConstants_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define BUTTONS_HEIGHT_RATIO        2.83
#define FONT_DILETTANT_4_NAME       @"FontDilettant4"

#define k_MY_VIDEOS_LIST            @"My_Videos_List"
#define k_SONGS_LIST                @"Songs_List"
#define k_FREE_SONGS                @"FreeSongs"
#define k_PACKAGE_1_SONGS           @"Package1Songs"
#define k_PACKAGE_2_SONGS           @"Package2Songs"

#define k_LOGOS_LIST                @"Logos_List"
#define k_FREE_LOGOS                @"FreeLogos"

#define k_FREEZE_TIME               @"FreezeTime"
#define k_RANGE_TIME                @"RangeTime"
#define k_ZOOM_POINT                @"ZoomPoint"
#define k_LOGO_NAME                 @"LogoName"
#define k_THUG_LIFE_MERGED_VIDEO    @"ThugLifeMergedVideo.mov"
#define k_THUG_LIFE_VIDEO_PART1     @"ThugLifeVideo_Part1.mov"
#define k_THUG_LIFE_VIDEO_PART2     @"ThugLifeVideo_Part2.mov"
#define k_THUG_LIFE_FINAL_VIDEO     @"ThugLifeFinalVideo.mov"
#define k_THUG_LIFE_VIDEO           @"ThugLifeVideo.mov"

//#define SERVER_URL                  @"http://secret-wildwood-3498.herokuapp.com/catalog/"
#define SERVER_URL                  @"https://coursestarter.herokuapp.com/catalog/"
#define TIMEOUT_INTERVAL            30.0

#define USER_DATA                   @"User_Data"

#endif
