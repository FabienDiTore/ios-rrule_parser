//
//  RruleParserTests.m
//  RruleParserTests
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import "RruleParserTests.h"
#import "Scheduler.h"
#import "NSCalendar+NSCalendar_Atipik.h"
@implementation RruleParserTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}




- (void) test1{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:15];
    [dc setHour:19];
    [dc setMinute:18];
    [dc setSecond:0];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    
    dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:12];
    [dc setDay:31];
    [dc setHour:9];
    [dc setMinute:0];
    [dc setSecond:0];
    
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;UNTIL=20111231T090000Z"];
    
    STAssertNotNil(d, @"date is nil");
    NSTimeInterval b = [d2 timeIntervalSince1970];
    STAssertTrue([s.rrule_freq isEqualToString:@"DAILY"], @"Failed to parse FREQ");
    STAssertTrue([s.rrule_until floatValue] == b , @"Failed to parse FREQ %f,%f",b,[s.rrule_until floatValue]);
    STAssertTrue(s.rrule_interval ==1,@"interval");
    STAssertTrue([s.rrule_bysecond containsObject:@"0"], @"");
    STAssertTrue([s.rrule_byminute containsObject:@"18"], @"");
    STAssertTrue([s.rrule_byhour containsObject:@"19"], @"");
    STAssertNil(s.rrule_byday, @"");
    STAssertNil(s.rrule_bymonthday, @"");
    STAssertNil(s.rrule_bymonth, @"");
    STAssertTrue([s.rrule_wkst isEqualToString:@"MO"], @"");
    
    
    STAssertFalse([s isComplex],@"");
    STAssertTrue([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==3,@"");
    STAssertTrue([r containsObject:@"FREQ=DAILY"],@"");
    STAssertTrue([r containsObject:@"UNTIL=20111231T090000Z"],@"");
    
    
    [s release];
}


- (void) test2{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:15];
    [dc setHour:19];
    [dc setMinute:18];
    [dc setSecond:0];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;COUNT=5"];
    
    STAssertNotNil(d, @"date is nil");
    STAssertTrue([s.rrule_freq isEqualToString:@"DAILY"], @"Failed to parse FREQ");
    STAssertTrue([s.rrule_count intValue] ==5,@"count: %d",[s.rrule_count intValue]);
    STAssertTrue(s.rrule_interval ==1,@"interval");
    STAssertTrue([s.rrule_bysecond containsObject:@"0"], @"");
    STAssertTrue([s.rrule_byminute containsObject:@"18"], @"");
    STAssertTrue([s.rrule_byhour containsObject:@"19"], @"");
    STAssertNil(s.rrule_byday, @"");
    STAssertNil(s.rrule_bymonthday, @"");
    STAssertNil(s.rrule_bymonth, @"");
    STAssertTrue([s.rrule_wkst isEqualToString:@"MO"], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
     STAssertTrue([r count]==3,@"");
    STAssertTrue([r containsObject:@"FREQ=DAILY"],@"");
    STAssertTrue([r containsObject:@"COUNT=5"],@"");
    [s release];
}


- (void) test3{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:15];
    [dc setHour:19];
    [dc setMinute:18];
    [dc setSecond:0];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;COUNT=5;INTERVAL=10"];
    
    STAssertNotNil(d, @"date is nil");
    STAssertTrue([s.rrule_freq isEqualToString:@"DAILY"], @"Failed to parse FREQ");
    STAssertTrue([s.rrule_count intValue] ==5,@"count: %d",[s.rrule_count intValue]);
    STAssertTrue(s.rrule_interval ==10,@"interval");
    
 
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==4,@"");
    STAssertTrue([r containsObject:@"FREQ=DAILY"],@"");
    STAssertTrue([r containsObject:@"INTERVAL=10"],@"");
    STAssertTrue([r containsObject:@"COUNT=5"],@"");
    [s release];
    
}

