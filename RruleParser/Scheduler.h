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
    NSNumber *   _rrule_count ;
    NSNumber *   _rrule_until ;
    
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

    
    NSMutableArray * _exception_dates;

}


#pragma mark -
#pragma mark Properties
@property (nonatomic, retain) NSMutableArray *exception_dates;


-(id) initWithDate:(NSDate*)start_date andRule:(NSString*) rrule;
-(void) initReccurenceRules;
-(void) addReccurenceRules:(NSString*) rrule;
-(void) removeReccurenceRules;
-(void) addExceptionDates:(NSArray*) dates;
-(void) removeExceptionDates;
-(NSArray*) allOccurencesSince:(NSTimeInterval) filter_begin_ts until:(NSTimeInterval) filter_end_ts;
-(void) nextPeriod:(NSDate*) date;
-(void) checkRule:(NSDate*) date;

-(void) occurencesBetween:(NSDate*) start  andDate:(NSDate*) end;

-(void) checkDay:(NSDate*) date;

-(NSString*) dayFromNoDay:(NSInteger) day;

@end
