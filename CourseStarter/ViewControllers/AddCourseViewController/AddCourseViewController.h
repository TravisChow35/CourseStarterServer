//
//  AddCourseViewController.h
//  CourseStarter
//
//  Created by SSASOFT on 4/8/15.
//  Copyright (c) 2015 2rgsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCourseViewController : UIViewController <UITextViewDelegate, HTTPRequestDelegate> {
    
    IBOutlet UIImageView    *userImage;
    IBOutlet UITextView     *description_TV;
    IBOutlet UILabel        *remainingCount_lbl;
    IBOutlet UIToolbar      *toolbar;
    IBOutlet UIView         *backBtn_view;
}

-(IBAction)backAction:(id)sender;
-(IBAction)doneAction:(id)sender;

@end
