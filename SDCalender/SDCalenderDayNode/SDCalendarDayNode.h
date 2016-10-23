//
//  SDCalendarDayNode.h
//  TechnoExponentCalendar
//
//  Created by Sabyasachi Saha on 7/6/16.
//  Copyright © 2016 Soumen Sardar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDCalendarDayNode;

@protocol SDCalendarDayNodeDelegate <NSObject>

@optional
-(void)SDCalendarDayNode:(SDCalendarDayNode *)dayNode withDay:(int)day;

@end

@interface SDCalendarDayNode : UIView
@property id<SDCalendarDayNodeDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *viewEventNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
-(void)populateNode;
-(void)thisIsToday;
-(void)eventDay;
-(void)sunday;
-(void)tapForEventPopup:(id)sender;


@end
