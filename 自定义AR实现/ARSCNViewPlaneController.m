//
//  ARSCNViewPlaneController.m
//  自定义AR实现
//
//  Created by 黄红荫 on 2017/10/1.
//  Copyright © 2017年 黄红荫. All rights reserved.
//

#import "ARSCNViewPlaneController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ARSCNViewPlaneController ()<ARSCNViewDelegate, ARSessionDelegate>
//AR视图：展示3D界面
@property (nonatomic, strong) ARSCNView *arSCNView;
//AR会话：负责管理相机追踪配置及3D相机坐标
@property (nonatomic, strong) ARSession *arSession;
//会话追踪配置：负责追踪相机的运动
@property (nonatomic, strong) ARConfiguration *arConfiguration;
//飞机3D模型
@property (nonatomic, strong) SCNNode *planeNode;
@end

@implementation ARSCNViewPlaneController
#pragma mark- 搭建ARKit环境
// 懒加载
- (ARSCNView *)arSCNView
{
    if(_arSCNView) return _arSCNView;
    _arSCNView = [[ARSCNView alloc]initWithFrame:self.view.bounds];
    _arSCNView.delegate = self;
    _arSCNView.session = self.arSession;
    _arSCNView.automaticallyUpdatesLighting = YES;
    return _arSCNView;
    
}
- (ARSession *)arSession
{
    if(_arSession) return _arSession;
    _arSession = [[ARSession alloc]init];
    _arSession.delegate = self;
    return _arSession;
    
}
- (ARConfiguration *)arConfiguration
{
    if(_arConfiguration) return _arConfiguration;
    // 创建世界会话追踪配置
    ARWorldTrackingConfiguration *cfg  = [[ARWorldTrackingConfiguration alloc]init];
    // 设置追踪方向:追踪平面
    cfg.planeDetection = ARPlaneDetectionHorizontal;
    _arConfiguration = cfg;
    //自适应灯光
    _arConfiguration.lightEstimationEnabled = YES;
    return _arConfiguration;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)back:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Called when the view has been fully transitioned onto the screen. Default does nothing
    // 将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    // 开启AR会话:此时相机开始工作
    [self.arSession runWithConfiguration:self.arConfiguration];
    
    // 添加返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.bounds.size.width / 2 - 50, self.view.bounds.size.height - 100, 100, 50);
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


#pragma mark- ARSCNViewDelegate
//添加节点时候调用（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点）
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，要想更加清楚看到这个空间，我们需要给空间添加一个平地的3D模型来渲染他
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型 （系统捕捉到的平地是一个不规则大小的长方形，这里将其变成一个长方形)
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x * 0.3 height:0 length:planeAnchor.extent.x * 0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，这里改成红色）
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        
        
        //当捕捉到平地时，2s之后开始在平地上添加一个3D模型
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
            //2.获取模型节点
            SCNNode *shoeNode = scene.rootNode.childNodes[0];
            //4.设置模型节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
            shoeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            //5.将模型节点添加到当前屏幕中
            [node addChildNode:shoeNode];
        });
        
        
    }
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
