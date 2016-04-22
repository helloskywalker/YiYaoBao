//
//  Utils.h
//  YiYaoBao
//
//  Created by 泥红 on 16/4/21.
//  Copyright © 2016年 YYBTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface Utils : NSObject

//夜晚，白天设置
+ (void)saveWhetherNightMode:(BOOL)isNight;
+ (BOOL)getMode;

//快速创建HUD
+ (MBProgressHUD *)createHUD;


@end
