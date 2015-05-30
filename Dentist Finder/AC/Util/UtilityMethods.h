//
//  UtilityMethods.h
//  Giftolyo
//
//  Created by Arda CICEK on 15/12/14.
//  Copyright (c) 2014 bolumyolu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface UtilityMethods : NSObject

+(UtilityMethods *) sharedInstance;

#pragma mark - File Utils
- (NSString *) getDocumentsPath;
- (NSString *) readFileAtPath:(NSString *)path;
- (BOOL) writeString:(NSString *) content toFileAtPath:(NSString *) path;
/*
#pragma mark - Date
+ (NSDate *) dateFromDateTimeString:(NSString *)dateString;
+ (NSString *) dateTimeStringFromNSDate:(NSDate *) date;
+ (NSString *) dateTimeStringFromDate:(NSDate *) date andTime:(NSDate *) time;
+ (NSInteger)minutesFromDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime;
*/
#pragma mark - ATA Date Format
- (NSString *)dateStringFromDateForUI:(NSDate *)date;
- (NSString *)dateStringFromWebServiceDateString:(NSString *)serviceDateString;
- (NSDate *)dateFromWebServiceDateString:(NSString *)serviceDateString;

#pragma mark - 365 Gun Specifics Helpers
- (NSString *)monthStringFromDate:(NSDate *)date;
- (NSString *)dayStringFromDate:(NSDate *)date;
- (NSString *)yearStringFromDate:(NSDate *)date;
- (NSString *)dateStringFromDate:(NSDate *)date;

#pragma mark - String
+(NSNumber *) getNumberFromFormatedString:(NSString *) original;
+(NSString *) getFormattedStringFromNumber:(NSNumber *) original;
+(NSString *) formatNumberString:(NSString *) original;
+(NSString *) getPhoneNumberStrFromFormattedString:(NSString *) text;

#pragma mark - Image
+ (NSData *) compressImage:(UIImage *) image toKB:(CGFloat) kb;
-(UIImage*) drawText:(NSString *)text
             inImage:(UIImage *)image
             atPoint:(CGPoint)point;
#pragma mark  test for perf
-(UIImage *)addText:(UIImage *)img text:(NSString *)text;
#pragma mark - Fonts
- (void)fontNamesInProject;
@end
