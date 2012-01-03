//
//  Scheduler.h
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scheduler : NSObject{
    NSString*   _rrule_freq;
    
    // both count & until are forbidden
    NSInteger   _rrule_count ;
    NSInteger   _rrule_until ;
    
    // facultative
    NSInteger   _rrule_interval;
    NSString*   _rrule_bysecond ;
    NSString*   _rrule_byminute ;
    NSString*   _rrule_byhour ;
    NSString*   _rrule_byday ; // +1, -2, etc. only for monthly or yearly
    NSString*   _rrule_bymonthday ;
    NSString*   _rrule_byyearday ;
    NSString*   _rrule_byweekno ; // only for yearly
    NSString*   _rrule_bymonth ;
    NSString*   _rrule_bysetpos ; // only in conjonction with others BYxxx rules
    NSString*   _rrule_wkst;

}



-(id) initWithDate:(NSDate*)date andRule:(NSString*) rrule;

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
