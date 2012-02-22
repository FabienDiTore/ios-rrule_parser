//
//  Scheduler.m
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#define ALL_DATE_FLAGS NSWeekdayCalendarUnit |NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekOfYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#import "Scheduler.h"
#import "NSString+Atipik.h"
#import "NSArray+Atipik.h"
#import "NSCalendar+NSCalendar_Atipik.h"
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
        self.rrule_wkst =   @"MO";
        self.start_date = start_date;
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
    self.rrule_freq = nil;
    
    // both count & until are forbidden
    self.rrule_count = nil;
    self.rrule_until = nil;
    
    // facultative
    self.rrule_interval = 1;
    self.rrule_bysecond = nil;
    self.rrule_byminute = nil;
    self.rrule_byhour = nil;
    self.rrule_byday = nil; // +1, -2, etc. only for monthly or yearly
    self.rrule_bymonthday = nil;
    self.rrule_byyearday = nil;
    self.rrule_byweekno = nil; // only for yearly
    self.rrule_bymonth = nil;
    self.rrule_bysetpos = nil; // only in conjonction with others BYxxx rules
    self.rrule_wkst = @"MO"; // significant where weekly interval > 1 & where yearly byweekno is specified
    
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
    NSLog(@"%@",[rules description]);
    for (int i = 0; i < nb_rules; i++) {
        if ([rules objectAtIndex:i] && ![[rules objectAtIndex:i] isEqualToString:@""]) {
            
            
            NSArray*  rule = [[rules objectAtIndex:i] componentsSeparatedByString:@"="];
            NSString * rule_value = [rule objectAtIndex:1];
            NSString * rule_name = [rule objectAtIndex:0];
            if([rule_name isEqualToString:@"FREQ"]){
                self.rrule_freq = rule_value;
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
                self.rrule_until = [NSNumber numberWithFloat:[d timeIntervalSince1970]];
                
                [dc release];
                
            }
            
            if ([rule_name isEqualToString:@"COUNT"]) {
                self.rrule_count = [nf numberFromString:rule_value];
            }
            
            if ([rule_name isEqualToString:@"INTERVAL"]) {
                self.rrule_interval = [[nf numberFromString:rule_value]intValue];
            }
            if ([rule_name isEqualToString:@"BYSECOND"]) {
                if([rule_value isEqualToString:@""] || !rule_value){
                    self.rrule_bysecond = nil;
                }else{
                    self.rrule_bysecond = [rule_value componentsSeparatedByString:@","];
                }
            }
            if ([rule_name isEqualToString:@"BYMINUTE"]) {
                if([rule_value isEqualToString:@""] || !rule_value){
                    self.rrule_byminute = nil;
                }else{
                    self.rrule_byminute= [rule_value componentsSeparatedByString:@","];
                }
            }
            if ([rule_name isEqualToString:@"BYHOUR"]) {
                if([rule_value isEqualToString:@""] || !rule_value){
                    self.rrule_byhour = nil;
                }else{
                    self.rrule_byhour= [rule_value componentsSeparatedByString:@","];
                }
            }
            if ([rule_name isEqualToString:@"BYDAY"]) {
                if([rule_value isEqualToString:@""] || !rule_value){
                    self.rrule_byday = nil;
                }else{
                    self.rrule_byday= [rule_value componentsSeparatedByString:@","];
                }
            }
            if ([rule_name isEqualToString:@"BYMONTHDAY"]) {
                if(![self.rrule_freq isEqualToString:@"WEEKLY"]){
                    if([rule_value isEqualToString:@""] || !rule_value){
                        self.rrule_bymonthday = nil;
                    }else{
                        self.rrule_bymonthday= [rule_value componentsSeparatedByString:@","];
                    }
                }
            }
            if ([rule_name isEqualToString:@"BYYEARDAY"]) {
                if(![self.rrule_freq isEqualToString:@"YEARLY"]){
                    if([rule_value isEqualToString:@""] || !rule_value){
                        self.rrule_byyearday = nil;
                    }else{
                        self.rrule_byyearday= [rule_value componentsSeparatedByString:@","];
                    }
                }
            }
            if ([rule_name isEqualToString:@"BYWEEKNO"]) {
                if(![self.rrule_freq isEqualToString:@"YEARLY"]){
                    if([rule_value isEqualToString:@""] || !rule_value){
                        self.rrule_byweekno = nil;
                    }else{
                        self.rrule_byweekno= [rule_value componentsSeparatedByString:@","];
                    }
                }
            }
            if ([rule_name isEqualToString:@"BYMONTH"]) {
                if([rule_value isEqualToString:@""] || !rule_value){
                    self.rrule_bymonth = nil;
                }else{
                    self.rrule_bymonth= [rule_value componentsSeparatedByString:@","];
                }
            }
            if ([rule_name isEqualToString:@"BYSETPOS"]) {
                if([rule_value isEqualToString:@""] || !rule_value){
                    self.rrule_bysetpos = nil;
                }else{
                    self.rrule_bysetpos= [rule_value componentsSeparatedByString:@","];
                }
            }
            if ([rule_name isEqualToString:@"WKST"]) {
                self.rrule_wkst= rule_value;
            }
        }
    }
    [nf release];
    
    //  NSDateComponents * dc = [[NSDateComponents alloc] init];
    
    if(!self.rrule_bysecond){
        
        self.rrule_bysecond = [NSArray arrayWithObject: 
                               [NSString stringWithFormat:@"%d",
                                
                                [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self.start_date].second
                                ,
                                nil]
                               
                               ];
    }
    
    if(!self.rrule_byminute){
        
        self.rrule_byminute = [NSArray arrayWithObject: 
                               [NSString stringWithFormat:@"%d",
                                
                                [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self.start_date].minute
                                ,
                                nil]
                               
                               ];
    }
    if(!self.rrule_byhour){
        
        self.rrule_byhour = [NSArray arrayWithObject: 
                             [NSString stringWithFormat:@"%d",
                              
                              [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self.start_date].hour
                              ,
                              nil]
                             
                             ];
    }
    if(!self.rrule_byday && [self.rrule_freq isEqualToString:@"WEEKLY"]){
        
        self.rrule_byday = [NSArray arrayWithObject: 
                            
                            [self dayFromNoDay:[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self.start_date].weekday]
                            ];
        
    }
    
    if(!self.rrule_byday && ! self.rrule_bymonthday && !self.rrule_byyearday && ([self.rrule_freq isEqualToString:@"MONTHLY"] || [self.rrule_freq isEqualToString:@"YEARLY"])){
        
        self.rrule_bymonthday = [NSArray arrayWithObject: 
                                 [NSString stringWithFormat:@"%d",
                                  
                                  [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.start_date].day
                                  ,
                                  nil]
                                 
                                 ];
        NSLog(@"%@",self.rrule_bymonthday);
    }
    
    if (!self.rrule_byday && !self.rrule_byyearday && !self.rrule_bymonth && [self.rrule_freq isEqualToString:@"YEARLY"]) {
        self.rrule_bymonth =  [NSArray arrayWithObject: 
                               [NSString stringWithFormat:@"%d",
                                
                                [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self.start_date].month
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
    if ([self.rrule_freq isEqualToString:@"DAILY"]) {
        return ((!self.rrule_bymonth || [self.rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]]) &&
                (!self.rrule_bymonthday || [self.rrule_bymonthday containsObject:[NSString stringWithFormat:@"%d",d,nil]]) &&
                (!self.rrule_byday || [self.rrule_byday containsObject:day])
                );
    }
    if ([self.rrule_freq isEqualToString:@"WEEKLY"]) {
        return ((!self.rrule_bymonth || [self.rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]]) &&
                (!self.rrule_bymonthday || [self.rrule_bymonthday containsObject:[NSString stringWithFormat:@"%d",d,nil]])
                );
    }
    if ([self.rrule_freq isEqualToString:@"MONTHLY"]) {
        return ((!self.rrule_bymonth || [self.rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]])
                
                );
    }
    if ([self.rrule_freq isEqualToString:@"YEARLY"]) {
        return YES;
    } 
    return NO;
}

