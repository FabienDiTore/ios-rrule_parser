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
    
    Scheduler * s2 = [[Scheduler alloc] initWithDate:d andRule:@"RRULE:FREQ=DAILY"];
    occurences = [s2 allOccurencesSince:nil until:nil];
    NSLog(@"%@",[occurences description]);
    STAssertNil(occurences, @"");
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
    /*console.log("--- Daily for 5 occurrences, but get only 2 days ---");
     d = new Date(2011, 10, 14, 20, 05, 12);
     scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;COUNT=5", true);
     start_at = new Date(2011, 10, 16);
     end_at = new Date(2011, 10, 18);
     occurrences = scheduler.occurrences_between(start_at, end_at);
     console.assert(occurrences.length == 2);
     console.assert(occurrences.in_array(new Date(2011, 10, 16, 20, 05, 12).getTime()));
     console.assert(occurrences.in_array(new Date(2011, 10, 17, 20, 05, 12).getTime()));
     
     start_at = new Date(2012, 10, 16);
     end_at = new Date(2012, 10, 18);
     occurrences = scheduler.occurrences_between(start_at, end_at);
     console.assert(occurrences.length == 0);
     
     //		==> 	"Mon Nov 14 2011 20:05:12 GMT+0100 (CET)",
     //			"Tue Nov 15 2011 20:05:12 GMT+0100 (CET)",
     //			…,
     //			"Wed Nov 18 2011 20:05:12 GMT+0100 (CET)"
*/
    
    

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
   /* console.log("--- Daily for 200 occurrences ---");
    d = new Date(2011, 10, 14, 20, 05, 12)
    scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;COUNT=200", true);
    console.assert(scheduler.all_occurrences().length == 200);
*/
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
    /* 
     console.log("--- Daily until 2 december ---");
     d = new Date(2011, 10, 29, 20, 05, 12);
     scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;UNTIL=20111202T000000Z", true);
     occurrences = scheduler.all_occurrences();
     console.assert(occurrences.in_array(d.getTime()));
     console.assert(occurrences.in_array(new Date(2011, 10, 30, 20, 05, 12).getTime()));
     console.assert(occurrences.in_array(new Date(2011, 11, 1, 20, 05, 12).getTime()));
     //		==> 	"Mon Nov 29 2011 20:05:12 GMT+0100 (CET)",
     //			"Tue Nov 30 2011 20:05:12 GMT+0100 (CET)",
     //			"Wed Dec 01 2011 20:05:12 GMT+0100 (CET)"

     */
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
/*
 console.log("--- Every other day - forever ---");
 d = new Date(2011, 10, 14, 20, 05, 12);
 start_at = new Date(2011, 10, 17, 20, 05, 12)
 end_at = new Date(2011, 10, 26, 20, 05, 12);
 scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;INTERVAL=2", true);
 console.assert(scheduler.all_occurrences() == null);
 occurrences = scheduler.occurrences_between(start_at, end_at);
 console.assert(occurrences.in_array(new Date(2011, 10, 18, 20, 05, 12).getTime()));
 console.assert(occurrences.in_array(new Date(2011, 10, 20, 20, 05, 12).getTime()));
 console.assert(occurrences.in_array(new Date(2011, 10, 22, 20, 05, 12).getTime()));
 console.assert(occurrences.in_array(new Date(2011, 10, 24, 20, 05, 12).getTime()));
 console.assert(occurrences.in_array(new Date(2011, 10, 26, 20, 05, 12).getTime()));
 //		==> 	"Nov 18 2011 20:05:12 GMT+0100 (CET)",
 //			"Nov 20 2011 20:05:12 GMT+0100 (CET)",
 //			"Nov 22 2011 20:05:12 GMT+0100 (CET)"
 //			"Nov 24 2011 20:05:12 GMT+0100 (CET)"
 //			"Nov 26 2011 20:05:12 GMT+0100 (CET)"
 

 */

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
/*
 console.log("--- Every 10 days, 5 occurrences ---");
 d = new Date(2011, 10, 14, 20, 05, 12);
 scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;INTERVAL=10;COUNT=5", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences.length == 5);
 console.assert(occurrences[0] == new Date(2011, 10, 14, 20, 05, 12).getTime());
 console.assert(occurrences[1] == new Date(2011, 10, 24, 20, 05, 12).getTime());
 console.assert(occurrences[2] == new Date(2011, 11, 4, 20, 05, 12).getTime());
 console.assert(occurrences[3] == new Date(2011, 11, 14, 20, 05, 12).getTime());
 console.assert(occurrences[4] == new Date(2011, 11, 24, 20, 05, 12).getTime());
 //		==> 	"Nov 14 2011 20:05:12 GMT+0100 (CET)",
 //                      ...,
 //			"Dec 24 2011 20:05:12 GMT+0100 (CET)"
 // ...modification...
 
 

 
 */
}

-(void) test11
{
    NSDateComponents * dc = [[NSDateComponents alloc] init];
    [dc setYear:2011];
    [dc setMonth:1];
    [dc setDay:14];
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
/*
 console.log("--- Everyday in January, for 2 years ---");
 d = new Date(2011, 0, 1, 9, 0, 0);
 scheduler = new Scheduler(d, "RRULE:FREQ=DAILY;UNTIL=20130131T090000Z;BYMONTH=1", true);
 occurrences = scheduler.all_occurrences();
 console.assert(occurrences[0] == new Date(2011, 0, 1, 9, 0, 0).getTime());
 console.assert(occurrences[31] == new Date(2012, 0, 1, 9, 0, 0).getTime());
 console.assert(occurrences[62] == new Date(2013, 0, 1, 9, 0, 0).getTime());
 */
}
@end
