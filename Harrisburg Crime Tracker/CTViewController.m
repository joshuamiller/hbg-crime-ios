    //
//  CTViewController.m
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/9/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import "CTViewController.h"
#import "CTCrimeReport.h"
#import <RestKit/RestKit.h>

@interface CTViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CTViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    
    [CTCrimeReport loadReportsWithSuccessBlock:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.reports = mappingResult.array;
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
    return cell;
}
@end
