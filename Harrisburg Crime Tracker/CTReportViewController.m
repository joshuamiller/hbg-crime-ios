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
    self.descriptionLabel.text = self.report.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
