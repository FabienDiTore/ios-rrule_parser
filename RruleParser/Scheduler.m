//
//  Scheduler.m
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//


#import "Scheduler.h"
#import "NSString+Atipik.h"
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


-(void) checkRule:(NSDate*) date{
    /*  switch (this.rrule_freq) {
     case "DAILY":
     return ((m === undefined || this.rrule_bymonth === false || this.rrule_bymonth.in_array(m.toString())) &&
     (d === undefined || this.rrule_bymonthday === false || this.rrule_bymonthday.in_array(d.toString())) &&
     (day === undefined || this.rrule_byday === false || this.rrule_byday.in_array(day.toString())));
     case "WEEKLY":
     return ((m === undefined || this.rrule_bymonth === false || this.rrule_bymonth.in_array(m.toString())) &&
     (d === undefined || this.rrule_bymonthday === false || this.rrule_bymonthday.in_array(d.toString())));
     case "MONTHLY":
     return (m === undefined || this.rrule_bymonth === false || this.rrule_bymonth.in_array(m.toString()));
     case "YEARLY":
     return true;
     }*/
}
-(NSDate*) nextPeriod:(NSDate*) date{
    /*Scheduler.prototype.next_period = function(date) {
     switch (this.rrule_freq) {
     case "DAILY":
     var new_date = new Date(date);
     new_date.setDate(date.getDate() + 1);
     return new_date;
     case "WEEKLY":
     return date.nextWeek();
     case "MONTHLY":
     new_date = new Date(date);
     new_date.setMonth(date.getMonth() + 1, 1);
     return new_date;
     case "YEARLY":
     new_date = new Date(date);
     new_date.setFullYear(date.getFullYear() + 1);
     return new_date;
     }
     
     }*/
    NSDateComponents * dc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit fromDate:date];
    if([_rrule_freq isEqualToString:@"DAILY"]){
        
        dc.day +=1;
    }
    if([_rrule_freq isEqualToString:@"WEEKLY"]){
        
        dc.week +=1;
    }
    if([_rrule_freq isEqualToString:@"MONTHLY"]){
        
        dc.month +=1;
    }
    if([_rrule_freq isEqualToString:@"YEARLY"]){
        
        dc.year +=1;
    }
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
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
   
    while ((!_rrule_count || count < [_rrule_count intValue])
           && (!_rrule_until || [current_date timeIntervalSince1970] <= [_rrule_until intValue])
           && (!filter_end_ts || [current_date timeIntervalSince1970] <= [filter_end_ts floatValue])
           ){
        NSString * day = [self dayFromNoDay:  
                          [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:current_date].weekday];
        
        NSUInteger d =   [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:current_date].day;
        NSUInteger m =   [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:current_date].month;
        NSUInteger y =   [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:current_date].year;
        NSUInteger week_no = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit fromDate:current_date].weekOfYear;
        NSUInteger h =   [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:current_date].hour;
        NSUInteger min =   [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:current_date].minute;
        NSUInteger s =   [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:current_date].second;
        
        self.current_pos = 1;
        self.old_pos = [NSMutableArray array];
        
        if(count_period % _rrule_interval ==0){
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
                           // goto fuck;
                        }
                    }
                }
            }
        }
        
        count_period++;
		current_date = [self nextPeriod:current_date];
    }

    period_loop:
    /*
     
period_loop:
    while ((this.rrule_count === false || count < this.rrule_count)
           && (this.rrule_until === false || current_date.getTime() <= this.rrule_until)
           && (filter_end_ts === undefined || current_date.getTime() <= filter_end_ts)) {
       ...

            } else if (["WEEKLY", "MONTHLY", "YEARLY"].in_array(this.rrule_freq)) {
                switch (this.rrule_freq) {
                    case "WEEKLY":
                        var period_begin = Date.fromWeek(week_no, y, this.rrule_wkst == "MO" ? 1 : 0);
                        var until = Date.fromWeek(week_no + 1, y, this.rrule_wkst == "MO" ? 1 : 0);
                        break;
                    case "MONTHLY":
                        period_begin = new Date(y, m - 1, 1)
                        until = new Date(y, m, 1);
                        break;
                    case "YEARLY":
                        period_begin = new Date(y, 0, 1);
                        until = new Date(y + 1, 0, 1);
                        break;
                }
                
                var it_date = period_begin;
                
                while (it_date.getTime() < until.getTime()) {
                    var it_date_ts = it_date.getTime();
                    if ((this.rrule_until !== false && it_date_ts > this.rrule_until) ||
                        (filter_end_ts !== undefined && it_date_ts > filter_end_ts)) {
                        break period_loop;
                    }
                    
                    if (this.check_day(it_date)) {
                        
                        for (h_it = 0; h_it < this.rrule_byhour.length; h_it++) {
                            for (min_it = 0; min_it < this.rrule_byminute.length; min_it++) {
                                for (s_it = 0; s_it < this.rrule_bysecond.length; s_it++) {
                                    date_to_push = new Date(it_date.getFullYear(), it_date.getMonth(), it_date.getDate(), this.rrule_byhour[h_it], this.rrule_byminute[min_it], this.rrule_bysecond[s_it]);
                                    ts_to_push = date_to_push.getTime();
                                    if (this.rrule_bysetpos !== false && !this.rrule_bysetpos.in_array(this.current_pos.toString())) {
                                        this.current_pos++;
                                        this.old_pos.push(date_to_push);
                                        continue;
                                    }
                                    if ((this.rrule_until !== false && ts_to_push > this.rrule_until) ||
                                        (filter_end_ts !== undefined && ts_to_push > filter_end_ts)) {
                                        break period_loop;
                                    }
                                    if (ts_to_push >= this.start_ts) {
                                        if (filter_begin_ts === undefined || ts_to_push >= filter_begin_ts) {
                                            occurrences.push(date_to_push);
                                        }
                                        count++;
                                    }
                                    
                                    this.current_pos++;
                                    this.old_pos.push(date_to_push);
                                    
                                    if (this.rrule_count !== false && count >= this.rrule_count) {
                                        break period_loop;
                                    }
                                }
                            }
                        }
                    }
                    it_date = new Date(it_date);
                    it_date.setDate(it_date.getDate() + 1);
                }
                // process negative values of rrule_bysetpos
                if (this.rrule_bysetpos instanceof Array) {
                    for (var it_pos = 0; it_pos < this.rrule_bysetpos.length; it_pos++) {
                        var pos = parseInt(this.rrule_bysetpos[it_pos], 10);
                        if (pos < 0) {
                            pos = Math.abs(pos);
                            var last_matching_dates = this.old_pos.reverse();
                            var matching_date = last_matching_dates[pos - 1];
                            if (matching_date && matching_date >= this.start_ts) {
                                occurrences.push(matching_date);
                                count++;
                            }
                            if (this.rrule_count !== false && count >= this.rrule_count) {
                                break period_loop;
                            }
                        }
                    }
                }
            }
        }
        
        count_period++;
        current_date = this.next_period(current_date);
    }
    
    // removes exdates
    var nb_occurrences = occurrences.length;
    var occurrences_without_exdates = [];
    for (var i = 0; i < nb_occurrences; i++) {
        var occurrence = occurrences[i];
        var ts = occurrence.getTime();
        if (!(this.exception_dates.in_array(ts))) {
            occurrences_without_exdates.push(this.test_mode ? ts : occurrence);
        }
    }
    return occurrences_without_exdates;*/
    
    return occurences;
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
