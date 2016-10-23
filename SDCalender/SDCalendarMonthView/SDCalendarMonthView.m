//
//  SDCalendarMonthView.m
//  TechnoExponentCalendar
//  Author:Saurav Dutta
//  Date  :6th July,2016
//  Copyright © 2016 Soumen Sardar. All rights reserved.
//

#import "SDCalendarMonthView.h"
#import "SDCalendar.h"

@interface SDCalendarMonthView()
{
    CGFloat nodeWidth;
    CGFloat nodeDiff;
    CGFloat width;
    CGFloat height;
    CGFloat calender_header_height;
    CGFloat action_bar_height;
    CGFloat week_day_titles_height;
    
    int Month;
    int Year;
    
    CGFloat x;
    CGFloat y;
    
    SDCalendar *SDC;
    
    NSArray<NSDictionary*> *YearCalender;
    NSDictionary *currentData;
    int NumbersOfDays;
    int DayCode;
    
    NSDate *Today;
    
    UILabel *gotoNextMonthActionLabel;
    UILabel *gotoPrevMonthActionLabel;
    UILabel *gotoNextYearActionLabel;
    UILabel *gotoPrevYearActionLabel;
    UILabel *gotoTodayActionLabel;
    UILabel *currentYear;
    UILabel *currentMonth;
    
    UITapGestureRecognizer *tapOnNextMonthActionLabel;
    UITapGestureRecognizer *tapOnPrevMonthActionLabel;
    UITapGestureRecognizer *tapOnNextYearActionLabel;
    UITapGestureRecognizer *tapOnPrevYearActionLabel;
    UITapGestureRecognizer *tapOnTodayActionLabel;
    
    UITapGestureRecognizer *tapForEvent;
    
    UISwipeGestureRecognizer *swipLeft;
    UISwipeGestureRecognizer *swipRight;
    
    
    
    UIView *onlyWeekDayContainer;
    NSArray *months;
    
    UIView *eventPopupContainer;
    UITapGestureRecognizer *dismissEventPopup;
    UIWindow* popup_window ;
    
}
@end
@implementation SDCalendarMonthView

#pragma -Calculation of the hight and width of the calendar.
-(instancetype)initWithFrame:(CGRect)frame Month:(int)month Year:(int)year Width:(CGFloat)Width toDate:(NSDate*)today
{
    self->width = Width;
    self->Today = today;
    
    self->nodeDiff = 1.0f;
    
    self->calender_header_height = 50.0f;
    self->action_bar_height = 35.0f;
    self->week_day_titles_height = 40.0f;
    
    
    self->nodeWidth = (self->width - (8 * self->nodeDiff))/ 7.0f;
    
    self->height =
    ((self->nodeWidth * 5.0f) + (7 * self->nodeDiff) + self->action_bar_height + self->calender_header_height + self->week_day_titles_height);
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, self->width, self->height)];
    
    self.bounds=CGRectMake(0.0f, 0.0f, self->width, self->height);
    
    self->Month = month;
    
    self->Year = year;
    months = [[NSArray alloc] initWithObjects:
              @" ",
              @"January",
              @"February",
              @"March",
              @"April",
              @"May",
              @"June",
              @"July",
              @"August",
              @"September",
              @"October",
              @"November",
              @"December",
              nil
              ];
    [self populateActionBar];
    [self setUpActions];
    
    return self;
}

