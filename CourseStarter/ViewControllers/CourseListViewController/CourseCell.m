//
//  CourseCell.m
//  CourseStarter
//
//  Created by SSASOFT on 3/24/15.
//  Copyright (c) 2015 2rgsolutions. All rights reserved.
//

#import "CourseCell.h"
#import "CourseListViewController.h"

@implementation CourseCell

@synthesize description_lbl;
@synthesize parentController;

- (void)awakeFromNib {
    // Initialization code
    boundingSize = CGSizeMake(description_lbl.frame.size.width, description_lbl.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

-(void)adjustFontSizeToFillItsContents {
    
    NSString* text = description_lbl.text;
    CGRect boundingRect = [text boundingRectWithSize:boundingSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:description_lbl.font, NSFontAttributeName, nil]
                                             context:nil];
    if (boundingRect.size.height < boundingSize.height) {
        CGRect frame = description_lbl.frame;
        frame.size.width = boundingRect.size.width;
        frame.size.height = boundingRect.size.height;
        description_lbl.frame = frame;
    }
    
}

#pragma mark
#pragma mark IBAction Methods

-(IBAction)clickVoteUpAction:(id)sender {
    
    if (parentController && [parentController respondsToSelector:@selector(voteUpAtIndex:)]) {
        [parentController voteUpAtIndex:self.tag];
    }
}

@end
