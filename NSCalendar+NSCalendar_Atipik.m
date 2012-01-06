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
@end