-(void)setUpActions{
    
    tapOnNextMonthActionLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextMonth:)];
    [gotoNextMonthActionLabel addGestureRecognizer:tapOnNextMonthActionLabel];
    gotoNextMonthActionLabel.userInteractionEnabled = YES;
    
    tapOnPrevMonthActionLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevMonth:)];
    [gotoPrevMonthActionLabel addGestureRecognizer:tapOnPrevMonthActionLabel];
    gotoPrevMonthActionLabel.userInteractionEnabled = YES;
    
    tapOnNextYearActionLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextYear:)];
    [gotoNextYearActionLabel addGestureRecognizer:tapOnNextYearActionLabel];
    gotoNextYearActionLabel.userInteractionEnabled = YES;
    
    tapOnPrevYearActionLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevYear:)];
    [gotoPrevYearActionLabel addGestureRecognizer:tapOnPrevYearActionLabel];
    gotoPrevYearActionLabel.userInteractionEnabled = YES;
    
    tapOnTodayActionLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoToday:)];
    [gotoTodayActionLabel addGestureRecognizer:tapOnTodayActionLabel];
    gotoTodayActionLabel.userInteractionEnabled = YES;
    
    swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextMonth:)];
    swipLeft.direction = UIUserInterfaceLayoutDirectionRightToLeft;
    [self->onlyWeekDayContainer addGestureRecognizer:swipLeft];
    
    swipRight  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevMonth:)];
    swipRight.direction = UIUserInterfaceLayoutDirectionLeftToRight;
    [self->onlyWeekDayContainer addGestureRecognizer:swipRight];
    
    self->onlyWeekDayContainer.userInteractionEnabled = YES;
}

-(void)gotoNextMonth:(id)sender{
    self->Month = (self->Month == 12) ? self->Year++,1 : self->Month + 1;
    currentYear.text = [@(self->Year) stringValue];
    currentMonth.text = [NSString stringWithFormat:@" %@", [months objectAtIndex:self->Month]];
    [self populateCheckBoxes];
}

-(void)gotoPrevMonth:(id)sender{
    self->Month = (self->Month == 1) ? self->Year--,12 : self->Month - 1;
    self->Year = (self->Year == 0) ? 1 : self->Year;
    currentYear.text = [@(self->Year) stringValue];
    currentMonth.text = [NSString stringWithFormat:@" %@", [months objectAtIndex:self->Month]];
    [self populateCheckBoxes ];
}

-(void)gotoNextYear:(id)sender{
    self->Year++;
    currentYear.text = [@(self->Year) stringValue];
    [self populateCheckBoxes];
}

-(void)gotoPrevYear:(id)sender{
    self->Year--;
    self->Year = (self->Year == 0) ? 1 : self->Year;
    currentYear.text = [@(self->Year) stringValue];
    [self populateCheckBoxes];
}

-(void)gotoToday:(id)sender{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    
    NSDate *today = [[NSDate alloc] init];
    
    self->Month = [[format stringFromDate:today] intValue];
    
    [format setDateFormat:@"YYYY"];
    self->Year = [[format stringFromDate:today] intValue];
    
    currentMonth.text = [NSString stringWithFormat:@" %@", [months objectAtIndex:self->Month]];
    currentYear.text = [@(self->Year) stringValue];
    
    [self populateCheckBoxes];
    
}

-(void)dismissEventPopup:(id)sender{
    
    popup_window.hidden = YES;
    [self->eventPopupContainer removeFromSuperview];
    self->eventPopupContainer = nil;
    popup_window= nil;
    
}



