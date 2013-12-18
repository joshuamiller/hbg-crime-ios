//
//  CTReportViewController.m
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/13/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import "CTReportViewController.h"
#import <RestKit/RestKit.h>

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
    
    [self addCrimeChart];
}

- (void)addCrimeChart {

    self.crimeHistoryView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0, 300, 300, 162)];
    self.crimeHistoryView.maxValue = 20.0;
    self.crimeHistoryView.autoscaleYAxis = YES;
    
    [CTCrimeReportRelated createWithReportId:[self.report.reportId integerValue]
                             andSuccessBlock:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                             
                                 CTCrimeReportRelated *result = [mappingResult firstObject];
                                 
                                 PCLineChartViewComponent *typeComp = [[PCLineChartViewComponent alloc] init];
                                 typeComp.points = result.byType;
                                 typeComp.title = @"This Crime";
                                 typeComp.colour = PCColorBlue;
                                 
                                 if (result.neighborhoodName) {
                                     PCLineChartViewComponent *neighborhoodComp = [[PCLineChartViewComponent alloc] init];
                                     neighborhoodComp.points = result.byNeighborhood;
                                     neighborhoodComp.title = result.neighborhoodName;
                                     neighborhoodComp.colour = PCColorRed;

                                     [self.crimeHistoryView setComponents:[@[typeComp, neighborhoodComp] mutableCopy]];
                                 } else {
                                     [self.crimeHistoryView setComponents:[@[typeComp] mutableCopy]];
                                 }

                                 self.crimeHistoryView.xLabels = [result.days mutableCopy];
                                 [self.view addSubview:self.crimeHistoryView];
                                 
                             } andFailureBlock:^(RKObjectRequestOperation *operation, NSError *error) {
                                 RKLogError(@"Operation failed with error: %@", error);}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
