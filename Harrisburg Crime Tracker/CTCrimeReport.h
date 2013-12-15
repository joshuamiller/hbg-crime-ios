//
//  CTCrimeReport.h
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/9/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCrimeReport : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSNumber *reportId;

+(void) loadReportsForDate:(NSDate *)date
          withSuccessBlock:success
           andFailureBlock:failure;
-(NSString *) endTimeString;
-(NSString *) titleForDisplay;
-(NSInteger) reportIdAsInteger;

@end