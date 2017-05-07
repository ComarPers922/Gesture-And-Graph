//
//  GraphViewController.m
//  GestureAndGraph
//
//  Created by ComarPers 922 on 2017/5/1.
//  Copyright © 2017年 ComarPers 922. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()
{
     MyGraphView * myView;
}

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myView = [[MyGraphView alloc]initWithFrame:[self.view bounds]];
    myView.superController = self;
    myView.backgroundColor = [UIColor yellowColor];
    [myView setNeedsDisplay];
    [self.view addSubview:myView];
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
