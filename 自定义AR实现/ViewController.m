//
//  ViewController.m
//  自定义AR实现
//
//  Created by 黄红荫 on 2017/9/30.
//  Copyright © 2017年 黄红荫. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNViewViewController.h"
#import "ARSCNViewPlaneController.h"
#import "ARSCNViewMoveController.h"
#import "ARSCNViewRotateController.h"
@interface ViewController ()

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}
- (IBAction)openAR:(id)sender {
    ARSCNViewViewController *vc = [[ARSCNViewViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)ARPlane:(id)sender {
    ARSCNViewPlaneController *vc = [[ARSCNViewPlaneController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)ARMove:(id)sender {
    ARSCNViewMoveController *vc = [[ARSCNViewMoveController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)ARRotation:(id)sender {
    ARSCNViewRotateController *vc = [[ARSCNViewRotateController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


@end
