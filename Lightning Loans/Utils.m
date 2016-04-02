//
//  Utils.m
//  Lightning Loans
//
//  Created by 孙萌 on 16/4/2.
//  Copyright © 2016年 Sun Meng. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSDate*) getDateWithDateString:(NSString*) dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

@end