- (void) test4{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:15];
    [dc setHour:19];
    [dc setMinute:18];
    [dc setSecond:0];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;COUNT=5;BYDAY=MO,TU"];
    
    STAssertNotNil(d, @"date is nil");
    STAssertNotNil(d, @"date is nil");
    STAssertTrue([s.rrule_freq isEqualToString:@"WEEKLY"], @"Failed to parse FREQ");
    STAssertTrue([s.rrule_count intValue] ==5,@"count: %d",[s.rrule_count intValue]);
    
    STAssertTrue([s.rrule_bysecond containsObject:@"0"], @"");
    STAssertTrue([s.rrule_byminute containsObject:@"18"], @"");
    STAssertTrue([s.rrule_byhour containsObject:@"19"], @"");
    STAssertTrue([s.rrule_byday containsObject:@"MO"] && [s.rrule_byday containsObject:@"TU"], @"");
    STAssertNil(s.rrule_bymonthday, @"");
    STAssertNil(s.rrule_bymonth, @"");
    STAssertTrue([s.rrule_wkst isEqualToString:@"MO"], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

- (void) test5{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:14];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    
    dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:15];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:16];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:17];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:18];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d4 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc release];
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;COUNT=5"];
    NSArray * occurences = [s allOccurencesSince:nil until:nil];
    STAssertNotNil(d, @"date is nil");
    STAssertNotNil(occurences, @"date is nil");
    STAssertTrue([occurences count] > 0, @"date is nil");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertTrue([occurences containsObject:d3], @"");
    STAssertTrue([occurences containsObject:d4], @"");
    
    NSLog(@"%@",[occurences description]);
    
    Scheduler * s2 = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY"];
    occurences = [s2 allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertNil(occurences, @"");
    
}

- (void) test6{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:14];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:16];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:18];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    [dc setDay:17];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:18];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc release];
    
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;COUNT=5"];
    NSArray * occurences = [s occurencesBetween:start_at andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([occurences count]==2, @"too much results");
    STAssertTrue([occurences containsObject:d1], @"too much results");
    STAssertTrue([occurences containsObject:d2], @"too much results");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    //STAssertTrue([[s getRule] isEqualToString:@"RRULE:FREQ=DAILY;COUNT=5;"],@"");
    
    
}

-(void) test7{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:14];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;COUNT=200"];
    NSArray * occurences = [s allOccurencesSince:nil until:nil];
    STAssertTrue([occurences count]==200, @"");
    
   
    
    
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    
    NSDate * exception = [[NSCalendar currentCalendar] dateFromYear:2011 month:10 day:16 hour:20 minute:05];
    
    
    [s addExceptionDates:[NSArray arrayWithObject:exception]];
    occurences = [s allOccurencesSince:nil until:nil];
    STAssertFalse([occurences containsObject:exception],@"");
    //STAssertTrue([[s getRule] isEqualToString:@"RRULE:FREQ=DAILY;COUNT=200;"],@"");
    
}


-(void) test8{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:29];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:30];
    [dc setMonth:10];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:1];
    [dc setMonth:11];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:2];
    [dc setMonth:12];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;UNTIL=20111202T000000Z"];
    NSArray * occurences = [s allOccurencesSince:nil until:nil];
    STAssertTrue([occurences containsObject:d], @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertFalse([occurences containsObject:d3], @"");
    
}

-(void) test9{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:14];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:18];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:20];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:22];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:24];
    NSDate * d4 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:26];
    NSDate * d5 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:25];
    NSDate * d6 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:17];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:26];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;INTERVAL=2"];
    NSArray * occurences = [s occurencesBetween:start_at andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertTrue([occurences containsObject:d3], @"");
    STAssertTrue([occurences containsObject:d4], @"");
    STAssertTrue([occurences containsObject:d5], @"");
    STAssertFalse([occurences containsObject:d6], @"");
    
    //test
    
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==3,@"");
    STAssertTrue([r containsObject:@"FREQ=DAILY"],@"");
    STAssertTrue([r containsObject:@"INTERVAL=2"],@"");
}

-(void) test10{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:10];
    [dc setDay:14];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:24];
    
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:3];
    [dc setMonth:11];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:13];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:23];
    NSDate * d4 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;INTERVAL=10;COUNT=5"];
    NSArray * occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([occurences count] == 5, @"");
    STAssertTrue([occurences containsObject:d], @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertTrue([occurences containsObject:d3], @"");
    STAssertTrue([occurences containsObject:d4], @"");
    
}

