//
//  WaterLevel.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/4/30.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import "WaterLevel.h"

@implementation WaterLevel
-(instancetype) init: (CGFloat) time level:(CGFloat) level
{
    self = [super init];
    if(self)
    {
        self.Time = time;
        self.Level = level;
    }
    return self;
}
@end
