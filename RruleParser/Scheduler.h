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
    NSTimeInterval _start_ts;
    
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
    NSUInteger _current_pos;
    NSMutableArray * _old_pos;
}


#pragma mark -
#pragma mark Properties
@property (nonatomic, copy) NSDate *start_date;
@property (nonatomic, copy) NSString *rrule_freq;
@property (nonatomic, copy) NSNumber *rrule_count;
@property (nonatomic, copy) NSNumber *rrule_until;
@property (nonatomic) NSInteger rrule_interval;
@property (nonatomic, copy) NSArray *rrule_bysecond;
@property (nonatomic, copy) NSArray *rrule_byminute;
@property (nonatomic, copy) NSArray *rrule_byhour;
@property (nonatomic, copy) NSArray *rrule_byday;
@property (nonatomic, copy) NSArray *rrule_bymonthday;
@property (nonatomic, copy) NSArray *rrule_byyearday;
@property (nonatomic, copy) NSArray *rrule_byweekno;
@property (nonatomic, copy) NSArray *rrule_bymonth;
@property (nonatomic, copy) NSArray *rrule_bysetpos;
@property (nonatomic, copy) NSString *rrule_wkst;
@property (nonatomic, retain) NSMutableArray *exception_dates;
@property (nonatomic) NSUInteger current_pos;
@property (nonatomic, retain) NSMutableArray *old_pos;

-(id) initWithDate:(NSDate*)start_date andRule:(NSString*) rrule;
-(void) initReccurenceRules;
-(void) addReccurenceRules:(NSString*) rrule;
-(void) removeReccurenceRules;
-(void) addExceptionDates:(NSArray*) dates;
-(void) removeExceptionDates;
-(NSArray*) allOccurencesSince:(NSNumber*) filter_begin_ts until:(NSNumber*) filter_end_ts;
-(NSDate*) nextPeriod:(NSDate*) date;
-(BOOL) checkRule:(NSDate*) date;

-(NSArray*) occurencesBetween:(NSDate*) start  andDate:(NSDate*) end;

-(BOOL) checkDay:(NSDate*) date;
-(NSArray*) findWeeksDay:(NSNumber*) year :(NSNumber*) month :(NSNumber*) ordinal :(NSString*)week_day;

-(NSString*) dayFromNoDay:(NSInteger) day;
-(NSUInteger) noDayFromDay:(NSString*) day;
@end
