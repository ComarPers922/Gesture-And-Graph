//
//  WaterLevel.h
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/4/30.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WaterLevel : NSObject
@property (assign,nonatomic) CGFloat Time;
@property (assign,nonatomic) CGFloat Level;

-(instancetype) init: (CGFloat) time level:(CGFloat) level;
@end
