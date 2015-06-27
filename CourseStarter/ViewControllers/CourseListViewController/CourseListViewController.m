//
//  CourseListViewController.m
//  CourseStarter
//
//  Created by SSASOFT on 3/24/15.
//  Copyright (c) 2015 2rgsolutions. All rights reserved.
//

#import "CourseListViewController.h"
#import "CourseCell.h"
#import "AddCourseViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SVPullToRefresh.h"

@interface CourseListViewController ()

-(void)loadCourses;
-(void)requestToGetCourses;
-(void)requestToVoteUpCourse:(NSDictionary*)course;
-(void)loadMoreCourses;

@end

@implementation CourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    [self.navigationItem setLeftBarButtonItem:logoutButton animated:YES];
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCourseAction:)];
    [self.navigationItem setRightBarButtonItem:plusButton animated:YES];
    
    [self.navigationItem setTitleView:segmentControl];
    
    casualCourseList = [[NSMutableArray alloc] init];
    academicCourseList = [[NSMutableArray alloc] init];
    
    __weak CourseListViewController *weakSelf = self;
    [coursesTable addPullToRefreshWithActionHandler:^{
        [weakSelf loadMoreCourses];
    } position:SVPullToRefreshPositionBottom];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[AppInfo sharedInfo].coursesList count] == 0) {
        [self requestToGetCourses];
    }
    else {
        [self loadCourses];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark Private Methods

-(void)loadMoreCourses {
    
    [HTTPRequest requestGetWithMethod:@"courses" Params:nil andDelegate:self andRequestType:HTTPRequestTypeGETCOURSES];
}

-(void)loadCourses {
    
    [casualCourseList removeAllObjects];
    [academicCourseList removeAllObjects];
    [casualCourseList addObjectsFromArray:[[AppInfo sharedInfo] getCasualCourseList]];
    [academicCourseList addObjectsFromArray:[[AppInfo sharedInfo] getAcademicCourseList]];
    
    [coursesTable reloadData];
}

-(void)requestToGetCourses {
    
    [SVProgressHUD showWithStatus:@"Loading courses..." maskType:SVProgressHUDMaskTypeGradient];
    [HTTPRequest requestGetWithMethod:@"courses" Params:nil andDelegate:self andRequestType:HTTPRequestTypeGETCOURSES];
}

-(void)requestToVoteUpCourse:(NSDictionary*)course {
    
    [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[course objectForKey:@"id"] forKey:@"course_id"];
    [data setObject:[NSNumber numberWithInteger:[AppInfo sharedInfo].user.userID] forKey:@"user_id"];
    [HTTPRequest requestPostWithMethod:@"course_like" Params:data andDelegate:self andRequestType:HTTPRequestTypeLIKECOURSE];
}

#pragma mark
#pragma mark Public Methods

-(void)voteUpAtIndex:(NSInteger)index {
    
    NSDictionary *course = nil;
    if (segmentControl.selectedSegmentIndex == 0) {
        if (index >= 0 && index < [academicCourseList count]) {
            course = [academicCourseList objectAtIndex:index];
        }
    }
    else {
        if (index >= 0 && index < [casualCourseList count]) {
            course = [casualCourseList objectAtIndex:index];
        }
    }
    if (course) {
        [self requestToVoteUpCourse:course];
    }
}

#pragma mark
#pragma mark IBAction Methods

-(IBAction)addCourseAction:(id)sender {
    
    AddCourseViewController *addCourseVC = [[AddCourseViewController alloc] initWithNibName:@"AddCourseViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:addCourseVC animated:YES];
}

-(IBAction)switchCourseListAction:(id)sender {

    [coursesTable reloadData];
}

-(IBAction)logoutAction:(id)sender {
    
    [[AppInfo sharedInfo] logoutUser];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark UITableViewDelegate/UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (segmentControl.selectedSegmentIndex == 0) {
        return [academicCourseList count];
    }
    else {
        return [casualCourseList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CourseCellIdentifier";
    CourseCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *course = nil;//[[AppInfo sharedInfo].coursesList objectAtIndex:indexPath.row];
    if (segmentControl.selectedSegmentIndex == 0) {
        course = [academicCourseList objectAtIndex:indexPath.row];
    }
    else {
        course = [casualCourseList objectAtIndex:indexPath.row];
    }
    if ([course objectForKey:@"full_name"] && (NSNull*)[course objectForKey:@"full_name"] != [NSNull null]) {
        cell.name_lbl.text = [course objectForKey:@"full_name"];
    }
    cell.description_lbl.text = [course objectForKey:@"description"];
    cell.amount_lbl.text = [NSString stringWithFormat:@"$%@", [course objectForKey:@"amount"]];
    cell.userImage.image = nil;
    [cell.userImage setImageWithURL:[NSURL URLWithString:[course objectForKey:@"image_url"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    cell.tag = indexPath.row;
    cell.parentController = self;
    [cell adjustFontSizeToFillItsContents];
    
    return cell;
}

#pragma mark
#pragma mark HTTPRequestDelegate Methods

-(void)didFinishRequest:(HTTPRequest*)httpRequest withData:(id)data {
    
    if (httpRequest.requestType == HTTPRequestTypeLIKECOURSE && [data isKindOfClass:[NSDictionary class]]) {
        if ([[data objectForKey:@"status"] intValue] == 1) {
            NSInteger course_id = [[data objectForKey:@"course_id"] integerValue];
            NSInteger amount = [[data objectForKey:@"new_amount"] integerValue];
            [[AppInfo sharedInfo] updateCourseWithID:course_id andAmount:amount];
            [self loadCourses];
            [SVProgressHUD showSuccessWithStatus:@"Vote successful."];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"You already voted this course."];
        }
    }
    else {
        [coursesTable.pullToRefreshView stopAnimating];
        if ([data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"courses"]) {
            [[AppInfo sharedInfo] addCourses:[data objectForKey:@"courses"]];
            [self loadCourses];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Server is not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

-(void)didFailRequest:(HTTPRequest*)httpRequest withError:(NSString*)errorMessage {
    
    [coursesTable.pullToRefreshView stopAnimating];
    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
