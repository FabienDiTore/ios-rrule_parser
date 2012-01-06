//  Created by Fabien DiTore on 22.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Atipik.h"


@implementation NSArray (Atipik)
- (NSArray*) reverse
{
    return [NSArray reverse:self];
}

+ (NSArray*)reverse: (NSArray*) array
{
    NSMutableArray * _a =  [[NSMutableArray alloc] initWithArray:array];
	if([_a count]> 0){
		NSUInteger i = 0;
		NSUInteger j = [_a count] - 1;
		while (i < j) {
			[_a exchangeObjectAtIndex:i
					   withObjectAtIndex:j];
			
			i++;
			j--;
		}
	}
    
    NSArray * result = [NSArray arrayWithArray:_a];
    [_a release];
    return result;
}

@end
