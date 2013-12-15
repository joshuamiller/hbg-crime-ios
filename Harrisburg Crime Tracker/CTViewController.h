//
//  CTViewController.h
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/9/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CTViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *reports;
@property (nonatomic, strong) NSDate *date;

@end
