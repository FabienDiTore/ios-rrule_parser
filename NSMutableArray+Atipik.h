//
//  NSMutableArray+Atipik.h
//  heure.ipadapp
//
//  Created by Fabien Di Tore on 27.01.11.
//  Copyright 2011 Atipik Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Atipik) 

-(id) popObject; // return and remove the last object
-(id) shiftObject; // return and remove the first object

@end
