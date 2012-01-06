//
//  Created by Fabien Di Tore on 15.07.10.
//  Copyright 2010 Atipik Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AKDefaultEncodeKey @"abwabwa"
#define AKDefaultSeparator @"--///--"
@interface NSString (NSString_Atipik)
- (NSString *) md5;
// retourne le chemin ( basedir )
- (NSString *) pathComponent;
- (NSData*) base64Decode;
+ (NSData*) base64Decode:(NSString*) string ;
+ (NSData*) base64Decode:(const char*) string length:(NSInteger) inputLength ;
+ (void) initializeBase64;

+ (NSString*) urlencode: (NSString *) url;
+ (NSString*) urldecode: (NSString *) url;
+ (NSString*) randomStringWithLength: (int) len ;
- (NSString*) urlencode;
- (NSString*) urldecode;

- (NSString*) decodeHash: (NSString*) key;
- (NSString*) decodeHash: (NSString*) key withSeparator:(NSString*)separator;
- (NSString*) encodeHash: (NSString*) key withSeparator:(NSString*)separator;
- (NSString*) encodeHash: (NSString*) key;

- (NSString *)stringByDecodingXMLEntities ;
- (NSString *)stringByEncodingXMLEntities;
- (NSString *)stringByStrippingTags ;
- (NSString *)stringByDecodingTags;
- (NSString *)stringWithNewLinesAsBRs;
- (NSString *)stringByRemovingNewLinesAndWhitespace;
- (NSString *)ellipsisAt:(int) numChars withSuffix:(NSString*) suffix;
- (NSString *)toASCII;

- (NSString *)substringFromChar:(char) from toChar:(char) to;

+ (BOOL) isValidEmail:(NSString *)checkString;

- (NSString *) addSlashes;
- (NSInteger) toInt;
- (NSNumber*) toNumber;
+(NSString*) timeFormat:(CGFloat) interval;
+(NSString*) stringTimeFromDate:(NSDate*) date;

-(NSString*) ucFirst;
@end

@interface NSData (AKStringExtension)
- (NSString*) md5;
- (NSString*) base64Encode;
+ (NSString*) base64Encode:(NSData*) rawBytes ;
+ (NSString*) base64Encode:(const uint8_t*) input length:(NSInteger) length ;
+ (void) initializeBase64;

@end