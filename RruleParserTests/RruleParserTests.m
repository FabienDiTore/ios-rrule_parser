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
/*
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
    STAssertFalse([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertTrue([s isWeekly],@"");
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

-(void) test16bis{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=WEEKLY;UNTIL=19971007T000000Z;"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");

    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
  //  STAssertTrue([r count]==5,@"");
    STAssertTrue([r containsObject:@"FREQ=WEEKLY"],@"");
    STAssertTrue([s isWeekly],@"");
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

-(void) test19bis{
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:1997 month:9 day:2 hour:8 minute:0];
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=MONTHLY;COUNT=3"];
    NSArray *occurences = [s allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    //  STAssertTrue([r count]==5,@"");
    STAssertTrue([r containsObject:@"FREQ=MONTHLY"],@"");
   // STAssertTrue([s isMonthly],@"");
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

-(void) test28bis {
    NSDate * d = [[NSCalendar currentCalendar] dateFromYear:2011 month:1 day:1 hour:9 minute:0];
    NSDate * start_at = [[NSCalendar currentCalendar] dateFromYear:2011 month:1 day:1 hour:9 minute:0];
    NSDate * end_at = [[NSCalendar currentCalendar] dateFromYear:2014 month:1 day:1 hour:9 minute:0];
    
    Scheduler *s = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=YEARLY;INTERVAL=1"];
    NSArray *occurences = [s occurencesBetween:start_at andDate:end_at];
    NSLog(@"%@",[occurences description]);
    STAssertTrue([s checkRule:d], @"");
    
    //test
    NSArray * r = [[s getRule] componentsSeparatedByString:@";"];
    NSLog(@"%@",[r description]);
    //  STAssertTrue([r count]==5,@"");
    STAssertTrue([r containsObject:@"FREQ=YEARLY"],@"");
    STAssertTrue([s isYearly],@"");
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
  //  STAssertTrue([s isComplex],@"");
    STAssertFalse([s isDaily],@"");
    STAssertFalse([s isWeekly],@"");
    STAssertFalse([s isBiWeekly],@"");
    STAssertFalse([s isMonthly],@"");
  //  STAssertFalse([s isYearly],@"");
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

    
}*/
@end
