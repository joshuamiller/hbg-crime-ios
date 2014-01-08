    //
//  CTViewController.m
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/9/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import "CTViewController.h"
#import "CTCrimeReport.h"
#import "CTReportViewController.h"
#import <RestKit/RestKit.h>

@interface CTViewController ()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dateButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableDictionary *reportAnnotations;
@property (nonatomic) BOOL datePickerIsVisible;
@end

#define DATE_PICKER_FRAME CGRectMake(0, 50, 300, 162)

@implementation CTViewController

/*******************************
 Date Picker Setup and Behavior
********************************/

- (NSDate *) date {
    // Yesterday by default
    if (!_date) {
        NSDate *today = [NSDate date];
        _date = [today dateByAddingTimeInterval:-86400.0];
    }
    return _date;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:DATE_PICKER_FRAME];
        _datePicker.backgroundColor = [UIColor colorWithWhite:1.0
                                                        alpha:0.95];
        _datePicker.date = self.date;
        [_datePicker setMaximumDate:[NSDate date]];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    return _datePicker;
}

- (IBAction)changeDate:(id)sender {
    if (self.datePickerIsVisible) {
        self.dateButton.title = @"Date";
        [self dateChanged];
    } else {
        self.dateButton.title = @"Search";
        [self.view addSubview:self.datePicker];
    }
    self.datePickerIsVisible = !(self.datePickerIsVisible);
}

- (void)dateChanged {
    [self.datePicker removeFromSuperview];
    self.date = [self.datePicker date];
    [self refreshUI];
}

/*******************************
 Map Setup and Behavior
 ********************************/

- (MKCoordinateRegion) harrisburgRegion {
    MKCoordinateRegion region;
    region.center.latitude = 40.2725855;
    region.center.longitude = -76.874382;
    region.span.latitudeDelta = 0.03;
    region.span.longitudeDelta = 0.03;
    return region;
}

- (MKPointAnnotation *) annotationFromReport:(CTCrimeReport *)report {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([report.lat floatValue], [report.lng floatValue]);
    point.title = report.description;
    point.subtitle = report.titleForDisplay;
    return point;
}

- (void) addToMap:(NSArray *) reports {
    for (CTCrimeReport *report in reports) {
        MKPointAnnotation *annotation = [self annotationFromReport:report];
        [self.reportAnnotations setObject:annotation forKey:report.reportId];
        [self.mapView addAnnotation:annotation];
    }
    
}

/********************************
 Reports Table Setup and Behavior
 ********************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.reports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CTCrimeReport *report = [self.reports objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [report titleForDisplay];
    cell.detailTextLabel.text = [report description];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"GreyscaleBasic-Bold" size:14.0]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"GreyscaleBasic-Italic" size:11.0]];
    
    cell.tag = [report reportIdAsInteger];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    MKPointAnnotation *annotation = [self.reportAnnotations objectForKey:[NSNumber numberWithInt:cell.tag]];
    [self.mapView selectAnnotation:annotation animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Report"]) {
        if ([segue.destinationViewController isKindOfClass:[CTReportViewController class]]) {
            CTReportViewController *ctrvc = segue.destinationViewController;
            CTCrimeReport *reportToShow = nil;
            for (CTCrimeReport *report in self.reports) {
                if ([report reportIdAsInteger] == [sender tag]) {
                    reportToShow = report;
                }
            }
            ctrvc.report = reportToShow;
        }
    }
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
    }
    return _refreshControl;
}

- (void)refreshUI {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.reportAnnotations removeAllObjects];
    [self.refreshControl beginRefreshing];
    [CTCrimeReport loadReportsForDate:self.date
                     withSuccessBlock:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         [self.refreshControl endRefreshing];
                         self.reports = mappingResult.array;
                         [self addToMap:self.reports];
                         [self.tableView reloadData];
                     } andFailureBlock:^(RKObjectRequestOperation *operation, NSError *error) {
                         [self.refreshControl endRefreshing];
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hbg-crime.org Unreachable"
                                                                         message:@"We couldn't reach the server at http://hbg-crime.org/. Either your internet connection is down, or we are having server trouble."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil, nil];
                         [alert show];
                         RKLogError(@"Operation failed with error: %@", error);}];
}

// Main setup

- (NSMutableDictionary *)reportAnnotations {
    if (!_reportAnnotations) {
        _reportAnnotations = [[NSMutableDictionary alloc] init];
    }
    return _reportAnnotations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshUI)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [self.mapView setRegion:[self harrisburgRegion]
                   animated:YES];
    [self.mapView setZoomEnabled:YES];

    [self.navigationController.navigationBar    setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"GreyscaleBasic-Bold" size:20.0]}];
    [self.dateButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"GreyscaleBasic" size:18.0]} forState:UIControlStateNormal];
    
    [self refreshUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
