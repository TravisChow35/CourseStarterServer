//
//  SplashViewController.h
//  CourseStarter
//
//  Created by SSASOFT on 3/9/15.
//  Copyright (c) 2015 AppsMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController <HTTPRequestDelegate> {
    
    IBOutlet UIImageView    *splash_image;
    IBOutlet UIButton       *twitter_btn;
    IBOutlet UILabel        *version_lbl, *build_lbl;
    
    NSString                *screenName;
    BOOL                    shouldAnimate;
}

-(IBAction)twitterAction:(id)sender;

@end

