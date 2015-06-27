//
//  AddCourseViewController.m
//  CourseStarter
//
//  Created by SSASOFT on 4/8/15.
//  Copyright (c) 2015 2rgsolutions. All rights reserved.
//

#import "AddCourseViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define Placeholder_Text    @"What?      \n"

@interface AddCourseViewController ()

-(void)resignTextView;
-(void)requestToAddCourse;

@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"New Course";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backBtn_view] animated:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    description_TV.textColor = [UIColor lightGrayColor];
    description_TV.text = Placeholder_Text;
    NSString *imageURL = [AppInfo sharedInfo].user.profile_photo_url;
    [userImage setImageWithURL:[NSURL URLWithString:imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

-(void)resignTextView {
    
    description_TV.text = [description_TV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger count = 150-description_TV.text.length;
    remainingCount_lbl.text = [NSString stringWithFormat:@"characters remaining: %ld", (long)count];
    
    if (description_TV.text.length == 0) {
        description_TV.textColor = [UIColor lightGrayColor];
        description_TV.text = Placeholder_Text;
    }
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0, 64);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

-(void)requestToAddCourse {
    
    [SVProgressHUD showWithStatus:@"Adding new course..." maskType:SVProgressHUDMaskTypeGradient];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    UserData *user = [AppInfo sharedInfo].user;
    [data setObject:@"Casual Course" forKey:@"course_name"];
    [data setObject:user.profile_photo_url forKey:@"image_url"];
    [data setObject:description_TV.text forKey:@"description"];
    [data setObject:[NSNumber numberWithInteger:0] forKey:@"amount"];
    [data setObject:[NSNumber numberWithInteger:user.userID] forKey:@"created_by"];
    [data setObject:[NSNumber numberWithInteger:1] forKey:@"sort_order"];
    [data setObject:@"Casual" forKey:@"course_type"];
    [HTTPRequest requestPostWithMethod:@"add_course" Params:data andDelegate:self];
}

#pragma mark
#pragma mark IBAction Methods

-(IBAction)backAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneAction:(id)sender {
    
    NSString *text = [description_TV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > 0 && ![text isEqualToString:Placeholder_Text]) {
        [self requestToAddCourse];
    }
    [description_TV resignFirstResponder];
}

#pragma mark
#pragma mark UITextViewDelegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    if ([textView.text isEqualToString:Placeholder_Text]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    textView.inputAccessoryView = toolbar;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger count = textView.text.length+text.length;
    if (count <= 150) {
        return YES;
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger count = 150-textView.text.length;
    remainingCount_lbl.text = [NSString stringWithFormat:@"characters remaining: %ld", (long)count];
}

#pragma mark - Keyboard events

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat originY = (self.view.frame.size.height-(remainingCount_lbl.frame.origin.y+remainingCount_lbl.frame.size.height));
    originY -= kbSize.height;
    if (originY < 0) {
        CGRect frame = self.view.frame;
        frame.origin.y += originY;
        [UIView animateWithDuration:0.2f animations:^{
            self.view.frame = frame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self resignTextView];
}

#pragma mark
#pragma mark HTTPRequestDelegate Methods

-(void)didFinishRequest:(HTTPRequest*)httpRequest withData:(id)data {
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        if ([[data objectForKey:@"status"] intValue] == 1 && [data objectForKey:@"course"]) {
            NSMutableDictionary *course = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"course"]];
            [[AppInfo sharedInfo] addCourse:course];
            [SVProgressHUD showSuccessWithStatus:@"Course added successfully."];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[data objectForKey:@"result"]];
        }
    }
    else {
        [SVProgressHUD dismiss];
    }
}

-(void)didFailRequest:(HTTPRequest*)httpRequest withError:(NSString*)errorMessage {
    
    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
