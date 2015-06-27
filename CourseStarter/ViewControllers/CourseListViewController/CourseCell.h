//
//  CourseCell.h
//  CourseStarter
//
//  Created by SSASOFT on 3/24/15.
//  Copyright (c) 2015 2rgsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseListViewController;

@interface CourseCell : UITableViewCell {
    
    CGSize boundingSize;
}

@property (nonatomic, strong) IBOutlet UILabel *name_lbl, *amount_lbl;
@property (nonatomic, strong) IBOutlet UILabel *description_lbl;
@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, weak) CourseListViewController *parentController;

-(void)adjustFontSizeToFillItsContents;
-(IBAction)clickVoteUpAction:(id)sender;

@end
