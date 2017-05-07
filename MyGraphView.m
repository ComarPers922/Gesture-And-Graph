//
//  MyGraphView.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/4/17.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import "MyGraphView.h"

#define originPoint CGPointMake(50,500)
#define graphWidth 200
#define graphHeight 300
@interface MyGraphView()

@property (strong,nonatomic) UIButton* backButton;

@end
@implementation MyGraphView
UIColor *myColor;
UIColor* lineColor;

CGFloat scaleX = 0;
CGFloat preScale = 0;

CGFloat lineX = 0;
int lineIndex = 0;

bool shouldDrawLine = false;

NSMutableArray<WaterLevel*>* data;
NSMutableArray<WaterLevel*>* actualPoints;//渲染到屏幕实际坐标，仍然使用相同类但储存不同数据
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = true;
        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-40, self.bounds.size.height-70, 80, 50)];
        self.backButton.backgroundColor = [UIColor redColor];
        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backButton];
        
        [self addGestureRecognizer:pinch];
        [self addGestureRecognizer:pan];
        
        [self initData];
    }
    return  self;
}
-(void)back:(UIButton*) sender
{
    [self.superController dismissViewControllerAnimated:true completion:nil];
}
-(void) initData
{
    //添加一些数据
    WaterLevel * w1 = [[WaterLevel alloc]init:0 level:30];
    WaterLevel * w2 = [[WaterLevel alloc]init:1 level:50];
    WaterLevel * w3 = [[WaterLevel alloc]init:2 level:100];
    WaterLevel * w4 = [[WaterLevel alloc]init:3 level:20];
    WaterLevel * w5 = [[WaterLevel alloc]init:4 level:70];
    WaterLevel * w6 = [[WaterLevel alloc]init:5 level:90];
    WaterLevel * w7 = [[WaterLevel alloc]init:6 level:50];
    WaterLevel * w8 = [[WaterLevel alloc]init:7 level:30];
    WaterLevel * w9 = [[WaterLevel alloc]init:8 level:50];
    WaterLevel * w10 = [[WaterLevel alloc]init:9 level:100];

    data = [[NSMutableArray alloc]initWithArray:@[w1,w2,w3,w4,w5,w6,w7,w8,w9,w10]];
    //归一化
#pragma mark normalize Y
    CGFloat minY = data[0].Level;
    CGFloat maxY = data[0].Level;
    for(int i = 1;i<data.count;i++)
    {
        if(data[i].Level>maxY)
        {
            maxY = data[i].Level;
        }
        if(data[i].Level<minY)
        {
            minY = data[i].Level;
        }
    }
    CGFloat actualScaleY = maxY - minY;
    
#pragma mark normalize X
    CGFloat actualScaleX = data[data.count-1].Time - data[0].Time;
    
    actualPoints = [[NSMutableArray alloc]init];
    for(WaterLevel* item in data)
    {
        [actualPoints addObject:[[WaterLevel alloc]init:item.Time*graphWidth/actualScaleX level:item.Level*graphHeight/actualScaleY]];
    }
}
-(void) pan:(UIPanGestureRecognizer*)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        shouldDrawLine = false;
        [self setNeedsDisplay];
        return;
    }
    int currentIndex = 0;
    int index = 0;
    int currentChange = self.bounds.size.width;
    bool firstItem = true;
    for(WaterLevel* item in actualPoints)
    {//画图，使用实际坐标
        double currentItem = (originPoint.x+item.Time) * (firstItem?1 : (1+scaleX));
        firstItem = false;
        double tapX = [sender locationInView:self].x;
        if(fabs(tapX-currentItem)<currentChange)
        {
            currentChange = fabs(tapX-currentItem);
            currentIndex = index;
        }
        index ++;
    }
    shouldDrawLine = true;
    lineX = actualPoints[currentIndex].Time;
    lineIndex = currentIndex;
    [self setNeedsDisplay];
}
-(void) pinch:(UIPinchGestureRecognizer*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        preScale = sender.scale;
    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        scaleX += sender.scale - preScale;
        preScale = sender.scale;
        if(scaleX < 0)//限制图像的缩放
        {
            scaleX = 0;
        }
        else if(scaleX > .4)
        {
            scaleX = .4;
        }
        [self setNeedsDisplay];
    }
}
- (void)drawRect:(CGRect)rect
{
    myColor = [UIColor greenColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [myColor setStroke];
    CGContextSetLineWidth(context, 5);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
#pragma mark Draw Marks
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 2);
#pragma mark Draw Y
    for(int i =0;i<6;i++)
    {
        [[[NSString alloc]initWithFormat:@"%d",i*20] drawInRect:CGRectMake(originPoint.x-30, originPoint.y - (graphHeight + 150) * i/6 , 30, 20) withAttributes:nil];
    }
#pragma mark Draw X
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSParagraphStyleAttributeName:paragraphStyle};
    for(int i =0;i<actualPoints.count;i++)
    {
        [[[NSString alloc]initWithFormat:@"%.1lf", data[i].Time] drawInRect:CGRectMake((originPoint.x + actualPoints[i].Time)*(1+scaleX)-25, originPoint.y+10 ,50, 20) withAttributes:attribute];
        CGContextMoveToPoint(context, (originPoint.x + actualPoints[i].Time)*(1+scaleX), originPoint.y);
        CGContextAddLineToPoint(context, (originPoint.x + actualPoints[i].Time)*(1+scaleX), originPoint.y+10);
    }
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
#pragma mark X
    CGContextMoveToPoint(context, originPoint.x, originPoint.y);
    CGContextAddLineToPoint(context, originPoint.x + graphWidth*(1+scaleX)+50, 500);
    CGContextAddLineToPoint(context, (originPoint.x +graphWidth-20*(1+scaleX))*(1+scaleX)+50, 490);
    CGContextMoveToPoint(context, originPoint.x +graphWidth*(1+scaleX)+50, 500);
    CGContextAddLineToPoint(context, (originPoint.x + graphWidth-20*(1+scaleX))*(1+scaleX)+50, 510);
