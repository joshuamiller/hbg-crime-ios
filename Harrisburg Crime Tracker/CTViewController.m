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
@end

@implementation CTViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Show Report"]) {
        if ([segue.destinationViewController isKindOfClass:[CTReportViewController class]]) {
            CTReportViewController *ctrvc = segue.destinationViewController;
            CTCrimeReport *report = [self.reports objectAtIndex:[sender tag]];
            ctrvc.report = report;
        }
    }
    
}

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
        [self.mapView addAnnotation:[self annotationFromReport:report]];
    }
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.mapView setRegion:[self harrisburgRegion]
                   animated:YES];
    [self.mapView setZoomEnabled:YES];
    
    [CTCrimeReport loadReportsWithSuccessBlock:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.reports = mappingResult.array;
        [self addToMap:self.reports];
        [self.tableView reloadData];
    } andFailureBlock:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView     cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CTCrimeReport *report = [self.reports objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [report titleForDisplay];
    cell.detailTextLabel.text = [report description];
    cell.tag = indexPath.row;
    return cell;
}
@end