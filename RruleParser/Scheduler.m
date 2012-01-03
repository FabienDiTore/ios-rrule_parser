//
//  Scheduler.m
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import "Scheduler.h"

@implementation Scheduler

#pragma mark -
#pragma mark Properties
@synthesize exception_dates = _exception_dates;


-(id) initWithDate:(NSDate*)start_date andRule:(NSString*) rfc_rrule{
    if (self = [super init]) {
        _rrule_wkst =   @"MO";
        _start_date = start_date;
        
        self.exception_dates =[NSArray array];
        
       
        if (rfc_rrule) {
            [self addReccurenceRules:rfc_rrule];
        }
        
    }
    return self;
}
-(void) dealloc{
    
    self.exception_dates = nil;

    [super dealloc];
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
                if([rule_value isEqualToString:@""] || !rule_value){
                    _rrule_byyearday = nil;
                }else{
                    _rrule_byyearday= [rule_value componentsSeparatedByString:@","];
                }
            }
        }
        if ([rule_name isEqualToString:@"BYWEEKNO"]) {
            if(![_rrule_freq isEqualToString:@"YEARLY"]){
                if([rule_value isEqualToString:@""] || !rule_value){
                    _rrule_byweekno = nil;
                }else{
                    _rrule_byweekno= [rule_value componentsSeparatedByString:@","];
                }
            }
        }
        if ([rule_name isEqualToString:@"BYMONTH"]) {
            if([rule_value isEqualToString:@""] || !rule_value){
                _rrule_bymonth = nil;
                }else{
            _rrule_bymonth= [rule_value componentsSeparatedByString:@","];
            }
        }
        if ([rule_name isEqualToString:@"BYSETPOS"]) {
            if([rule_value isEqualToString:@""] || !rule_value){
                _rrule_bysetpos = nil;
            }else{
                _rrule_bysetpos= [rule_value componentsSeparatedByString:@","];
            }
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

        _rrule_byday = [NSArray arrayWithObject: 
                         
                        [self dayFromNoDay:[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:_start_date].weekday]
                        ];
    
    }
    
    if(!_rrule_byday && ! _rrule_bymonthday && !_rrule_byyearday && ([_rrule_freq isEqualToString:@"MONTHLY"] || [_rrule_freq isEqualToString:@"YEARLY"])){
        _rrule_bymonthday = [NSArray arrayWithObject: 
                             [NSString stringWithFormat:@"%d",
                              
                              [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:_start_date].day
                              ,
                              nil]
                             
                             ];
    }
 

}


-(NSString*) dayFromNoDay:(NSInteger) day{
    switch (day) {
        case 1:
            return @"SU";
            break;
        case 2:
            return @"MO";
            break;
        case 3:
            return @"TU";
            break;
        case 4:
            return @"WE";
            break;
        case 5:
            return @"TH";
            break;
        case 6:
            return @"FR";
            break;
        case 7:
            return @"MO";
            break;

        default:
            break;
    }
    return nil;
}
@end