-(void) test11
{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:1];
    [dc setDay:1];
    [dc setHour:20];
    [dc setMinute:05];
    [dc setSecond:12];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:24];
    [dc setYear:2012];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:3];
    
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:13];
    
    [dc setYear:2013];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:23];
    
    NSDate * d4 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    Scheduler * s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY;UNTIL=20130131T090000Z;BYMONTH=1"];
    NSArray * occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([occurences count] < 94, @""); 
    STAssertTrue([occurences containsObject:d], @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertTrue([occurences containsObject:d3], @"");
    STAssertTrue([occurences containsObject:d4], @"");
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==4,@"");
    STAssertTrue([r containsObject:@"FREQ=DAILY"],@"");
    STAssertTrue([r containsObject:@"UNTIL=20130131T090000Z"],@"");
    STAssertTrue([r containsObject:@"BYMONTH=1"],@"");
    
    //[s release];
    s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=YEARLY;UNTIL=20130131T090000Z;BYMONTH=1;BYDAY=SU,MO,TU,WE,TH,FR,SA"];
    occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([occurences count] < 94, @""); 
    STAssertTrue([occurences containsObject:d], @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertTrue([occurences containsObject:d3], @"");
    STAssertTrue([occurences containsObject:d4], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
   
    //STAssertTrue([[s getRule] isEqualToString:@"RRULE:FREQ=YEARLY;UNTIL=20130131T090000Z;BYMONTH=1;BYDAY=SU,MO,TU,WE,TH,FR,SA;"],@"");
    
    //test
    NSArray * r2 = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r2 description]);
    STAssertTrue([r2 count]==5,@"");
    STAssertTrue([r2 containsObject:@"FREQ=YEARLY"],@"");
    STAssertTrue([r2 containsObject:@"UNTIL=20130131T090000Z"],@"");
    STAssertTrue([r2 containsObject:@"BYMONTH=1"],@"");
    STAssertTrue([r2 containsObject:@"BYDAY=SU,MO,TU,WE,TH,FR,SA"],@"");
}

-(void) test12{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:1997];
    [dc setMonth:8];
    [dc setDay:2];
    [dc setHour:9];
    [dc setMinute:0];
    [dc setSecond:0];
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:11];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:9];
    [dc setDay:1];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:8];
    [dc setDay:16];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:8];
    [dc setDay:23];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:8];
    [dc setDay:30];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;COUNT=10"];
    NSArray *occurences = [s occurencesBetween:start_at  andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([[s allOccurencesSince:nil until:nil] count]==10, @"");
    STAssertTrue([occurences count]==3, @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    STAssertTrue([occurences containsObject:d3], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");

    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==4,@"");
    STAssertTrue([r containsObject:@"FREQ=WEEKLY"],@"");
    STAssertTrue([r containsObject:@"COUNT=10"],@"");
    STAssertTrue([r containsObject:@"BYDAY=SA"],@"");
    
}

-(void) test13{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:12];
    [dc setDay:5];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:1];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:1];
    [dc setDay:1];
    [dc setYear:2012];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:6];
    [dc setYear:2011];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:13];
    [dc setYear:2011];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"FREQ=WEEKLY;INTERVAL=1;BYDAY=TU;COUNT=2"];
    NSArray *occurences = [s occurencesBetween:start_at  andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([occurences count]==2, @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

-(void) test14{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:12];
    [dc setDay:8];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setDay:1];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:1];
    [dc setDay:1];
    [dc setYear:2012];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:13];
    [dc setYear:2011];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:20];
    [dc setYear:2011];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:27];
    [dc setYear:2011];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"FREQ=WEEKLY;INTERVAL=1;BYDAY=TU;UNTIL=20111231"];
    NSArray *occurences = [s occurencesBetween:start_at  andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([occurences count]==3, @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    
    STAssertTrue([occurences containsObject:d3], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

-(void) test15{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:11];
    [dc setDay:14];
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:1];
    [dc setDay:1];
    [dc setYear:1950];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:1];
    [dc setDay:1];
    [dc setYear:2050];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:11];
    [dc setDay:14];
    [dc setYear:2011];
    NSDate * d1 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:11];
    [dc setDay:21];
    [dc setYear:2011];
    NSDate * d2 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:11];
    [dc setDay:28];
    [dc setYear:2011];
    NSDate * d3 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:5];
    [dc setYear:2011];
    NSDate * d4 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:12];
    [dc setYear:2011];
    NSDate * d5 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    [dc setMonth:12];
    [dc setDay:19];
    [dc setYear:2011];
    NSDate * d6 = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;UNTIL=20111224T000000Z"];
    NSArray *occurences = [s occurencesBetween:start_at  andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([occurences count]==6, @"");
    STAssertTrue([occurences containsObject:d1], @"");
    STAssertTrue([occurences containsObject:d2], @"");
    
    STAssertTrue([occurences containsObject:d3], @"");
    STAssertTrue([occurences containsObject:d4], @"");
    STAssertTrue([occurences containsObject:d5], @"");
    STAssertTrue([occurences containsObject:d6], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@""); 
}
-(void) test16{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;UNTIL=19971007T000000Z;WKST=SU;BYDAY=TU,TH"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([occurences count]==10, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:4 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:9 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:11 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:16 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:18 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:23 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:25 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:30 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:2 hour:8 minute:0]], @"");
    
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==5,@"");
    STAssertTrue([r containsObject:@"FREQ=WEEKLY"],@"");
    //STAssertTrue([r containsObject:@"UNTIL=19971007T000000Z"],@"");
    STAssertTrue([r containsObject:@"WKST=SU"],@"");
    STAssertTrue([r containsObject:@"BYDAY=TU,TH"],@"");
}