-(void)populateActionBar{
    
    //--------------------------- Year And Action View --------------------------
    self->x = self->nodeDiff;
    self->y = 0;
    
    gotoPrevYearActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self->x, self->y, self->nodeWidth , self->calender_header_height)];
    gotoPrevYearActionLabel.text = @"<";
    [gotoPrevYearActionLabel setTextAlignment:NSTextAlignmentCenter];
    gotoPrevYearActionLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    currentYear = [[UILabel alloc] initWithFrame:CGRectMake(self->x, self->y, self->width-self->nodeDiff , self->calender_header_height)];
    currentYear.text = [@(self->Year) stringValue];
    [currentYear setTextAlignment:NSTextAlignmentCenter];
    currentYear.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08];
    
    gotoNextYearActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self->width - self->nodeWidth-self->nodeDiff, self->y, self->nodeWidth , self->calender_header_height)];
    gotoNextYearActionLabel.text = @">";
    [gotoNextYearActionLabel setTextAlignment:NSTextAlignmentCenter];
    gotoNextYearActionLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
    
    [self addSubview:gotoPrevYearActionLabel];
    [self addSubview:currentYear];
    [self addSubview:gotoNextYearActionLabel];
    
    
    
    
    //--------------------------- Month And Action View --------------------------
    self->y = self->calender_header_height;
    self->x = self->nodeDiff;
    
    currentMonth = [[UILabel alloc] initWithFrame:CGRectMake(self->x, self->y, self->width-self->nodeDiff , self->action_bar_height)];
    currentMonth.text = [NSString stringWithFormat:@" %@", [months objectAtIndex:self->Month]];
    [currentMonth setTextAlignment:NSTextAlignmentLeft];
    currentMonth.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.06];
    
    
    CGFloat action_width = 35.0f;
    CGFloat today_button_width = 70.0f;
    
    gotoPrevMonthActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self->width-(2 * action_width + today_button_width+self->nodeDiff), self->y, action_width , self->action_bar_height)];
    gotoPrevMonthActionLabel.text = @"<";
    [gotoPrevMonthActionLabel setTextAlignment:NSTextAlignmentCenter];
    gotoPrevMonthActionLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    
    gotoTodayActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self->width-( action_width + today_button_width+self->nodeDiff ), self->y, today_button_width , self->action_bar_height)];
    gotoTodayActionLabel.text = @"Today";
    [gotoTodayActionLabel setTextAlignment:NSTextAlignmentCenter];
    gotoTodayActionLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    
    
    gotoNextMonthActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self->width-( action_width+self->nodeDiff ), self->y, action_width , self->action_bar_height)];
    gotoNextMonthActionLabel.text = @">";
    [gotoNextMonthActionLabel setTextAlignment:NSTextAlignmentCenter];
    gotoNextMonthActionLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    
    [self addSubview:currentMonth];
    [self addSubview:gotoPrevMonthActionLabel];
    [self addSubview:gotoTodayActionLabel];
    [self addSubview:gotoNextMonthActionLabel];
    
    
    
    //--------------------------- Week Title bar --------------------------
    self->y = calender_header_height + action_bar_height;
    self->x = self->nodeDiff;
    NSArray *dayNames = [[NSArray alloc] initWithObjects:@"Sun",  @"Mon",  @"Tue",  @"Wed" , @"Thu",  @"Fri" , @"Sat", nil];
    for(int k = 0;k < 7 ; k++)
    {
        UILabel *dayNameText = [[UILabel alloc] initWithFrame:CGRectMake(self->x, self->y, self->nodeWidth , week_day_titles_height)];
        self->x += self->nodeWidth + self->nodeDiff;
        dayNameText.text = [dayNames objectAtIndex:k];
        dayNameText.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
        dayNameText.clipsToBounds = YES;
        
        [dayNameText setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:dayNameText];
    }
    
    
}

