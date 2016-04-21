//
//  YYBMainController.m
//  YiYaoBao
//
//  Created by 泥红 on 16/4/21.
//  Copyright © 2016年 YYBTeam. All rights reserved.
//

#import "YYBMainController.h"
#import "YYBMallController.h"
#import "YYBNearByController.h"
#import "YYBUserController.h"
#import "YYBClassesController.h"
#import "YYBChatController.h"

@interface YYBMainController ()

@end

@implementation YYBMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *otcMallController = [[UINavigationController alloc]initWithRootViewController:[[YYBMallController alloc]init]];
    UINavigationController *classesController = [[UINavigationController alloc]initWithRootViewController:[[YYBClassesController alloc]init]];
    UINavigationController *nearByController = [[UINavigationController alloc]initWithRootViewController:[[YYBNearByController alloc]init]];
    UINavigationController *chatController = [[UINavigationController alloc]initWithRootViewController:[[YYBChatController alloc]init]];
    UINavigationController *userController = [[UINavigationController alloc]initWithRootViewController:[[YYBUserController alloc]init]];
    NSArray * nameTitles = @[@"主页",@"分类",@"附近",@"聊天",@"我"];
    NSArray *icon = @[@"",@"",@"",@"",@""];
    
    self.viewControllers = @[otcMallController,classesController,nearByController,chatController,userController];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitle:nameTitles[idx]];
        [item setImage:[UIImage imageNamed:icon[idx]]];
       // [item setSelectedImage:<#(UIImage * _Nullable)#>]
    }];
    
    
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
