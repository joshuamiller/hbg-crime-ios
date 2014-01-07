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

-(NSString *) formattedStringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/New_York"]];
    [formatter setDateFormat:@"MM/dd hh:mm aa"];
    return [formatter stringFromDate:date];
}

-(NSString *) endTimeString {
    return [self formattedStringForDate:self.endTime];
}

-(NSString *) titleForDisplay {
    NSMutableString *title = [[self endTimeString] mutableCopy];
    [title appendString:@": "];
    [title appendString:self.address];
    return [NSString stringWithString:title];
}

-(NSInteger) reportIdAsInteger {
    return [_reportId integerValue];
}

+(void) loadReportsForDate:date
          withSuccessBlock:success
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
       @"endtime":     @"endTime",
       @"id":          @"reportId"}];
    RKResponseDescriptor *responseDescriptor =
        [RKResponseDescriptor
         responseDescriptorWithMapping:reportMapping
                                method:RKRequestMethodAny
                           pathPattern:nil
                               keyPath:nil
                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateURLFragment = [formatter stringFromDate:date];
    NSMutableString *urlString = [dateURLFragment mutableCopy];
    [urlString appendString:@"/"];
    [urlString appendString:dateURLFragment];
    [urlString appendString:@"/reports.json"];
    
    NSURL *url =
        [NSURL URLWithString:[SERVER_URL stringByAppendingString:urlString]];
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

@implementation CTCrimeReportRelated

+(void) createWithReportId:(NSInteger)reportId
           andSuccessBlock:success
           andFailureBlock:failure {
    
    RKObjectMapping *relatedMapping =
    [RKObjectMapping mappingForClass:[CTCrimeReportRelated class]];
    [relatedMapping addAttributeMappingsFromDictionary:
     @{
       @"by-type":           @"byType",
       @"by-neighborhood":   @"byNeighborhood",
       @"neighborhood-name": @"neighborhoodName",
       @"days":              @"days"}];
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor
     responseDescriptorWithMapping:relatedMapping
     method:RKRequestMethodAny
     pathPattern:nil
     keyPath:nil
     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSString *urlString = [NSString stringWithFormat:@"reports/%d/related.json", (int)reportId];
    
    NSURL *url =
    [NSURL URLWithString:[SERVER_URL stringByAppendingString:urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *objectRequestOperation =
    [[RKObjectRequestOperation alloc] initWithRequest:request
                                  responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation
     setCompletionBlockWithSuccess:success failure:failure];
    
    [objectRequestOperation start];
    
}
@end
