//
//  Scheduler.m
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import "Scheduler.h"

@implementation Scheduler

-(id) initWithDate:(NSDate*)start_date andRule:(NSString*) rfc_rrule{
    if (self = [super init]) {
        _rrule_wkst =   @"MO";
        _start_date = start_date;
        if (rfc_rrule) {
            [self addReccurenceRules:rfc_rrule];
        }
    }
    return self;
}


-(void) addReccurenceRules:(NSString*) rfc_rrule {
    rfc_rrule = [rfc_rrule stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange index = [rfc_rrule rangeOfString:@"RRULE:"];
    if(index.location != NSNotFound && index.location == 0){
        rfc_rrule =  [rfc_rrule substringFromIndex:index.length];
    }
    
    NSArray * rules = [rfc_rrule componentsSeparatedByString:@";"];
    NSUInteger nb_rules = [rules count];
    NSNumberFormatter * nf = [[NSNumberFormatter alloc]init];
    for (int i = 0; i < nb_rules; i++) {
        NSArray*  rule = [[rules objectAtIndex:i] componentsSeparatedByString:@"="];
        NSString * rule_value = [rule objectAtIndex:1];
        NSString * rule_name = [rule objectAtIndex:0];
        if([rule_name isEqualToString:@"FREQ"]){
            _rrule_freq = rule_value;
        }
        if([rule_name isEqualToString:@"UNTIL"]){
            NSString* until = rule_value;
            
            NSDateComponents * dc = [[NSDateComponents alloc] init];
           
            
            dc.year = [[nf numberFromString:[until substringWithRange:NSMakeRange(0, 4)]]intValue];
            dc.month = [[nf numberFromString:[until substringWithRange:NSMakeRange(4, 2)]]intValue];
            dc.day = [[nf numberFromString:[until substringWithRange:NSMakeRange(6, 2)]]intValue];
            if( [until length] > 8){
                dc.hour = [[nf numberFromString:[until substringWithRange:NSMakeRange(9, 2)]]intValue];
                dc.minute = [[nf numberFromString:[until substringWithRange:NSMakeRange(11, 2)]]intValue];
                dc.second = [[nf numberFromString:[until substringWithRange:NSMakeRange(13, 2)]]intValue];
            }
            
            _rrule_until = [[[NSCalendar currentCalendar] dateFromComponents:dc] timeIntervalSince1970];
            
            [dc release];
            
        }
        
        if ([rule_name isEqualToString:@"COUNT"]) {
            _rrule_count = [[nf numberFromString:rule_value]intValue];
        }
        
        if ([rule_name isEqualToString:@"INTERVAL"]) {
            _rrule_interval = [[nf numberFromString:rule_value]intValue];
        }
        if ([rule_name isEqualToString:@"BYSECOND"]) {
            if([rule_value isEqualToString:@""] || !rule_value){
                _rrule_bysecond = nil;
            }else{
                _rrule_bysecond = [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYMINUTE"]) {
            if([rule_value isEqualToString:@""] || !rule_value){
                _rrule_byminute = nil;
            }else{
                _rrule_byminute= [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYHOUR"]) {
            if([rule_value isEqualToString:@""] || !rule_value){
                _rrule_byhour = nil;
            }else{
                _rrule_byhour= [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYDAY"]) {
            if([rule_value isEqualToString:@""] || !rule_value){
                _rrule_byday = nil;
            }else{
                _rrule_byday= [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYMONTHDAY"]) {
            if(![_rrule_freq isEqualToString:@"WEEKLY"]){
                if([rule_value isEqualToString:@""] || !rule_value){
                    _rrule_bymonthday = nil;
                }else{
                    _rrule_bymonthday= [rule_value componentsSeparatedByString:@","];
                }
            }
        }
        if ([rule_name isEqualToString:@"BYYEARDAY"]) {
            if(![_rrule_freq isEqualToString:@"YEARLY"]){
                _rrule_byyearday= [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYWEEKNO"]) {
            if(![_rrule_freq isEqualToString:@"YEARLY"]){
                _rrule_byweekno= [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYMONTH"]) {
            _rrule_bymonth= [rule_value componentsSeparatedByString:@","];
        }
        if ([rule_name isEqualToString:@"BYSETPOS"]) {
            _rrule_bysetpos= [rule_value componentsSeparatedByString:@","];
        }
        if ([rule_name isEqualToString:@"WKST"]) {
            _rrule_wkst= rule_value;
        }
    }
    [nf release];
    
  //  NSDateComponents * dc = [[NSDateComponents alloc] init];
    
    if(!_rrule_bysecond){
        
        _rrule_bysecond = [NSArray arrayWithObject: 
                           [NSString stringWithFormat:@"%d",
                            
                            [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:_start_date].second
                            ,
                            nil]
                           
                           ];
    }
    
    if(!_rrule_byminute){
        
        _rrule_byminute = [NSArray arrayWithObject: 
                           [NSString stringWithFormat:@"%d",
                            
                            [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:_start_date].minute
                            ,
                            nil]
                           
                           ];
    }
    if(!_rrule_byhour){
        
        _rrule_byhour = [NSArray arrayWithObject: 
                           [NSString stringWithFormat:@"%d",
                            
                            [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:_start_date].hour
                            ,
                            nil]
                           
                           ];
    }
    if(!_rrule_byday && [_rrule_freq isEqualToString:@"WEEKLY"]){
        NSString * d = [NSString stringWithFormat:@"%d",
                        
                        [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:_start_date].weekday
                        ,
                        nil];
        NSLog(@"blalba",[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:_start_date].weekday);
        _rrule_byday = [NSArray arrayWithObject: 
                         
                            nil
                         ];
    }
   // [dc release];
  /*  
    
    //if BYSECOND, BYMINUTE, BYHOUR, BYDAY, BYMONTHDAY or BYMONTH unspecified, fetch values from start date
    if (!this.rrule_bysecond) {
        this.rrule_bysecond = [ this.start_date.getSeconds().toString() ];
    }
    if (!this.rrule_byminute) {
        this.rrule_byminute = [ this.start_date.getMinutes().toString() ];
    }
    if (!this.rrule_byhour) {
        this.rrule_byhour = [ this.start_date.getHours().toString() ];
    }
    if (!this.rrule_byday && this.rrule_freq == "WEEKLY") {// auto value only when freq=weekly i guess...
        this.rrule_byday = [ this.dayFromDayNo[this.start_date.getDay()] ];
    }
    if (!this.rrule_byday && !this.rrule_bymonthday && !this.rrule_byyearday && (this.rrule_freq == "MONTHLY" || this.rrule_freq == "YEARLY")) {
        this.rrule_bymonthday = [ this.start_date.getDate().toString() ];
    }
    //    if (!this.rrule_bymonth && (this.rrule_freq == "YEARLY")) {
    //        this.rrule_bymonth = [ (this.start_date.getMonth() + 1).toString() ];
    //    }
    */

}

@end