-(void) test17{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;COUNT=10;WKST=SU;BYDAY=TU,TH"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([occurences count]==10, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:4 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:9 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:11 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:16 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:18 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:23 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:25 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:30 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:2 hour:8 minute:0]], @"");
    
}

-(void) test18{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;INTERVAL=2;UNTIL=19971224T000000Z;WKST=SU;BYDAY=MO,WE,FR"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    STAssertTrue([occurences count]==24, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:3 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:5 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:15 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:17 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:19 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:29 hour:8 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:1 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:3 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:13 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:15 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:17 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:29 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:31 hour:8 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:10 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:12 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:14 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:24 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:26 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:28 hour:8 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:8 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:10 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:12 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:22 hour:8 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");    
}

-(void) test19{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;COUNT=3;BYDAY=1FR"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==3, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:5 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:3 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:7 hour:8 minute:0]], @"");
    
    
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:8 hour:8 minute:0];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:31 hour:8 minute:0];
    occurences = [s occurencesBetween:start_at andDate:end_at];
    
    
    STAssertTrue([occurences count]==0, @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

-(void) test20{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:5 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;UNTIL=19971224T000000Z;BYDAY=1FR"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==4, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:5 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:3 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:7 hour:8 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:5 hour:8 minute:0]], @"");
    
    
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:6 hour:8 minute:0];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:31 hour:8 minute:0];
    occurences = [s occurencesBetween:start_at andDate:end_at];
    
    
    STAssertTrue([occurences count]==0, @"");
}
-(void) test21{
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:7 hour:9 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;INTERVAL=2;COUNT=5;BYDAY=1SU,-1SU"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==5, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:7 hour:9 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:28 hour:9 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:2 hour:9 minute:0]], @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:30 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:4 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");

    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==5,@"");
    STAssertTrue([r containsObject:@"FREQ=MONTHLY"],@"");
    STAssertTrue([r containsObject:@"INTERVAL=2"],@"");
    STAssertTrue([r containsObject:@"COUNT=5"],@"");
    STAssertTrue([r containsObject:@"BYDAY=1SU,-1SU"],@"");
}

-(void) test22{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:7 hour:9 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;COUNT=6;BYDAY=-2MO"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==6, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:22 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:20 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:17 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:22 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:19 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:2 day:16 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==4,@"");
    STAssertTrue([r containsObject:@"FREQ=MONTHLY"],@"");
    STAssertTrue([r containsObject:@"COUNT=6"],@"");
    STAssertTrue([r containsObject:@"BYDAY=-2MO"],@"");
}

-(void) test23{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:28 hour:9 minute:0];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:27 hour:9 minute:0];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromYear:1998 month:3 day:28 hour:8 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;BYMONTHDAY=-3"];
    NSArray *occurences = [s occurencesBetween:start_at andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==6, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:28 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:29 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:28 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:29 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:29 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:2 day:26 hour:9 minute:0]], @"");
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==3,@"");
    STAssertTrue([r containsObject:@"FREQ=MONTHLY"],@"");
    STAssertTrue([r containsObject:@"BYMONTHDAY=-3"],@"");
}

-(void) test24{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:9 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;COUNT=6;BYMONTHDAY=2,15"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==6, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:15 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:2 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:15 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:2 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:15 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    STAssertTrue([r count]==4,@"");
    STAssertTrue([r containsObject:@"FREQ=MONTHLY"],@"");
    STAssertTrue([r containsObject:@"COUNT=6"],@"");
    STAssertTrue([r containsObject:@"BYMONTHDAY=2,15"],@"");
}

