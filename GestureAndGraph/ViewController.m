//
//  ViewController.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/4/17.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//
//依照iPhone 6s Plus分辨率设计
#import "ViewController.h"

@interface ViewController ()
{
    UILabel* label;
    GraphViewController* graphView;
    GestureController* gestureView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor cyanColor];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-80, self.view.bounds.size.height/2-20, 160, 40)];
    [label setText:@"请点击屏幕"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    graphView = [[GraphViewController alloc]init];
    gestureView = [[GestureController alloc]init];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}
-(void) tap:(UITapGestureRecognizer*) sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你想进入哪个页面" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* gesture = [UIAlertAction actionWithTitle:@"进入手势" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self presentViewController:gestureView animated:true completion:nil];
    }];
    UIAlertAction* graph = [UIAlertAction actionWithTitle:@"进入绘图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self presentViewController:graphView animated:true completion:nil];
    }];
    
    [alert addAction:gesture];
    [alert addAction:graph];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
