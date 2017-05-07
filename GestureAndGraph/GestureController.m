//
//  GestureController.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/5/7.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import "GestureController.h"

@interface GestureController ()

@property (strong,nonatomic) UIButton* backButton;
@property (strong,nonatomic) GestureView* myGestureView;//手势实验面板

@property (strong,nonatomic) MyButton* tapButton;
@property (strong,nonatomic) MyButton* swipeButton;
@property (strong,nonatomic) MyButton* longPressButton;
@property (strong,nonatomic) MyButton* panButton;
@property (strong,nonatomic) MyButton* pinchButton;
@property (strong,nonatomic) MyButton* rotationButton;
@property (strong,nonatomic) MyButton* screenEdgeButton;

@property (strong,nonatomic) NSDictionary<MyButton*,UIGestureRecognizer*>* buttonGesturePair;//字典类将按钮与对应手势匹配

@property (strong,nonatomic) UITapGestureRecognizer* tap;
@property (strong,nonatomic) UISwipeGestureRecognizer* swipe;
@property (strong,nonatomic) UILongPressGestureRecognizer* longPress;
@property (strong,nonatomic) UIPanGestureRecognizer* pan;
@property (strong,nonatomic) UIPinchGestureRecognizer* pinch;
@property (strong,nonatomic) UIRotationGestureRecognizer* rotation;
@property (strong,nonatomic) UIPanGestureRecognizer* screenEdge;//这个手势特殊处理以便于适用于各种UIView而不限于贴靠屏幕

@property (strong,nonatomic) UILabel* animationView;

@end

@implementation GestureController
#define buttonSize 50
//为按钮三角阵设计，按照iPhone 6S Plus 分辨率为参考
#define originX 30
#define originY 200
NSString* nameOfCurrentGesture;
MyButton* currentSelectedButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animationView = [[UILabel alloc]init];
    self.animationView.backgroundColor = [UIColor blackColor];
    self.animationView.textAlignment = NSTextAlignmentCenter;
    self.animationView.textColor = [UIColor whiteColor];
    self.animationView.alpha = .5;
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, self.view.bounds.size.height-70, 80, 50)];
    self.backButton.backgroundColor = [UIColor redColor];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.backButton];
    
    self.myGestureView = [[GestureView alloc]initWithFrame:CGRectMake(10, 300, self.view.bounds.size.width - 20, 300)];
    self.myGestureView.backgroundColor = [UIColor yellowColor];
    [self.myGestureView setLabelText:@"请点击上面的按钮，完成一个手势操作"];
    [self.view addSubview: self.myGestureView];

    self.view.backgroundColor = [UIColor cyanColor];
