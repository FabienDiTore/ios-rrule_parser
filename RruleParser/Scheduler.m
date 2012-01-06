//
//  Scheduler.m
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#define ALL_DATE_FLAGS NSWeekdayCalendarUnit |NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekOfYearCalendarUnit|NSHourCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit
#import "Scheduler.h"
#import "NSString+Atipik.h"
#import "NSArray+Atipik.h"
@implementation Scheduler



#pragma mark -
#pragma mark Properties
@synthesize start_date = _start_date;
@synthesize rrule_freq = _rrule_freq;
@synthesize rrule_count = _rrule_count;
@synthesize rrule_until = _rrule_until;
@synthesize rrule_interval = _rrule_interval;
@synthesize rrule_bysecond = _rrule_bysecond;
@synthesize rrule_byminute = _rrule_byminute;
@synthesize rrule_byhour = _rrule_byhour;
@synthesize rrule_byday = _rrule_byday;
@synthesize rrule_bymonthday = _rrule_bymonthday;
@synthesize rrule_byyearday = _rrule_byyearday;
@synthesize rrule_byweekno = _rrule_byweekno;
@synthesize rrule_bymonth = _rrule_bymonth;
@synthesize rrule_bysetpos = _rrule_bysetpos;
@synthesize rrule_wkst = _rrule_wkst;
@synthesize exception_dates = _exception_dates;
@synthesize current_pos = _current_pos;
@synthesize old_pos = _old_pos;



-(id) initWithDate:(NSDate*)start_date andRule:(NSString*) rfc_rrule{
    if (self = [super init]) {
        _rrule_wkst =   @"MO";
        _start_date = start_date;
        _start_ts = [start_date timeIntervalSince1970];
        self.exception_dates =[NSMutableArray array];
        
        [self initReccurenceRules];
        
        if (rfc_rrule) {
            [self addReccurenceRules:rfc_rrule];
        }
        
    }
    return self;
}

-(void) dealloc{
    
    self.start_date = nil;
    self.rrule_freq = nil;
    self.rrule_count = nil;
    self.rrule_until = nil;
    self.rrule_bysecond = nil;
    self.rrule_byminute = nil;
    self.rrule_byhour = nil;
    self.rrule_byday = nil;
    self.rrule_bymonthday = nil;
    self.rrule_byyearday = nil;
    self.rrule_byweekno = nil;
    self.rrule_bymonth = nil;
    self.rrule_bysetpos = nil;
    self.rrule_wkst = nil;
    self.exception_dates = nil;
    self.old_pos = nil;

    [super dealloc];
}
-(void) initReccurenceRules{
    _rrule_freq = nil;
    
    // both count & until are forbidden
    _rrule_count = nil;
    _rrule_until = nil;
    
    // facultative
    _rrule_interval = 1;
    _rrule_bysecond = nil;
    _rrule_byminute = nil;
    _rrule_byhour = nil;
    _rrule_byday = nil; // +1, -2, etc. only for monthly or yearly
    _rrule_bymonthday = nil;
    _rrule_byyearday = nil;
    _rrule_byweekno = nil; // only for yearly
    _rrule_bymonth = nil;
    _rrule_bysetpos = nil; // only in conjonction with others BYxxx rules
    _rrule_wkst = @"MO"; // significant where weekly interval > 1 & where yearly byweekno is specified

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
            NSDate * d =[[NSCalendar currentCalendar] dateFromComponents:dc] ;
            _rrule_until = [NSNumber numberWithFloat:[d timeIntervalSince1970]];
            
            [dc release];
            
        }
        
        if ([rule_name isEqualToString:@"COUNT"]) {
            _rrule_count = [nf numberFromString:rule_value];
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

-(void) addExceptionDates:(NSArray*) dates{
    /* var nb_date = dates.length;
     for (var i = 0; i < nb_date; i++) {
     this.exception_dates.push(dates[i].getTime());
     }
     this.exception_dates.sort();*/
    NSInteger nb_date = [dates count];
    for (int i =0 ; i< nb_date; i++) {
        [self.exception_dates addObject:[NSNumber numberWithInt:[[dates objectAtIndex:i] timeIntervalSince1970]]];
    }
}

-(void) removeExceptionDates{
    [self.exception_dates removeAllObjects];
}


-(BOOL) checkRule:(NSDate*) date{
    NSString * day = [self dayFromNoDay:  
                      [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date].weekday];
    
    NSUInteger d =   [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date].day;
    NSUInteger m =   [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:date].month;
    NSUInteger y =   [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date].year;
    NSUInteger week_no = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit fromDate:date].weekOfYear;
    NSUInteger h =   [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:date].hour;
    NSUInteger min =   [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:date].minute;
    NSUInteger s =   [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:date].second;
    if ([_rrule_freq isEqualToString:@"DAILY"]) {
        return ((!_rrule_bymonth || [_rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]]) &&
            (!_rrule_bymonthday || [_rrule_bymonthday containsObject:[NSString stringWithFormat:@"%d",d,nil]]) &&
            (!_rrule_byday || [_rrule_byday containsObject:day])
                );
    }
    if ([_rrule_freq isEqualToString:@"WEEKLY"]) {
        return ((!_rrule_bymonth || [_rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]]) &&
                (!_rrule_bymonthday || [_rrule_bymonthday containsObject:[NSString stringWithFormat:@"%d",d,nil]])
                );
    }
    if ([_rrule_freq isEqualToString:@"MONTHLY"]) {
        return ((!_rrule_bymonth || [_rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]])
                
                );
    }
    if ([_rrule_freq isEqualToString:@"YEARLY"]) {
        return YES;
    } 
    return NO;
}

