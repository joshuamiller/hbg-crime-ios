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
    
    self.crimeHistoryView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0, 300, 300, 162)];
    
    PCLineChartViewComponent *crimeComp = [[PCLineChartViewComponent alloc] init];
    crimeComp.points = @[@3, @4, @5, @6, @5];
    crimeComp.title = @"This Crime";
    crimeComp.colour = PCColorBlue;

    PCLineChartViewComponent *neighborhoodComp = [[PCLineChartViewComponent alloc] init];
    neighborhoodComp.points = @[@6, @4, @2, @3, @4];
    neighborhoodComp.title = @"Midtown";
    neighborhoodComp.colour = PCColorRed;

    self.crimeHistoryView.maxValue = 6.0;
    self.crimeHistoryView.autoscaleYAxis = YES;
    self.crimeHistoryView.xLabels = [@[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri"] mutableCopy];
    [self.crimeHistoryView setComponents:[@[crimeComp, neighborhoodComp] mutableCopy]];
    [self.view addSubview:self.crimeHistoryView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
