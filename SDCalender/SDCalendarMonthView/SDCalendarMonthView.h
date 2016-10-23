//
//  SDCalendarMonthView.h
//  TechnoExponentCalendar
//
//  Created by Sabyasachi Saha on 7/6/16.
//  Copyright © 2016 Soumen Sardar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCalendarDayNode.h"
#import "SDCalendarMonthViewHeader.h"

@class SDCalendarMonthView;
@protocol SDCalendarMonthViewEventDelegate <NSObject>

@optional
-(BOOL)sDCalendarMonthView:(SDCalendarMonthView *)calender isForDate:(NSDate*)date;
-(UIView *)sDCalendarMonthView:(SDCalendarMonthView *)calender eventViewForDate:(NSDate*)date;
@end

@interface SDCalendarMonthView : UIView<SDCalendarDayNodeDelegate>
-(instancetype)initWithFrame:(CGRect)frame Month:(int)month Year:(int)year Width:(CGFloat)Width toDate:(NSDate*)today;
@property id<SDCalendarMonthViewEventDelegate> eventDelegate;
-(void)populateCheckBoxes;

@end