-(void)populateCheckBoxes{
    
    self->x = self->nodeDiff;
    self->y = calender_header_height + action_bar_height + week_day_titles_height  ;
    
    [self->onlyWeekDayContainer removeFromSuperview];
    
    self->onlyWeekDayContainer = nil;
    
    self->onlyWeekDayContainer = [[UIView alloc] initWithFrame:CGRectMake(self->x,  self->y , self->width, self->height)];
    
    YearCalender = [[NSArray alloc] initWithArray:getCalenderDatForYear(self->Year)];
    
    for (NSDictionary *monthData in YearCalender) {
        if([[monthData valueForKey:@"month_code"] intValue] == self->Month){
            currentData = [[NSDictionary alloc] initWithDictionary:monthData];
            break;
        }
    }
    
    self->NumbersOfDays = [[currentData valueForKey:@"total_days"] intValue];
    self->DayCode = [[currentData valueForKey:@"first_week_day_code"] intValue];
    
    int i,perline,dayCode = self->DayCode,totalDay = self->NumbersOfDays,today_no_WRT_month = 1;
    
    self->x = self->nodeDiff;
    self->y = self->nodeDiff;
    
    BOOL Sunday = false;
    
    for (perline = 6, i = 0;  i < 35; i++ ,  perline--)
    {
        
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"SDCalendarDayNode" owner:self options:nil];
        SDCalendarDayNode *dayNode = [subviewArray objectAtIndex:0];
        
        dayNode.bounds = CGRectMake(0,0,self->nodeWidth-self->nodeDiff,self->nodeWidth);
        
        dayNode.frame = CGRectMake(self->x,self->y,self->nodeWidth-self->nodeDiff,self->nodeWidth);
        
        if(i % 7 == 0){
            Sunday = false;
            [dayNode sunday];//Sunday
        }
        if(perline > 0){
            self->x += self->nodeWidth+self->nodeDiff ;
        }
        else{
            self->x = 0;
            self->y += self->nodeWidth+self->nodeDiff;
            Sunday = YES;
            perline = 7;
        }
        
        dayNode.lblDate.text = @"";
        [dayNode populateNode];
        if(i >= dayCode && totalDay > 0){
            if([self.eventDelegate respondsToSelector:@selector(sDCalendarMonthView:isForDate:)])
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setDay:today_no_WRT_month];
                [components setMonth:self->Month];
                [components setYear:self->Year];
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDate *date = [calendar dateFromComponents:components];
                
                
                if([self.eventDelegate sDCalendarMonthView:self isForDate:date]){
                    [dayNode eventDay];
                    dayNode.delegate = self;
                    tapForEvent = [[UITapGestureRecognizer alloc] initWithTarget:dayNode action:@selector(tapForEventPopup:)];
                    [dayNode addGestureRecognizer:tapForEvent];
                }
            }
            
            dayNode.lblDate.text = [@(today_no_WRT_month) stringValue];
            
            if([self isToday:today_no_WRT_month])
            {
                [dayNode thisIsToday];
            }
            
            today_no_WRT_month++;
            
            totalDay--;
        }
        
        [self->onlyWeekDayContainer addSubview:dayNode];
    }
    
    [self addSubview:self->onlyWeekDayContainer];
    [self setUpActions];
}

-(BOOL)isToday:(int)tday
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    
    NSDate *today = [[NSDate alloc] init];
    
    int month = [[format stringFromDate:today] intValue];
    
    [format setDateFormat:@"YYYY"];
    int year = [[format stringFromDate:today] intValue];
    
    [format setDateFormat:@"dd"];
    int day = [[format stringFromDate:today] intValue];
    
    return (self->Year == year && self->Month == month && day == tday);
}

#pragma mark - SDCalendarDayNodeDelegate
-(void)SDCalendarDayNode:(SDCalendarDayNode *)dayNode withDay:(int)day
{
    if([self.eventDelegate respondsToSelector:@selector(sDCalendarMonthView:eventViewForDate:)]){
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        [components setDay:day];
        [components setMonth:self->Month];
        [components setYear:self->Year];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [calendar dateFromComponents:components];
        
        UIView *popup = [self.eventDelegate sDCalendarMonthView:self eventViewForDate:date];
        if(popup != nil){
            [self->eventPopupContainer removeFromSuperview];
            
            self->eventPopupContainer = nil;
            
            self->eventPopupContainer = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
            popup.center = self->eventPopupContainer.center;
            [self->eventPopupContainer setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
            [self->eventPopupContainer addSubview:popup];
            
            self->dismissEventPopup = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissEventPopup:)];
            self->eventPopupContainer.userInteractionEnabled = YES;
            [self->eventPopupContainer addGestureRecognizer:self->dismissEventPopup];
            popup_window = nil;
            popup_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            popup_window.windowLevel = UIWindowLevelAlert;
            popup_window.opaque = NO;
            
            [popup_window addSubview:self->eventPopupContainer];
            
            // window has to be un-hidden on the main thread
            popup_window.hidden = NO ;
        }
    }
}

@end
