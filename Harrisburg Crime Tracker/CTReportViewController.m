//
//  CTReportViewController.m
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/13/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import "CTReportViewController.h"

@interface CTReportViewController ()

@end

@implementation CTReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"GreyscaleBasic-Bold" size:20.0]} forState:UIControlStateNormal];
    [self.descriptionText setFont:[UIFont fontWithName:@"GreyscaleBasic"
                                                  size:24.0]];
    [self.addressTitleLabel setFont:[UIFont fontWithName:@"GreyscaleBasic-Bold"
                                                    size:18.0]];
    [self.addressLabel setFont:[UIFont fontWithName:@"GreyscaleBasic"
                                               size:16.0]];
    [self.timeTitleLabel setFont:[UIFont fontWithName:@"GreyscaleBasic-Bold"
                                                 size:18.0]];
    [self.timeLabel setFont:[UIFont fontWithName:@"GreyscaleBasic"
                                            size:16.0]];

    self.descriptionText.text = self.report.description;
    self.addressLabel.text = self.report.address;
    self.timeLabel.text = [self.report endTimeString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
