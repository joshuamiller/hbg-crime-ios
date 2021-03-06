//
//  CTReportViewController.h
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/13/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTCrimeReport.h"
#import "PCLineChartView.h"

@interface CTReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (strong, nonatomic) CTCrimeReport *report;
@property (strong, nonatomic) PCLineChartView *crimeHistoryView;
@end
