//
//  Scheduler.m
//  RruleParser
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import "Scheduler.h"

@implementation Scheduler

-(id) initWithDate:(NSDate*)date andRule:(NSString*) rrule{
    if (self = [super init]) {
        _rrule_wkst =   @"MO";
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
            NSNumberFormatter * nf = [[NSNumberFormatter alloc]init];
            
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
            [nf release];
           
        }
    }
  /*  
    
    for (var i = 0; i < nb_rules; i++) {
        var rule = rules[i].split("=");
        var rule_value = rule[1];
        switch (rule[0]) { // rule name
            case "FREQ":
                this.rrule_freq = rule_value;
                break;
            case "UNTIL":
                var until = rule_value;
                var y = until.substr(0, 4);
                var m = until.substr(4, 2) - 1; // js Date month -> 0 to 11
                var d = until.substr(6, 2);
                if (until.length > 8) {
                    var h = until.substr(9, 2);
                    var min = until.substr(11, 2);
                    var s = until.substr(13, 2);
                    this.rrule_until = new Date(y, m, d, h, min, s).getTime();
                } else {
                    this.rrule_until = new Date(y, m, d).getTime();
                }
                
                break;
            case "COUNT":
                this.rrule_count = rule_value;
                break;
            case "INTERVAL":
                this.rrule_interval = rule_value;
                break;
            case "BYSECOND":
                this.rrule_bysecond = rule_value.split(",");
                break;
            case "BYMINUTE":
                this.rrule_byminute = rule_value.split(",");
                break;
            case "BYHOUR":
                this.rrule_byhour = rule_value.split(",");
                break;
            case "BYDAY":
                this.rrule_byday = rule_value.split(",");
                break;
            case "BYMONTHDAY":
                if (this.rrule_freq != "WEEKLY") {
                    this.rrule_bymonthday = rule_value.split(",");
                }
                break;
            case "BYYEARDAY":
                if (this.rrule_freq == "YEARLY") {
                    this.rrule_byyearday = rule_value.split(",");
                }
                break;
            case "BYWEEKNO":
                if (this.rrule_freq == "YEARLY") {
                    this.rrule_byweekno = rule_value.split(",");
                }
                break;
            case "BYMONTH":
                this.rrule_bymonth = rule_value.split(",");
                break;
            case "BYSETPOS":
                this.rrule_bysetpos = rule_value.split(",");
                this.rrule_bysetpos.sort(function(a,b) {
                    return parseInt(a, 10) - parseInt(b, 10);
                });
                break;
            case "WKST":
                this.rrule_wkst = rule_value;
                break;
        }
    }
    
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
