//
//  NSDate+Help.h
//  LearniOSSample
//
//  Created by szyl on 15/1/14.
//  Copyright (c) 2015年 ZIC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * NSDate convenience methods which shortens some of frequently used formatting and date altering methods.
 */
@interface NSDate (Help)

#pragma mark - 从NSDate+Helpers复制而来
/**
 * Returns current (self) date without time components. Effectively, it's just a beginning of a day.
 */
- (NSDate *) dateWithoutTime;

/**
 * Returns a date object shifted by a given number of days from the current (self) date.
 */
- (NSDate *) dateByAddingDays:(NSInteger) days;

- (NSDate *) dateByAddingDaysOnGMT:(NSInteger) days;


/**
 * Returns a date object shifted by a given number of months from the current (self) date.
 */
- (NSDate *) dateByAddingMonths:(NSInteger) months;

- (NSDate *) dateByAddingMonthsOnGMT:(NSInteger) months;


/**
 * Returns a date object shifted by a given number of years from the current (self) date.
 */
- (NSDate *) dateByAddingYears:(NSInteger) years;

/**
 * Returns a date object shifted by a given number of days, months and years from the current (self) date.
 */
- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years;

/**
 * Returns start of month for the current (self) date.
 */
- (NSDate *) monthStartDate;

- (NSDate *) monthStartDateOnGMT;

/**
 * Returns start of day for the current (self) date.
 */
- (NSDate *) midnightDate;

/**
 * Returns the number of days in the current (self) month.
 */
- (NSUInteger) numberOfDaysInMonth;

- (NSUInteger) numberOfDaysInMonthOnGMT;

/**
 * Returns the weekday of the current (self) date.
 *
 * Returns 1 for Sunday, 2 for Monday ... 7 for Saturday
 */
- (NSUInteger) weekdays;

- (NSUInteger) weekdayForChina;

/**
 * Returns the number of days since given date.
 */
- (NSInteger) daysSinceDate:(NSDate *) date;

- (NSInteger) daysSinceDate:(NSDate *) date localTimeZoneSec:(NSTimeInterval) sec;


/**
 * Returns string representation of the current (self) date formatted with given format.
 *
 * i.e. "dd-MM-yyyy" will return "14-07-2012"
 */
- (NSString *) dateStringWithFormat:(NSString *) format;

- (NSString *) dateStringWithGregorianFormat:(NSString *)format;

- (NSString *) dateStringWithChineseFormat:(NSString *) format;


/**
 * Checks if a given date is before or after the current (self) date.
 */
- (BOOL) isBefore:(NSDate *) date;
- (BOOL) isAfter:(NSDate *) date;

#pragma mark -从NSDate+Helper复制而来

+ (void)initializeStatics;

+ (NSCalendar *)sharedCalendar;
+ (NSDateFormatter *)sharedDateFormatter;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
- (NSUInteger)weekNumber;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)year;
- (long int)utcTimeStamp; //full seconds since
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;
- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;












@end