-(void) test26{
    
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:30 hour:9 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;COUNT=10;BYMONTHDAY=1,-1"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==10, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:30 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:10 day:31 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:30 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:12 day:31 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:31 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:2 day:1 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

-(void) test27 {
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:10 hour:9 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;INTERVAL=18;COUNT=10;BYMONTHDAY=10,11,12,13,14,15"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==10, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:10 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:11 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:12 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:13 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:14 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:15 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1999 month:3 day:10 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1999 month:3 day:11 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1999 month:3 day:12 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1999 month:3 day:13 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

-(void) test28 {
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:9 minute:0];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:18 hour:9 minute:0];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:18 hour:8 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;INTERVAL=2;BYDAY=TU"];
    NSArray *occurences = [s occurencesBetween:start_at andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==4, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:18 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:11 day:25 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:6 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:1 day:13 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}

-(void) test28_more {
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:2011 month:1 day:1 hour:9 minute:0];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromYear:2011 month:1 day:1 hour:9 minute:0];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromYear:2014 month:1 day:1 hour:9 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=YEARLY;INTERVAL=1"];
    NSArray *occurences = [s occurencesBetween:start_at andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==4, @"");
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:2011 month:1 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:2012 month:1 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:2013 month:1 day:1 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:2014 month:1 day:1 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");
}


