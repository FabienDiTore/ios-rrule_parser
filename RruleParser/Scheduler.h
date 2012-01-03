//
//  Scheduler.h
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scheduler : NSObject{
    NSDate * _start_date;
    
    NSString*   _rrule_freq;
    
    // both count & until are forbidden
    NSInteger   _rrule_count ;
    NSInteger   _rrule_until ;
    
    // facultative
    NSInteger   _rrule_interval;
    NSArray*   _rrule_bysecond ;
    NSArray*   _rrule_byminute ;
    NSArray*   _rrule_byhour ;
    NSArray*   _rrule_byday ; // +1, -2, etc. only for monthly or yearly
    NSArray*   _rrule_bymonthday ;
    NSArray*   _rrule_byyearday ;
    NSArray*   _rrule_byweekno ; // only for yearly
    NSArray*   _rrule_bymonth ;
    NSArray*   _rrule_bysetpos ; // only in conjonction with others BYxxx rules
    NSString*   _rrule_wkst;

    
    NSArray * _exception_dates;
    NSArray * _dayFromDayNo;
    NSDictionary * _dayNoFromDay;
}



-(id) initWithDate:(NSDate*)start_date andRule:(NSString*) rrule;

-(void) addReccurenceRules:(NSString*) rrule;
-(void) removeReccurenceRules;
-(void) addExceptionDates:(NSArray*) dates;
-(void) removeExceptionDates;
-(void) allOccurences;
-(void) nextPeriod:(NSDate*) date;
-(void) checkRule:(NSDate*) date;

-(void) occurencesBetween:(NSDate*) start  andDate:(NSDate*) end;

-(void) checkDay:(NSDate*) date;



@end
