//
//  CTCrimeReport.m
//  Harrisburg Crime Tracker
//
//  Created by Joshua Miller on 12/9/13.
//  Copyright (c) 2013 Joshua Miller. All rights reserved.
//

#import "CTCrimeReport.h"
#import <RestKit/RestKit.h>

#define SERVER_URL @"http://localhost:3000/"

@implementation CTCrimeReport

-(NSString *) endTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/New_York"]];
    [formatter setDateFormat:@"MM/dd hh:mm aa"];
    return [formatter stringFromDate:self.endTime];
}

-(NSString *) titleForDisplay {
    return [[self endTimeString]stringByAppendingString:self.address];
}

+(void) loadReportsWithSuccessBlock:success
                    andFailureBlock:failure {
    
    RKObjectMapping *reportMapping =
        [RKObjectMapping mappingForClass:[CTCrimeReport class]];
    [reportMapping addAttributeMappingsFromDictionary:
     @{
       @"description": @"description",
       @"address":     @"address",
       @"lat":         @"lat",
       @"lng":         @"lng",
       @"starttime":   @"startTime",
       @"endtime":     @"endTime"}];
    RKResponseDescriptor *responseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:reportMapping
                                                     method:RKRequestMethodAny
                                                pathPattern:nil
                                                    keyPath:nil
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url =
        [NSURL URLWithString:[SERVER_URL stringByAppendingString:@"2013-12-01/2013-12-01/reports.json"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *objectRequestOperation =
        [[RKObjectRequestOperation alloc] initWithRequest:request
                                      responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation
        setCompletionBlockWithSuccess:success
                              failure:failure];
    
    [objectRequestOperation start];

}

@end