#pragma mark Y
    CGContextMoveToPoint(context, originPoint.x, originPoint.y);
    NSString * unit = @"水位/m";
    [unit drawInRect:CGRectMake(originPoint.x-45, 100, 40, 30) withAttributes:nil];
    CGContextAddLineToPoint(context, 50, 100);
    CGContextAddLineToPoint(context, 40, 120);
    CGContextMoveToPoint(context, 50, 100);
    CGContextAddLineToPoint(context, 60, 120);
    CGContextStrokePath(context);
#pragma mark End
    
    CGContextMoveToPoint(context, (originPoint.x+actualPoints[0].Time)*(1+scaleX), originPoint.y-actualPoints[0].Level);
    
    for(int i =1;i<actualPoints.count;i++)
    {
        CGContextAddLineToPoint(context, (originPoint.x+actualPoints[i].Time)*(1+scaleX), originPoint.y-actualPoints[i].Level);
    }
    
    CGContextStrokePath(context);

#pragma mark DrawLine
    if(shouldDrawLine)
    {//应该标注相应的坐标信息了
        CGContextSaveGState(context);
        lineColor = [UIColor blackColor];
        [lineColor setStroke];
        CGContextSetLineWidth(context, 2);
        CGContextMoveToPoint(context, (originPoint.x + lineX)*(1+scaleX), originPoint.y);
        CGContextAddLineToPoint(context, (originPoint.x + lineX)*(1+scaleX), originPoint.y-600);
        [[[NSString alloc]initWithFormat:@"时间:%.2lf\n水位:%.2lf", data[lineIndex].Time,data[lineIndex].Level] drawInRect:CGRectMake((lineX+50)*(1+scaleX), 120, 100, 50) withAttributes:nil];
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

@end