-(void) test29{

    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:8 day:2 hour:9 minute:0];
    NSDate * exception = [[NSCalendar currentCalendar] dateFromYear:1998 month:8 day:2 hour:9 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;UNTIL=19991231T090000Z;BYDAY=FR;BYMONTHDAY=13"];
    [s addExceptionDates:[NSArray arrayWithObject:exception]];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    STAssertTrue([occurences count]==4, @"");
    STAssertFalse([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:2 day:13 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:3 day:13 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1998 month:11 day:13 hour:9 minute:0]], @"");
    
    STAssertTrue([occurences containsObject:[[NSCalendar currentCalendar] dateFromYear:1999 month:8 day:13 hour:9 minute:0]], @"");
    
    NSLog(@"%@",[s getRule]);
    STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
    STAssertFalse([s isYearly],@"");

    
}
/*
 
 
 console.log("--- Yearly in June and July for 10 occurrences ---");
 d = new Date(1997, 5, 10, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;COUNT=10;BYMONTH=6,7", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 10);
 console.assert(occurrences.in_array(new Date(1997, 5, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 6, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1998, 5, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1998, 6, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 5, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 6, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2000, 5, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2000, 6, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2001, 5, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2001, 6, 10, 9).getTime()));
 //		==>	(1997 9:00 AM EDT)June 10;July 10
 //			(1998 9:00 AM EDT)June 10;July 10
 //		     (1999 9:00 AM EDT)June 10;July 10
 //			(2000 9:00 AM EDT)June 10;July 10
 //			(2001 9:00 AM EDT)June 10;July 10
 //
 //  		Note: Since none of the BYDAY, BYMONTHDAY or BYYEARDAY components are specified, the day is gotten from DTSTART
 
 
 
 console.log("--- Every other year on January, February, and March for 10 occurrences ---");
 d = new Date(1997, 2, 10, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;INTERVAL=2;COUNT=10;BYMONTH=1,2,3", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 10);
 console.assert(occurrences.in_array(new Date(1997, 2, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 0, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 1, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 2, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2001, 0, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2001, 1, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2001, 2, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2003, 0, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2003, 1, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2003, 2, 10, 9).getTime()));
 //	==>	(1997 9:00 AM EST)March 10
 //		(1999 9:00 AM EST)January 10;February 10;March 10
 //		(2001 9:00 AM EST)January 10;February 10;March 10
 //		(2003 9:00 AM EST)January 10;February 10;March 10
 
 // occurrence after 10 march 2003 shouldn't exist
 start_at = new Date(2003, 2, 11);
 end_at = new Date(2010, 0, 1);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 0);
 
 
 
 console.log("--- Every 3rd year on the 1st, 100th and 200th day for 10 occurrences ---");
 d = new Date(1997, 0, 1, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;INTERVAL=3;COUNT=10;BYYEARDAY=1,100,200", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 10);
 console.assert(occurrences.in_array(new Date(1997, 0, 1, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 3, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 6, 19, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2000, 0, 1, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2000, 3, 9, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2000, 6, 18, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2003, 0, 1, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2003, 3, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2003, 6, 19, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2006, 0, 1, 9).getTime()));
 //		==>	(1997 9:00 AM EST)January 1
 //		     (1997 9:00 AM EDT)April 10;July 19
 //			(2000 9:00 AM EST)January 1
 //			(2000 9:00 AM EDT)April 9;July 18
 //			(2003 9:00 AM EST)January 1
 //			(2003 9:00 AM EDT)April 10;July 19
 //			(2006 9:00 AM EST)January 1
 
 
 
 console.log("--- Every 20th Monday of the year, forever ---");
 d = new Date(1997, 4, 19, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;BYDAY=20MO", true);
 start_at = new Date(1997, 4, 1);
 end_at = new Date(1997, 4, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 1);
 console.assert(occurrences.in_array(new Date(1997, 4, 19, 9).getTime()));
 
 
 start_at = new Date(1999, 4, 1);
 end_at = new Date(1999, 4, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 1);
 console.assert(occurrences.in_array(new Date(1999, 4, 17, 9).getTime()));
 //	==> 	(1997 9:00 AM EDT)May 19
 //      	(1998 9:00 AM EDT)May 18
 //      	(1999 9:00 AM EDT)May 17
 //		...
 
 
 
 console.log("--- Monday of week number 20 (where the default start of the week is Monday), forever ---");
 d = new Date(1997, 4, 12, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;BYWEEKNO=20;BYDAY=MO", true);
 start_at = new Date(1997, 4, 1);
 end_at = new Date(1997, 4, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 1);
 console.assert(occurrences.in_array(new Date(1997, 4, 12, 9).getTime()));
 
 
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;BYWEEKNO=20;BYDAY=MO", true);
 start_at = new Date(1999, 4, 1);
 end_at = new Date(1999, 4, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 1);
 console.assert(occurrences.in_array(new Date(1999, 4, 17, 9).getTime()));
 //		==>	(1997 9:00 AM EDT)May 12
 //		     (1998 9:00 AM EDT)May 11
 //		     (1999 9:00 AM EDT)May 17
 //			...
 
 
 
 console.log("--- Every Thursday in March, forever ---");
 d = new Date(1997, 2, 13, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=TH", true);
 start_at = new Date(1997, 2, 1);
 end_at = new Date(1997, 2, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 3);
 console.assert(occurrences.in_array(new Date(1997, 2, 13, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 2, 20, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 2, 27, 9).getTime()));
 
 
 start_at = new Date(1999, 2, 1);
 end_at = new Date(1999, 2, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 4);
 console.assert(occurrences.in_array(new Date(1999, 2, 4, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 2, 11, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 2, 18, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 2, 25, 9).getTime()));
 //		==>	(1997 9:00 AM EST)March 13,20,27
 //		     (1998 9:00 AM EST)March 5,12,19,26
 //		     (1999 9:00 AM EST)March 4,11,18,25
 //			...
 
 
 
 console.log("--- Every Thursday, but only during June, July, and August, forever ---");
 d = new Date(1997, 5, 5, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;BYDAY=TH;BYMONTH=6,7,8", true);
 start_at = new Date(1997, 5, 15);
 end_at = new Date(1997, 6, 15);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 4);
 console.assert(occurrences.in_array(new Date(1997, 5, 19, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 5, 26, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 6, 3, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 6, 10, 9).getTime()));
 
 
 start_at = new Date(1999, 5, 15);
 end_at = new Date(1999, 6, 15);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 4);
 console.assert(occurrences.in_array(new Date(1999, 5, 17, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 5, 24, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 6, 1, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 6, 8, 9).getTime()));
 //		==>	(1997 9:00 AM EDT)June 5,12,19,26;July 3,10,17,24,31;August 7,14,21,28
 //		     (1998 9:00 AM EDT)June 4,11,18,25;July 2,9,16,23,30;August 6,13,20,27
 //			(1999 9:00 AM EDT)June 3,10,17,24;July 1,8,15,22,29;August 5,12,19,26
 //			...
 // ...modified...
 
 
 
 console.log("--- Every Friday the 13th, forever (occurrences between) ---");
 d = new Date(1997, 8, 2, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13", true);
 start_at = new Date(1997, 8, 15);
 end_at = new Date(1999, 11, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 4);
 console.assert(occurrences.in_array(new Date(1998, 1, 13, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1998, 2, 13, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1998, 10, 13, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1999, 7, 13, 9).getTime()));
 //		==>	(1998 9:00 AM EST)February 13;March 13;November 13
 //			(1999 9:00 AM EDT)August 13
 //			(2000 9:00 AM EDT)October 13
 //			...
 // ...modified...
 

 
 console.log("--- Every four years, the first Tuesday after a Monday in November, forever (U.S. Presidential Election day) ---")
 d = new Date(1996, 10, 5, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=YEARLY;INTERVAL=4;BYMONTH=11;BYDAY=TU;BYMONTHDAY=2,3,4,5,6,7,8", true);
 start_at = new Date(1996, 0, 1);
 end_at = new Date(2004, 11, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 3);
 console.assert(occurrences.in_array(new Date(1996, 10, 5, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2000, 10, 7, 9).getTime()));
 console.assert(occurrences.in_array(new Date(2004, 10, 2, 9).getTime()));
 
 //		==> 	(1996 9:00 AM EST)November 5
 //			(2000 9:00 AM EST)November 7
 //			(2004 9:00 AM EST)November 2
 
 
 console.log("--- The 3rd instance into the month of one of Tuesday, Wednesday or Thursday, for the next 3 months ---");
 d = new Date(1997, 8, 4, 9);
 
 scheduler = new Scheduler(d, "RRULE:FREQ=MONTHLY;COUNT=3;BYDAY=TU,WE,TH;BYSETPOS=3", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 3);
 console.assert(occurrences.in_array(new Date(1997, 8, 4, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 9, 7, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 10, 6, 9).getTime()));
 // 		==>	(1997 9:00 AM EDT)September 4;October 7;November 6
 
 
 
 console.log("--- The 2nd to last weekday of the month ---");
 d = new Date(1997, 8, 29, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-2", true);
 start_at = new Date(1996, 0, 1);
 end_at = new Date(1998, 1, 1);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.length == 5);
 console.assert(occurrences.in_array(new Date(1997, 8, 29, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 9, 30, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 10, 27, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 11, 30, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1998, 0, 29, 9).getTime()));
 //		==>	(1997 9:00 AM EDT)September 29
 //			(1997 9:00 AM EST)October 30;November 27;December 30
 //			(1998 9:00 AM EST)January 29;February 26;March 30
 //			 ...
 
 
 
 console.log("--- Every 20 minutes from 9:00 AM to 4:40 PM every day ---");
 d = new Date(1997, 8, 2, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;BYHOUR=9,10,11,12,13,14,15,16;BYMINUTE=0,20,40", true);
 start_at = new Date(1996, 0, 1);
 end_at = new Date(2004, 11, 31);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.in_array(new Date(1997, 8, 2, 9, 0).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 2, 9, 20).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 2, 9, 40).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 2, 10, 0).getTime()));
 // ...
 console.assert(occurrences.in_array(new Date(1997, 8, 2, 16, 20).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 2, 16, 40).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 9, 0).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 9, 20).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 9, 40).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 10, 0).getTime()));
 // ...
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 16, 0).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 16, 20).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 8, 3, 16, 40).getTime()));
 //  ==> (September 2, 1997 EDT)9:00,9:20,9:40,10:00,10:20,
 //                             ... 16:00,16:20,16:40
 //      (September 3, 1997 EDT)9:00,9:20,9:40,10:00,10:20,
 //                            ...16:00,16:20,16:40
 
 
 console.log("--- An example where the days generated makes a difference because of WKST ---");
 d = new Date(1997, 7, 5, 9);
 scheduler = new Scheduler(d, "RRULE:FREQ=WEEKLY;INTERVAL=2;COUNT=4;BYDAY=TU,SU;WKST=MO", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 4);
 console.assert(occurrences.in_array(new Date(1997, 7, 5, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 7, 10, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 7, 19, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 7, 24, 9).getTime()));
 //              ==> (1997 EDT)Aug 5,10,19,24
 
 
 
 scheduler = new Scheduler(d, "RRULE:FREQ=WEEKLY;INTERVAL=2;COUNT=4;BYDAY=TU,SU;WKST=SU", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 4);
 console.assert(occurrences.in_array(new Date(1997, 7, 5, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 7, 17, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 7, 19, 9).getTime()));
 console.assert(occurrences.in_array(new Date(1997, 7, 31, 9).getTime()));
 //              ==> (1997 EDT)August 5,17,19,31*/
@end