#pragma mark 按钮三角阵
    self.tapButton = [[MyButton alloc]initWithFrame:CGRectMake(originX, originY, buttonSize, buttonSize)];
    self.swipeButton = [[MyButton alloc]initWithFrame:CGRectMake(originX+50, originY-50, buttonSize, buttonSize)];
    self.longPressButton = [[MyButton alloc]initWithFrame:CGRectMake(originX+100, originY-100, buttonSize, buttonSize)];
    self.panButton = [[MyButton alloc]initWithFrame:CGRectMake(originX+150, originY-150, buttonSize, buttonSize)];
    self.pinchButton = [[MyButton alloc]initWithFrame:CGRectMake(originX+200, originY-100, buttonSize, buttonSize)];
    self.rotationButton = [[MyButton alloc]initWithFrame:CGRectMake(originX+250, originY-50, buttonSize, buttonSize)];
    self.screenEdgeButton = [[MyButton alloc]initWithFrame:CGRectMake(originX+300, originY, buttonSize, buttonSize)];

    [self.tapButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.longPressButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.swipeButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.panButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.pinchButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotationButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.screenEdgeButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
     [self.tapButton setTitle:@"点击" forState:UIControlStateNormal];
     [self.longPressButton setTitle:@"长按" forState:UIControlStateNormal];
     [self.swipeButton setTitle:@"轻扫" forState:UIControlStateNormal];
     [self.panButton setTitle:@"滑动" forState:UIControlStateNormal];
     [self.pinchButton setTitle:@"缩放" forState:UIControlStateNormal];
     [self.rotationButton setTitle:@"旋转" forState:UIControlStateNormal];
     [self.screenEdgeButton setTitle:@"边缘" forState:UIControlStateNormal];
    
    [self.view addSubview:self.tapButton];
    [self.view addSubview:self.swipeButton];
    [self.view addSubview:self.longPressButton];
    [self.view addSubview:self.panButton];
    [self.view addSubview:self.pinchButton];
    [self.view addSubview:self.rotationButton];
    [self.view addSubview:self.screenEdgeButton];
    
#pragma mark 手势七大天王
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    self.swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    self.pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    self.rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    self.screenEdge = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(edgeGesture:)];//这个手势特殊处理以便于适用于各种UIView而不限于贴靠屏幕

    self.buttonGesturePair = @{self.tapButton:self.tap
                               ,self.longPressButton:self.longPress
                               ,self.swipeButton:self.swipe
                               ,self.panButton:self.pan
                               ,self.rotationButton:self.rotation
                               ,self.screenEdgeButton:self.screenEdge
                               ,self.pinchButton:self.pinch};
}
bool isGoodToGo = false;
-(void)edgeGesture:(UIPanGestureRecognizer*) sender
{
    //判断在手势开始时是否在边缘附近
    if(([sender locationInView:self.myGestureView].x<30
          ||[sender locationInView:self.myGestureView].x>self.myGestureView.frame.size.width-30
          ||[sender locationInView:self.myGestureView].y<30
          ||[sender locationInView:self.myGestureView].y>self.myGestureView.frame.size.height-30))
    {
        isGoodToGo = true;
    }
    
    if(isGoodToGo)
    {
        //判断手势是否进入内部
        if([sender locationInView:self.myGestureView].x>30
             ||[sender locationInView:self.myGestureView].x<self.myGestureView.frame.size.width-30
             ||[sender locationInView:self.myGestureView].y>30
             ||[sender locationInView:self.myGestureView].y<self.myGestureView.frame.size.height-30)
            {
                //清除当前手势，显示动画，并且初始化当前实验面板
                [self.myGestureView removeGestureRecognizer:self.myGestureView.gestureRecognizers[0]];
                self.animationView.frame = CGRectMake(self.view.bounds.size.width/2-100, 300,200, 100) ;
                [self.view addSubview:self.animationView];
                [self.animationView setText:[NSString stringWithFormat:@"%@方法已经触发",nameOfCurrentGesture]];
                [UIView animateWithDuration: .7 animations:^{
                    CGPoint currentPoint = self.animationView.frame.origin;
                    CGSize currentSize = self.animationView.frame.size;
                    self.animationView.frame =CGRectMake(currentPoint.x, currentPoint.y+100, currentSize.width, currentSize.height);
                } completion:^(BOOL finished) {
                    [self.animationView removeFromSuperview];
                    currentSelectedButton.isSelected = false;
                    currentSelectedButton = nil;
                    [self.myGestureView setLabelText:@"请点击上面的按钮，完成一个手势操作"];
                }];
                isGoodToGo = false;
            }
    }
}
-(void)gesture:(UIGestureRecognizer*) sender
{
    [self.myGestureView removeGestureRecognizer:self.myGestureView.gestureRecognizers[0]];
    self.animationView.frame = CGRectMake(self.view.bounds.size.width/2-100, 300,200, 100) ;
    [self.view addSubview:self.animationView];
    [self.animationView setText:[NSString stringWithFormat:@"%@方法已经触发",nameOfCurrentGesture]];
    //开启动画
    [UIView animateWithDuration: .7 animations:^{
        CGPoint currentPoint = self.animationView.frame.origin;
        CGSize currentSize = self.animationView.frame.size;
        self.animationView.frame =CGRectMake(currentPoint.x, currentPoint.y+100, currentSize.width, currentSize.height);
    }
   completion:^(BOOL finished)
    {
        //动画完成后移除提示框
        [self.animationView removeFromSuperview];
        currentSelectedButton.isSelected = false;
        currentSelectedButton = nil;
        [self.myGestureView setLabelText:@"请点击上面的按钮，完成一个手势操作"];
    }];
}
-(void)buttonEvent:(MyButton*)sender
{
    //清除当前有的手势
    if(self.myGestureView.gestureRecognizers.count>0)
    {
        [self.myGestureView removeGestureRecognizer:self.myGestureView.gestureRecognizers[0]];
    }
    currentSelectedButton.isSelected = !currentSelectedButton;//按钮状态切换
    if(currentSelectedButton == sender)
    {
        [self.myGestureView setLabelText:@"请点击上面的按钮，完成一个手势操作"];
        currentSelectedButton = nil;
        return;
    }
    currentSelectedButton = sender;
    nameOfCurrentGesture = sender.titleLabel.text;
    [self.myGestureView setLabelText:sender.titleLabel.text];//显示当前的手势名称
    [self.myGestureView addGestureRecognizer:[self.buttonGesturePair objectForKey:sender]];//将选中手势加入到实验面板
}
-(void)back:(UIButton*) sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
