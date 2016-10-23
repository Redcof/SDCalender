//
//  SDCalendar.m
//  SoCroLife
//
//  Created by Sabyasachi Saha on 7/6/16.
//  Copyright © 2016 Soumen Sardar. All rights reserved.
//

#import "SDCalendar.h"

@implementation SDCalendar

NSMutableArray<NSMutableDictionary*> *YearCalender;

int days_in_month[]={0,31,28,31,30,31,30,31,31,30,31,30,31};

char *months[]=
{
    " ",
    "\n\n\nJanuary",
    "\n\n\nFebruary",
    "\n\n\nMarch",
    "\n\n\nApril",
    "\n\n\nMay",
    "\n\n\nJune",
    "\n\n\nJuly",
    "\n\n\nAugust",
    "\n\n\nSeptember",
    "\n\n\nOctober",
    "\n\n\nNovember",
    "\n\n\nDecember"
};




#define OK    1
#define WRONG   0
#define LOGGING_ENABLED WRONG



int determinedaycode(int year)
{
    int daycode;
    int d1, d2, d3;
    
    d1 = (year - 1.)/ 4.0;
    d2 = (year - 1.)/ 100.;
    d3 = (year - 1.)/ 400.;
    daycode = (year + d1 - d2 + d3) %7;
    return daycode;
}


int determineleapyear(int year)
{
    if(year% 4 == WRONG && year%100 != WRONG || year%400 == WRONG)
    {
        days_in_month[2] = 29;
        return OK;
    }
    else
    {
        days_in_month[2] = 28;
        return WRONG;
    }
}

void calendar(int year, int daycode)
{
    YearCalender = [[NSMutableArray <NSMutableDictionary *> alloc] init];
    
    int month, day;
    NSMutableDictionary *Month;
    for ( month = 1; month <= 12; month++ )
    {
        Month = [[NSMutableDictionary alloc] init];
        
        if(LOGGING_ENABLED){
            printf("%s", months[month]);
            printf("\n\nSun  Mon  Tue  Wed  Thu  Fri  Sat\n" );
            
            // Correct the position for the first date
            for ( day = 1; day <= 1 + daycode * 5; day++ )
            {
                printf(" ");
            }
            
            // Print all the dates for one month
            for ( day = 1; day <= days_in_month[month]; day++ )
            {
                printf("%2d", day );
                
                // Is day before Sat? Else start next line Sun.
                if ( ( day + daycode ) % 7 > 0 )
                {printf("   " );}
                else
                {printf("\n " );}
            }
        }
        
        [Month setValue:@(month) forKey:@"month_code"];
        [Month setValue:@(daycode) forKey:@"first_week_day_code"];
        [Month setValue:@(days_in_month[month]) forKey:@"total_days"];
        
        [YearCalender addObject:Month];
        // Set position for next month
        daycode = ( daycode + days_in_month[month] ) % 7;
    }
    
    [YearCalender description];
    
}

NSMutableArray* getCalenderDatForYear(int year)
{
    int  daycode;
    daycode = determinedaycode(year);
    determineleapyear(year);
    calendar(year, daycode);
    return YearCalender;
}

@end
