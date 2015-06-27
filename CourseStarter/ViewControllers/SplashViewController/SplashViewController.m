//
//  SplashViewController.m
//  CourseStarter
//
//  Created by SSASOFT on 3/9/15.
//  Copyright (c) 2015 AppsMedia. All rights reserved.
//

#import "SplashViewController.h"
#import "CourseListViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface SplashViewController ()

-(void)animateTwitterButton;
-(void)connectWithTwitter;
-(void)loadCourseViewController;
-(void)signInWithData:(NSDictionary*)userData;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([UIScreen mainScreen].bounds.size.height == 480.0) {
        splash_image.image = [UIImage imageNamed:@"Splash_320x480.png"];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568.0) {
        splash_image.image = [UIImage imageNamed:@"Splash_320x568.png"];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 667.0) {
        splash_image.image = [UIImage imageNamed:@"Splash_375x667.png"];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 736.0) {
        splash_image.image = [UIImage imageNamed:@"Splash_414x736.png"];
    }
    
    shouldAnimate = YES;
    twitter_btn.hidden = YES;
    
    version_lbl.text = @"Version: 1.0";
    build_lbl.text = @"Build: 1.2";
    
    if ([[AppInfo sharedInfo] isLoggedIn]) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
                ACAccount *twitterAccount = [twitterAccounts lastObject];
                if (twitterAccount && [twitterAccount.username isEqualToString:[AppInfo sharedInfo].user.username]) {
                    shouldAnimate = NO;
                    [self loadCourseViewController];
                }
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (shouldAnimate) {
        [self performSelector:@selector(animateTwitterButton) withObject:nil afterDelay:0.5];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Private Methods

-(void)animateTwitterButton {
    
    twitter_btn.alpha = 0.0;
    twitter_btn.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        twitter_btn.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            shouldAnimate = NO;
        }
    }];
}

-(void)connectWithTwitter {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
            ACAccount *twitterAccount = [twitterAccounts lastObject];
            if (twitterAccount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:@"Connecting with twitter..." maskType:SVProgressHUDMaskTypeGradient];
                });
                NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", twitterAccount.username];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:urlString] parameters:nil];
                [request setAccount:[twitterAccounts lastObject]];
                [request performRequestWithHandler:
                 ^(NSData *responseData,
                   NSHTTPURLResponse *urlResponse,
                   NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             id data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                             if (data && [data isKindOfClass:[NSDictionary class]]) {
                                 screenName = [data objectForKey:@"screen_name"];
                                 NSMutableDictionary *userData = [NSMutableDictionary dictionary];
                                 [userData setObject:[data objectForKey:@"name"] forKey:@"full_name"];
                                 [userData setObject:[data objectForKey:@"id_str"] forKey:@"twitter_handle"];
                                 NSString *imageURL = @"";
                                 if ([data objectForKey:@"profile_image_url_https"] && (NSNull*)[data objectForKey:@"profile_image_url_https"] != [NSNull null]) {
                                     imageURL = [data objectForKey:@"profile_image_url_https"];
                                 }
                                 else if ([data objectForKey:@"profile_image_url"] && (NSNull*)[data objectForKey:@"profile_image_url"] != [NSNull null]) {
                                     imageURL = [data objectForKey:@"profile_image_url"];
                                 }
                                 if ([imageURL rangeOfString:@"_normal"].location != NSNotFound) {
                                     imageURL = [imageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                 }
                                 if ([imageURL rangeOfString:@"_bigger"].location != NSNotFound) {
                                     imageURL = [imageURL stringByReplacingOccurrencesOfString:@"_bigger" withString:@""];
                                 }
                                 if ([imageURL rangeOfString:@"_mini"].location != NSNotFound) {
                                     imageURL = [imageURL stringByReplacingOccurrencesOfString:@"_mini" withString:@""];
                                 }
                                 [userData setObject:imageURL forKey:@"profile_photo_url"];
                                 [userData setObject:[[NSDate date] description] forKey:@"uuid"];
                                 [self signInWithData:userData];
                             }
                             else {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [SVProgressHUD showErrorWithStatus:@"Connection failed."];
                                 });
                             }
                         }
                         else {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [SVProgressHUD showErrorWithStatus:@"Connection failed."];
                             });
                         }
                     }
                     else {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [SVProgressHUD showErrorWithStatus:@"Connection failed."];
                         });
                     }
                 }];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"CourseStarter" message:@"Please go to Settings.app and add your Twitter Account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }
    }];
}

-(void)loadCourseViewController {
    
    CourseListViewController *courseVC = [[CourseListViewController alloc] initWithNibName:@"CourseListViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:courseVC];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)signInWithData:(NSDictionary*)userData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Signing up..." maskType:SVProgressHUDMaskTypeGradient];
    });
    [HTTPRequest requestPostWithMethod:@"signin" Params:userData andDelegate:self];
//    [HTTPRequest requestGetWithMethod:@"courses" Params:nil andDelegate:self];
}

#pragma mark
#pragma mark IBAction Methods

-(IBAction)twitterAction:(id)sender {

    [self connectWithTwitter];
}

#pragma mark
#pragma mark HTTPRequestDelegate Methods

-(void)didFinishRequest:(HTTPRequest*)httpRequest withData:(id)data {
    
    [SVProgressHUD dismiss];
    if ([data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"profile"]) {
        [[AppInfo sharedInfo].user reloadWithData:[data objectForKey:@"profile"] andScreenName:screenName];
        [[AppInfo sharedInfo] saveResources];
        [self loadCourseViewController];
    }
}

-(void)didFailRequest:(HTTPRequest*)httpRequest withError:(NSString*)errorMessage {

    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
