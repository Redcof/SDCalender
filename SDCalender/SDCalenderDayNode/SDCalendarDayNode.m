//
//  SDCalendarDayNode.m
//  TechnoExponentCalendar
//  Author:Saurav Dutta
//  Date  :6th July,2016
//  Copyright © 2016 Soumen Sardar. All rights reserved.
//

#import "SDCalendarDayNode.h"

@implementation SDCalendarDayNode


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0f];
}

-(void)populateNode{
    
    CGFloat lblWidth = self.bounds.size.width/2;
    self.lblDate.bounds = CGRectMake(0, 0, lblWidth, lblWidth);
    self.lblDate.frame = CGRectMake((self.bounds.size.width/2) - (lblWidth/2), (self.bounds.size.width/2) - (lblWidth/2), lblWidth, lblWidth);
    
    self.lblDate.layer.cornerRadius = self.lblDate.bounds.size.width/2;
    self.lblDate.clipsToBounds = YES;
    
    
    
    self.viewEventNotification.bounds = CGRectMake(0, 0, 5, 5);
    self.viewEventNotification.layer.cornerRadius = self.viewEventNotification.bounds.size.width/2;
    self.viewEventNotification.hidden = YES;
}

-(void)thisIsToday{
    self.lblDate.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0f];
    [self.lblDate setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f]];
}

-(void)eventDay{
    self.viewEventNotification.hidden = NO;
}

-(void)sunday{
    self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
    //[self.lblDate setTextColor:[UIColor colorWithWhite:0.70 alpha:1.0]];
}


-(void)tapForEventPopup:(id)sender{
    if([self.delegate respondsToSelector:@selector(SDCalendarDayNode:withDay:)]){
        [self.delegate SDCalendarDayNode:self withDay:[self.lblDate.text intValue]];
    }
}


@end