-(BOOL) checkDay:(NSDate*) date{
    BOOL is_yearly = [_rrule_freq isEqualToString:@"YEARLY"];
    BOOL is_weekly = [_rrule_freq isEqualToString:@"WEEKLY"];
    NSString * day = [self dayFromNoDay:  
                      [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date].weekday];
    
    NSUInteger d =   [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date].day;
    NSUInteger m =   [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:date].month;
    NSUInteger y =   [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date].year;
    NSUInteger week_no = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit fromDate:date].weekOfYear;
  
    
    if(_rrule_bymonth){
        if(![_rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]]){
            return NO;
        }
    }
    
    if(_rrule_byday){
        NSLog(@"%@",[_rrule_byday description]);
        if(is_weekly){
            if(![_rrule_byday containsObject:day]){
                return NO;
            }
        } else {
            NSLog(@"%@",[_rrule_byday description]);
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([A-Z]+)"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
           
            BOOL found = NO;
            for (int it_wd = 0; it_wd < [_rrule_byday count]; it_wd++) {
                id matchesInString = [regex firstMatchInString:[_rrule_byday objectAtIndex:it_wd]
                                                                    options:0
                                                                      range:NSMakeRange(0, [[_rrule_byday objectAtIndex:it_wd] length])];
            
                NSRange range = [matchesInString range];
                NSNumber* str_number=[NSNumber numberWithInt:0];
                NSString* str_day=@"";
                if (range.location != 0 && range.location != NSNotFound) {
                    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
                    str_number = [nf numberFromString:[[_rrule_byday objectAtIndex:it_wd] substringToIndex:range.location]];
                    str_day = [[_rrule_byday objectAtIndex:it_wd] substringFromIndex:range.location];
                }else{
                    str_day = [_rrule_byday objectAtIndex:it_wd];
                }
                
                NSLog(@"%@ %@",str_number,str_day);
                NSArray * matching_dates = [self findWeeksDay:[NSNumber numberWithInt:y] :[NSNumber numberWithInt:m] :str_number :str_day];
                NSLog(@"%@",[matching_dates description]);
                for (int it=0; it < [matching_dates count]; it++) {
                    if ([[matching_dates objectAtIndex:it]isEqualToDate:date]) {
                        found = YES;
                        break;
                    }
                }
                
               
            }
            if(!found){
                return NO;
            }
        }
    }
    
    if(!is_weekly){
        if(_rrule_bymonthday){
            
            NSDateComponents * dc = [[NSDateComponents alloc] init];
           
            [dc setMonth:m];
            
            NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                      inUnit:NSMonthCalendarUnit
                                     forDate:[[NSCalendar currentCalendar] dateFromComponents:dc]];
            NSLog(@"%d", range.length);
            
            NSUInteger month_days_count = 0;
            NSInteger d_neg = d - 1 - month_days_count;
            BOOL found =NO;
            for (int it_md=0; it_md < [_rrule_bymonthday count]; it_md++) {
                int md = [[[_rrule_bymonthday objectAtIndex:it_md] toNumber] intValue];
               
                if(d==md || d_neg == md){
                    found = YES;
                    break;
                }
            }
            if(!found){
                return NO;
            }
        }
    
    }
    
    if(is_yearly){
        if (_rrule_byyearday) {
            BOOL found = NO;
            for (int it_yd= 0; it_yd < [_rrule_byyearday count] ; it_yd++) {
                int year_day = [[[_rrule_byyearday objectAtIndex:it_yd] toNumber]intValue];
                if (year_day > 0) {
                    NSDateComponents * dc =[[NSDateComponents alloc] init];
                    dc.year = y ;
                    dc.weekdayOrdinal = 200;
                    
                    NSDate * year_date=[[NSCalendar currentCalendar] dateFromComponents:dc];
                }
            }
        }
    }
    return YES;
}


