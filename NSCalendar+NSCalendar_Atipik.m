//
//  NSCalendar+NSCalendar_Atipik.m
//  RruleParser
//
//  Created by Fabien Di Tore on 06.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import "NSCalendar+NSCalendar_Atipik.h"

@implementation NSCalendar (NSCalendar_Atipik)
-(NSDate*) dateFromYear:(NSUInteger) year month:(NSUInteger) month day:(NSUInteger) day{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:year];
    [dc setMonth:month];
    [dc setDay:day];
    NSDate* d = [self dateFromComponents:dc];
    [dc release];
    return d;
}

-(NSDate*) dateFromYear:(NSUInteger) year month:(NSUInteger) month day:(NSUInteger) day hour:(NSUInteger) hour minute:(NSUInteger) minute{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:year];
    [dc setMonth:month];
    [dc setDay:day];
    [dc setHour:hour];
    [dc setMinute:minute];
    NSDate* d = [self dateFromComponents:dc];
    [dc release];
    return d;
}

- (NSString*) rruleDateFromDate:(NSDate*) date{
	
	NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
	[dateFormat setDateFormat: @"yyyyMMdd'T'HHmmss'Z'"];
	
	
	NSString * dateUpdate =[dateFormat stringFromDate:date];
	
	
	[dateFormat release];
	/*NSString * part = [dateUpdate substringToIndex:19];
     NSString * part2 = [dateUpdate substringFromIndex:20];
     NSString * part3=nil;
     NSString * part4=nil;
     if ([part2 length]==4) {
     part3 = [part2 substringToIndex:2];
     part4 = [part2 substringFromIndex:2];
     if (part3 && part4) {
     dateUpdate = [NSString stringWithFormat:@"%@+%@:%@",part,part3,part4,nil];
     }
     }*/
	return dateUpdate;
    
}
@end
