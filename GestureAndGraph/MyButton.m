//
//  MyButton.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/5/7.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import "MyButton.h"
@interface MyButton()
{
    
}
@end
@implementation MyButton
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setIsSelected:(BOOL)isSelected
{
    if(!isSelected)
    {
        self.backgroundColor = [UIColor greenColor];
    }
    else
    {
        self.backgroundColor = [UIColor orangeColor];
    }
    _isSelected = isSelected;
}
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];//状态变更
        self.layer.cornerRadius = frame.size.width/2.0;
        self.layer.masksToBounds = true;
        self.backgroundColor = [UIColor greenColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
-(void)tap: (UITapGestureRecognizer*) sender
{
    self.isSelected = !self.isSelected;
}
@end
