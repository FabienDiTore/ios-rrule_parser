//
//  RruleParserTests.m
//  RruleParserTests
//
//  Created by Fabien Di Tore on 03.01.12.
//  Copyright (c) 2012 Atipik Sarl. All rights reserved.
//

#import "RruleParserTests.h"
#import "Scheduler.h"
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
    /*
     console.log("--- Daily for 5 occurrences ---");
     d = new Date(2011, 10, 14, 20, 05, 12);
     scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;COUNT=5", true);
     var occurrences = scheduler.all_occurrences();
     console.assert(occurrences.length == 5);
     console.assert(occurrences.in_array(d.getTime()));
     console.assert(occurrences.in_array(new Date(2011, 10, 15, 20, 05, 12).getTime()));
     console.assert(occurrences.in_array(new Date(2011, 10, 16, 20, 05, 12).getTime()));
     console.assert(occurrences.in_array(new Date(2011, 10, 17, 20, 05, 12).getTime()));
     console.assert(occurrences.in_array(new Date(2011, 10, 18, 20, 05, 12).getTime()));
     //		==> 	"Mon Nov 14 2011 20:05:12 GMT+0100 (CET)",
     //			"Tue Nov 15 2011 20:05:12 GMT+0100 (CET)",
     //			…,
     //			"Wed Nov 18 2011 20:05:12 GMT+0100 (CET)"
     

     */
}
@end