-(NSDate*) nextPeriod:(NSDate*) date{
    NSDateComponents * dc = [[NSDateComponents alloc] init];//[[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:date];
    if([_rrule_freq isEqualToString:@"DAILY"]){
        
        dc.day =1;
    }
    if([_rrule_freq isEqualToString:@"WEEKLY"]){
        
        dc.weekOfYear =1;
    }
    if([_rrule_freq isEqualToString:@"MONTHLY"]){
        
        dc.month =1;
    }
    if([_rrule_freq isEqualToString:@"YEARLY"]){
        
        dc.year =1;
    }
    
    NSDate * d =  [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:date options:0];
    [dc release];
    return d;
}

-(NSArray*) occurencesBetween:(NSDate*) start  andDate:(NSDate*) end{
   
    return [self allOccurencesSince:
                [NSNumber numberWithFloat:
                    [start timeIntervalSince1970]
                 ] 
            until:
                [NSNumber numberWithFloat:
                    [end timeIntervalSince1970]
                 ]
            ];

}

-(NSArray*) allOccurencesSince:(NSNumber*) filter_begin_ts until:(NSNumber*) filter_end_ts{
    NSMutableArray* occurences = [NSMutableArray array];
    if ((filter_begin_ts ==nil || filter_end_ts == nil) &&
        _rrule_count == nil && _rrule_until == nil) { 
        return nil; // infinity of results => must be processed with filter_begin_ts & filter_end_ts
    }

    NSDate * current_date = _start_date;
    NSUInteger count = 0;
    NSUInteger count_period = 0;
  /*  if ([_rrule_freq isEqualToString:@"WEEKLY"]) {
        NSLog(@"%@",current_date);
        NSLog(@"bla %d %d %d %f %f %d",(!_rrule_count || count < [_rrule_count intValue]),(!_rrule_until || [current_date timeIntervalSince1970] <= [_rrule_until floatValue]), (!filter_end_ts || [current_date timeIntervalSince1970] <= [filter_end_ts floatValue]),[current_date timeIntervalSince1970], [filter_end_ts floatValue],[current_date timeIntervalSince1970]<= [filter_end_ts floatValue]);
    }*/
    while ((!_rrule_count || count < [_rrule_count intValue])
           && (!_rrule_until || [current_date timeIntervalSince1970] <= [_rrule_until floatValue])
           && (!filter_end_ts || [current_date timeIntervalSince1970] <= [filter_end_ts floatValue])
           ){

        NSDateComponents * current_date_components = [[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:current_date];
        NSString * day = [self dayFromNoDay:current_date_components.weekday];
        
        NSUInteger d        =       current_date_components.day;
        NSUInteger m        =       current_date_components.month;
        NSUInteger y        =       current_date_components.year;
        NSUInteger week_no  =       current_date_components.weekOfYear;
        NSUInteger h        =       current_date_components.hour;
        NSUInteger min      =       current_date_components.minute;
        NSUInteger s        =       current_date_components.second;
        
        self.current_pos = 1;
        self.old_pos = [NSMutableArray array];
        
        if(count_period % _rrule_interval ==0 && [self checkRule:current_date]){
            if ([_rrule_freq isEqualToString:@"DAILY"]) {
                for (int h_it = 0; h_it < [_rrule_byhour count]; h_it++) {
                    for(int min_it = 0 ; min_it < [_rrule_byminute count];min_it++){
                        for(int s_it = 0 ; s_it < [_rrule_byminute count];s_it++){
                            NSDateComponents * dc = [[NSDateComponents alloc]init];
                            [dc setYear:y];
                            [dc setMonth:m];
                            [dc setDay:d];
                            [dc setHour:[[[_rrule_byhour objectAtIndex:h_it] toNumber] intValue]];
                            [dc setMinute:[[[_rrule_byminute objectAtIndex:min_it] toNumber] intValue]];
                            [dc setSecond:[[[_rrule_bysecond objectAtIndex:s_it] toNumber] intValue]];
                            NSDate * date_to_push = [[NSCalendar currentCalendar] dateFromComponents:dc];
                            NSTimeInterval ts_to_push = [date_to_push timeIntervalSince1970];
                            [dc release];
                            
                            if(_rrule_bysetpos !=nil && [_rrule_bysetpos containsObject:[NSString stringWithFormat:@"%d",self.current_pos,nil]]){
                                self.current_pos++;
                                [self.old_pos addObject:date_to_push];
                                continue;
                            }
                            if((_rrule_until !=nil && ts_to_push > [_rrule_until floatValue]) ||
                               (filter_end_ts != nil && ts_to_push > [filter_end_ts floatValue])){
                                goto period_loop;
                            }
                            if (ts_to_push >= _start_ts) {
                                if(filter_begin_ts ==nil || ts_to_push >= [filter_begin_ts floatValue]){
                                    [occurences addObject:date_to_push];
                                }
                                count++;
                            }
                            self.current_pos++;
                            [self.old_pos addObject:date_to_push];
                            if(_rrule_count != nil && count > [_rrule_count intValue]){
                                goto period_loop;
                            }
                          
                        }
                    }
                }
            }else{
                NSDate * period_begin=nil;
                NSDate * until = nil;
                NSDateComponents * dc = [[NSDateComponents alloc] init];
              
                if([_rrule_freq isEqualToString:@"WEEKLY"]){
                    [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&period_begin
                                            interval:NULL forDate: current_date];
                                      dc.weekOfYear =1;
                    until =[[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:period_begin options:0];
                }
                
                if([_rrule_freq isEqualToString:@"MONTHLY"]){
                    [dc setDay:1];
                    [dc setMonth:m];
                    [dc setYear:y];
                    period_begin = [[NSCalendar currentCalendar] dateFromComponents:dc];
                    [dc setMonth:m+1];
                    until = [[NSCalendar currentCalendar] dateFromComponents:dc];
                } 
                
                if([_rrule_freq isEqualToString:@"YEARLY"]){
                    [dc setDay:1];
                    [dc setMonth:1];
                    [dc setYear:y];
                    period_begin = [[NSCalendar currentCalendar] dateFromComponents:dc];
                    [dc setYear:y+1];
                    until = [[NSCalendar currentCalendar] dateFromComponents:dc];
                }
                
                NSDate * it_date = period_begin;
                while ([it_date timeIntervalSince1970] < [until timeIntervalSince1970]) {
                    NSTimeInterval it_date_ts = [it_date timeIntervalSince1970];
                    if ((_rrule_until && it_date_ts > [_rrule_until floatValue])||
                        (filter_end_ts && it_date_ts > [filter_end_ts floatValue])
                        ) 
                    {
                        goto period_loop;
                    
                    }
                    if([self checkDay:it_date]){
                        for (int h_it = 0; h_it < [_rrule_byhour count]; h_it++) {
                            for(int min_it = 0 ; min_it < [_rrule_byminute count];min_it++){
                                for(int s_it = 0 ; s_it < [_rrule_byminute count];s_it++){
                                    NSDateComponents * dc =[[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:it_date];
                                    [dc setHour:[[[_rrule_byhour objectAtIndex:h_it] toNumber] intValue]];
                                    [dc setMinute:[[[_rrule_byminute objectAtIndex:min_it] toNumber] intValue]];
                                    [dc setSecond:[[[_rrule_bysecond objectAtIndex:s_it] toNumber] intValue]];
                                    NSDate * date_to_push = [[NSCalendar currentCalendar] dateFromComponents:dc];
                                    NSTimeInterval ts_to_push = [date_to_push timeIntervalSince1970];
                                    if(_rrule_bysetpos && [_rrule_bysetpos containsObject:[NSString stringWithFormat:@"%d",self.current_pos,nil]]){
                                        self.current_pos++;
                                        [self.old_pos addObject:date_to_push];
                                        continue;
                                    }
                                    if ((_rrule_until && ts_to_push > [_rrule_until floatValue]) ||
                                        (filter_end_ts && ts_to_push > [filter_end_ts floatValue])) {
                                        goto period_loop;
                                    }
                                    if (ts_to_push >= _start_ts) {
                                        if (!filter_begin_ts ||  ts_to_push>= [filter_begin_ts floatValue]) {
                                            [occurences addObject:date_to_push];
                                        }
                                        count++;
                                    }
                                    
                                    self.current_pos++;
                                    [self.old_pos addObject:date_to_push];
                                    
                                    if (_rrule_count && count >= [_rrule_count intValue]) {
                                        goto period_loop;
                                    }
                                  
                                     
                                }
                            }
                        }
                    }
                    
                    NSDateComponents * dc =[[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:it_date];
                    
                    dc.day +=1;
                    it_date = [[NSCalendar currentCalendar] dateFromComponents:dc];
                    
                    
                }
                
                if ([_rrule_bysetpos isKindOfClass:[NSArray class]]) {
                    for (int it_pos = 0; it_pos < [_rrule_bysetpos count]; it_pos++) {
                        int pos = [[[_rrule_bysetpos objectAtIndex:it_pos]toNumber] intValue];
                        if (pos < 0) {
                            pos = abs(pos);
                            NSArray * last_matching_dates = [self.old_pos reverse];
                            NSDate * matching_date = [last_matching_dates objectAtIndex:pos-1];
                            if (matching_date && [matching_date timeIntervalSince1970] >= _start_ts) {
                                [occurences addObject:matching_date];
                                count ++;
                            }
                            if (_rrule_count && count >= [_rrule_count intValue]) {
                                goto period_loop;
                            }
                        }
                    }
                }
               
                
            }
        }
        
        count_period++;
		current_date = [self nextPeriod:current_date];
    }

    period_loop:
   
    
    return occurences;
}
-(NSArray*) findWeeksDay:(NSNumber*) year :(NSNumber*) month :(NSNumber*) ordinal :(NSString*)week_day{
    NSUInteger week_day_n = [self noDayFromDay:week_day];
    NSMutableArray* dates = [NSMutableArray array];
    //if only year is specified returning each month occurence 
    // if ordinal is == 0 return all occurences
    int count = 0;
    if([ordinal intValue] >=0){
        if (!month) {
            
        }else{
            NSDateComponents * dc = [[NSDateComponents alloc] init];
            dc.year = [year intValue];
            dc.month = [month intValue];
            dc.day = 1;
            NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:dc];
            dc.month = [month intValue]+1;
            
            NSTimeInterval end_month_ts = [[[NSCalendar currentCalendar] dateFromComponents:dc] timeIntervalSince1970];
             [dc release];
            while ([date timeIntervalSince1970] < end_month_ts) {
                dc = [[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:date];
                if (dc.weekday == week_day_n) {
                    count++;
                    if ([ordinal intValue] == 0 || count == [ordinal intValue]) {
                        [dates addObject:date];
                    }
                }
                dc.day+=1;
                date = [[NSCalendar currentCalendar] dateFromComponents:dc];
            }
            
          //  [dc release];
        }
    
    }
    return dates;
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
            return @"SA";
            break;

        default:
            break;
    }
    return nil;
}
-(NSUInteger) noDayFromDay:(NSString*) day{
    if ([day isEqualToString:@"SU"]) {
        return 1;
    }
    if ([day isEqualToString:@"MO"]) {
        return 2;
    }
    if ([day isEqualToString:@"TU"]) {
        return 3;
    }
    if ([day isEqualToString:@"WE"]) {
        return 4;
    }
    if ([day isEqualToString:@"TH"]) {
        return 5;
    }
    if ([day isEqualToString:@"FR"]) {
        return 6;
    }
    if ([day isEqualToString:@"SA"]) {
        return 7;
    }
}

@end
