//
//  CTReportViewController.h
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/13/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTCrimeReport.h"

@interface CTReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) CTCrimeReport *report;
@end
