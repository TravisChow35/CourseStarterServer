//
//  CourseListViewController.h
//  CourseStarter
//
//  Created by SSASOFT on 3/24/15.
//  Copyright (c) 2015 2rgsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HTTPRequestDelegate> {
    
    IBOutlet UITableView    *coursesTable;
    IBOutlet UISegmentedControl *segmentControl;
//    IBOutlet UIButton       *reload_btn;
    
    NSMutableArray      *casualCourseList, *academicCourseList;
}

-(void)voteUpAtIndex:(NSInteger)index;

-(IBAction)addCourseAction:(id)sender;
-(IBAction)switchCourseListAction:(id)sender;
-(IBAction)logoutAction:(id)sender;

@end
