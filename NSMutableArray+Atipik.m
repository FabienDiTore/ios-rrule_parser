//
//  NSMutableArray+Atipik.m
//  heure.ipadapp
//
//  Created by Fabien Di Tore on 27.01.11.
//  Copyright 2011 Atipik Sarl. All rights reserved.
//

#import "NSMutableArray+Atipik.h"



@implementation NSMutableArray (Atipik)
-(id) popObject // return and remove the last object
{
	if ([self count]>0) {
		id obj = [self lastObject];
		[self removeLastObject];
		return obj;
	}
	return nil;
}
-(id) shiftObject // return and remove the first object. 
{
	if ([self count]>0) {
		id obj = [[[self objectAtIndex:0] retain] autorelease];
		[self removeObjectAtIndex:0];
		return obj;
	}
	return nil;
}


@end
