//
//  GestureView.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/5/7.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2-40, 320, 80)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}
-(void) setLabelText: (NSString*) labelText
{
    [self.label setText:labelText];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