-(BOOL) checkDay:(NSDate*) date{
    BOOL is_yearly = [self.rrule_freq isEqualToString:@"YEARLY"];
    BOOL is_weekly = [self.rrule_freq isEqualToString:@"WEEKLY"];
    NSString * day = [self dayFromNoDay:  
                      [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date].weekday];
    
    NSUInteger d =   [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date].day;
    NSUInteger m =   [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:date].month;
    NSUInteger y =   [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date].year;
    NSUInteger week_no = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit fromDate:date].weekOfYear;
    
    
    if(self.rrule_bymonth){
        //  NSLog(@"%@",self.rrule_bymonth);
        if(![self.rrule_bymonth containsObject:[NSString stringWithFormat:@"%d",m,nil]]){
            return NO;
        }
    }
    
    if(self.rrule_byday){
        //   NSLog(@"%@",[self.rrule_byday description]);
        if(is_weekly){
            if(![self.rrule_byday containsObject:day]){
                return NO;
            }
        } else {
            //     NSLog(@"%@",[self.rrule_byday description]);
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([A-Z]+)"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            
            BOOL found = NO;
            for (int it_wd = 0; it_wd < [self.rrule_byday count]; it_wd++) {
                id matchesInString = [regex firstMatchInString:[self.rrule_byday objectAtIndex:it_wd]
                                                       options:0
                                                         range:NSMakeRange(0, [[self.rrule_byday objectAtIndex:it_wd] length])];
                
                NSRange range = [matchesInString range];
                NSNumber* str_number=[NSNumber numberWithInt:0];
                NSString* str_day=@"";
                if (range.location != 0 && range.location != NSNotFound) {
                    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
                    str_number = [nf numberFromString:[[self.rrule_byday objectAtIndex:it_wd] substringToIndex:range.location]];
                    str_day = [[self.rrule_byday objectAtIndex:it_wd] substringFromIndex:range.location];
                }else{
                    str_day = [self.rrule_byday objectAtIndex:it_wd];
                }
                
                //  NSLog(@"%@ %@",str_number,str_day);
                NSArray * matching_dates = [self findWeeksDay:[NSNumber numberWithInt:y] :[NSNumber numberWithInt:m] :str_number :str_day];
                //     NSLog(@"%@",[matching_dates description]);
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
        if(self.rrule_bymonthday){
            
            NSDateComponents * dc = [[NSDateComponents alloc] init];
            
            [dc setMonth:m];
            
            NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                               inUnit:NSMonthCalendarUnit
                                                              forDate:[[NSCalendar currentCalendar] dateFromComponents:dc]];
            //   NSLog(@"%d", range.length);
            
            NSUInteger month_days_count = range.length;
            NSInteger d_neg = d - 1 - month_days_count;
            BOOL found =NO;
            for (int it_md=0; it_md < [self.rrule_bymonthday count]; it_md++) {
                int md = [[[self.rrule_bymonthday objectAtIndex:it_md] toNumber] intValue];
                
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
        if (self.rrule_byyearday) {
            BOOL found = NO;
            for (int it_yd= 0; it_yd < [self.rrule_byyearday count] ; it_yd++) {
                int year_day = [[[self.rrule_byyearday objectAtIndex:it_yd] toNumber]intValue];
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
    if([self.rrule_freq isEqualToString:@"DAILY"]){
        
        dc.day =1;
    }
    if([self.rrule_freq isEqualToString:@"WEEKLY"]){
        
        dc.weekOfYear =1;
    }
    if([self.rrule_freq isEqualToString:@"MONTHLY"]){
        
        dc.month =1;
    }
    if([self.rrule_freq isEqualToString:@"YEARLY"]){
        
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
        self.rrule_count == nil && self.rrule_until == nil) { 
        return nil; // infinity of results => must be processed with filter_begin_ts & filter_end_ts
    }
    
    NSDate * current_date = self.start_date;
    NSUInteger count = 0;
    NSUInteger count_period = 0;
    /*  if ([self.rrule_freq isEqualToString:@"WEEKLY"]) {
     NSLog(@"%@",current_date);
     NSLog(@"bla %d %d %d %f %f %d",(!self.rrule_count || count < [self.rrule_count intValue]),(!self.rrule_until || [current_date timeIntervalSince1970] <= [self.rrule_until floatValue]), (!filter_end_ts || [current_date timeIntervalSince1970] <= [filter_end_ts floatValue]),[current_date timeIntervalSince1970], [filter_end_ts floatValue],[current_date timeIntervalSince1970]<= [filter_end_ts floatValue]);
     }*/
    while ((!self.rrule_count || count < [self.rrule_count intValue])
           && (!self.rrule_until || [current_date timeIntervalSince1970] <= [self.rrule_until floatValue])
           && (!filter_end_ts || [current_date timeIntervalSince1970] <= [filter_end_ts floatValue])
           ){
        
        NSDateComponents * current_date_components = [[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:current_date];
        // NSString * day = [self dayFromNoDay:current_date_components.weekday];
        
        NSUInteger d        =       current_date_components.day;
        NSUInteger m        =       current_date_components.month;
        NSUInteger y        =       current_date_components.year;
        /*    NSUInteger week_no  =       current_date_components.weekOfYear;
         NSUInteger h        =       current_date_components.hour;
         NSUInteger min      =       current_date_components.minute;
         NSUInteger s        =       current_date_components.second;
         */  
        self.current_pos = 1;
        self.old_pos = [NSMutableArray array];
        
        if(count_period % self.rrule_interval ==0 && [self checkRule:current_date]){
            if ([self.rrule_freq isEqualToString:@"DAILY"]) {
                for (int h_it = 0; h_it < [self.rrule_byhour count]; h_it++) {
                    for(int min_it = 0 ; min_it < [self.rrule_byminute count];min_it++){
                        for(int s_it = 0 ; s_it < [self.rrule_byminute count];s_it++){
                            NSDateComponents * dc = [[NSDateComponents alloc]init];
                            [dc setYear:y];
                            [dc setMonth:m];
                            [dc setDay:d];
                            [dc setHour:[[[self.rrule_byhour objectAtIndex:h_it] toNumber] intValue]];
                            [dc setMinute:[[[self.rrule_byminute objectAtIndex:min_it] toNumber] intValue]];
                            [dc setSecond:[[[self.rrule_bysecond objectAtIndex:s_it] toNumber] intValue]];
                            NSDate * date_to_push = [[NSCalendar currentCalendar] dateFromComponents:dc];
                            NSTimeInterval ts_to_push = [date_to_push timeIntervalSince1970];
                            [dc release];
                            
                            if(self.rrule_bysetpos !=nil && [self.rrule_bysetpos containsObject:[NSString stringWithFormat:@"%d",self.current_pos,nil]]){
                                self.current_pos++;
                                [self.old_pos addObject:date_to_push];
                                continue;
                            }
                            if((self.rrule_until !=nil && ts_to_push > [self.rrule_until floatValue]) ||
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
                            if(self.rrule_count != nil && count > [self.rrule_count intValue]){
                                goto period_loop;
                            }
                            
                        }
                    }
                }
            }else{
                NSDate * period_begin=nil;
                NSDate * until = nil;
                NSDateComponents * dc = [[NSDateComponents alloc] init];
                
                if([self.rrule_freq isEqualToString:@"WEEKLY"]){
                    [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&period_begin
                                                     interval:NULL forDate: current_date];
                    dc.weekOfYear =1;
                    until =[[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:period_begin options:0];
                }
                
                if([self.rrule_freq isEqualToString:@"MONTHLY"]){
                    [dc setDay:1];
                    [dc setMonth:m];
                    [dc setYear:y];
                    period_begin = [[NSCalendar currentCalendar] dateFromComponents:dc];
                    [dc setMonth:m+1];
                    until = [[NSCalendar currentCalendar] dateFromComponents:dc];
                } 
                
                if([self.rrule_freq isEqualToString:@"YEARLY"]){
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
                    if ((self.rrule_until && it_date_ts > [self.rrule_until floatValue])||
                        (filter_end_ts && it_date_ts > [filter_end_ts floatValue])
                        ) 
                    {
                        goto period_loop;
                        
                    }
                    if([self checkDay:it_date]){
                        for (int h_it = 0; h_it < [self.rrule_byhour count]; h_it++) {
                            for(int min_it = 0 ; min_it < [self.rrule_byminute count];min_it++){
                                for(int s_it = 0 ; s_it < [self.rrule_byminute count];s_it++){
                                    NSDateComponents * dc =[[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:it_date];
                                    [dc setHour:[[[self.rrule_byhour objectAtIndex:h_it] toNumber] intValue]];
                                    [dc setMinute:[[[self.rrule_byminute objectAtIndex:min_it] toNumber] intValue]];
                                    [dc setSecond:[[[self.rrule_bysecond objectAtIndex:s_it] toNumber] intValue]];
                                    NSDate * date_to_push = [[NSCalendar currentCalendar] dateFromComponents:dc];
                                    NSTimeInterval ts_to_push = [date_to_push timeIntervalSince1970];
                                    if(self.rrule_bysetpos && [self.rrule_bysetpos containsObject:[NSString stringWithFormat:@"%d",self.current_pos,nil]]){
                                        self.current_pos++;
                                        [self.old_pos addObject:date_to_push];
                                        continue;
                                    }
                                    if ((self.rrule_until && ts_to_push > [self.rrule_until floatValue]) ||
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
                                    
                                    if (self.rrule_count && count >= [self.rrule_count intValue]) {
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
                
                if ([self.rrule_bysetpos isKindOfClass:[NSArray class]]) {
                    for (int it_pos = 0; it_pos < [self.rrule_bysetpos count]; it_pos++) {
                        int pos = [[[self.rrule_bysetpos objectAtIndex:it_pos]toNumber] intValue];
                        if (pos < 0) {
                            pos = abs(pos);
                            NSArray * last_matching_dates = [self.old_pos reverse];
                            NSDate * matching_date = [last_matching_dates objectAtIndex:pos-1];
                            if (matching_date && [matching_date timeIntervalSince1970] >= _start_ts) {
                                [occurences addObject:matching_date];
                                count ++;
                            }
                            if (self.rrule_count && count >= [self.rrule_count intValue]) {
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
        
    }else{
        if(!month){
            
        }else{
            NSUInteger nth = abs([ordinal intValue]);
            NSDate * date = [[NSCalendar currentCalendar] dateFromYear:[year intValue] month:[month intValue]+1 day:0];
            NSTimeInterval begin_month_ts = [[[NSCalendar currentCalendar] dateFromYear:[year intValue] month:[month intValue] day:1] timeIntervalSince1970];
            count = 0;
            
            while ([date timeIntervalSince1970] >= begin_month_ts) {
                NSDateComponents * dc = [[NSCalendar currentCalendar] components:ALL_DATE_FLAGS fromDate:date];;
                if (dc.weekday == week_day_n) {
                    count++;
                    if (nth == 0 || count == nth) {
                        [dates addObject:date];
                    }
                }
                dc.day-=1;
                date = [[NSCalendar currentCalendar] dateFromComponents:dc];
            }
            
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
    return 0;
}

-(BOOL) isDaily{
    return ([self.rrule_freq isEqualToString:@"DAILY"] && ![self isComplex] && (self.rrule_interval == 1));
}
-(BOOL) isWeekly{
    return ([self.rrule_freq isEqualToString:@"WEEKLY"] && ![self isComplex] && (self.rrule_interval == 1));
}
-(BOOL) isBiWeekly{
    return ([self.rrule_freq isEqualToString:@"WEEKLY"] && ![self isComplex] && (self.rrule_interval == 2));
}
-(BOOL) isMonthly{
    return ([self.rrule_freq isEqualToString:@"MONTHLY"] && ![self isComplex] && (self.rrule_interval == 1));
}
-(BOOL) isYearly{
    return ([self.rrule_freq isEqualToString:@"YEARLY"] && ![self isComplex] && (self.rrule_interval == 1));
}

-(BOOL) isComplex{
    return (self.rrule_count /*|| self.rrule_bysecond || self.rrule_byminute || self.rrule_byhour */|| self.rrule_byday || self.rrule_bymonthday || self.rrule_byyearday || self.rrule_byweekno || self.rrule_bymonth || self.rrule_bysetpos );
}

-(NSString*) getRule{
    NSString * rule = @"";
    
    if(self.rrule_freq){
        rule = [rule stringByAppendingFormat:@"FREQ=%@;",self.rrule_freq,nil];
    }
    
    if(self.rrule_until){
        rule = [rule stringByAppendingFormat:@"UNTIL=%@;",[[NSCalendar currentCalendar] rruleDateFromDate:[NSDate dateWithTimeIntervalSince1970:[self.rrule_until intValue]]],nil];
    }
    
    if(self.rrule_interval && self.rrule_interval > 1){
        rule = [rule stringByAppendingFormat:@"INTERVAL=%d;",self.rrule_interval,nil];
    }
    
    if(self.rrule_count){
        rule = [rule stringByAppendingFormat:@"COUNT=%d;",[self.rrule_count intValue],nil];
    }
 /*   
    if(self.rrule_bysecond){
        rule = [rule stringByAppendingFormat:@"BYSECOND=%@;",[self.rrule_bysecond componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_byminute){
        rule = [rule stringByAppendingFormat:@"BYMINUTE=%@;",[self.rrule_byminute componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_byhour){
        rule = [rule stringByAppendingFormat:@"BYHOUR=%@;",[self.rrule_byhour componentsJoinedByString:@","],nil];
    }*/
    
    if(self.rrule_byday && [self.rrule_byday count]>0){
        rule = [rule stringByAppendingFormat:@"BYDAY=%@;",[self.rrule_byday componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_bymonthday){
        rule = [rule stringByAppendingFormat:@"BYMONTHDAY=%@;",[self.rrule_bymonthday componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_byyearday){
        rule = [rule stringByAppendingFormat:@"BYYEARDAY=%@;",[self.rrule_byyearday componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_byweekno){
        rule = [rule stringByAppendingFormat:@"BYWEEKNO=%@;",[self.rrule_byweekno componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_bymonth){
        rule = [rule stringByAppendingFormat:@"BYMONTH=%@;",[self.rrule_bymonth componentsJoinedByString:@","],nil];
    }
    
    if(self.rrule_bysetpos){
        rule = [rule stringByAppendingFormat:@"BYSETPOS=%@;",[self.rrule_bysetpos componentsJoinedByString:@","],nil];
    }
    
    if(![self.rrule_wkst isEqualToString:@"MO"]){
        rule = [rule stringByAppendingFormat:@"WKST=%@;",self.rrule_wkst,nil];
    }
    
    return rule;
    
}

@end
