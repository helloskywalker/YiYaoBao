//
//  UIColor+Util.h
//  YiYaoBao
//
//  Created by 泥红 on 16/4/21.
//  Copyright © 2016年 YYBTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)
//十六进制颜色表示
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;
//主题色
+ (UIColor *)themeColor;

+ (UIColor *)nameColor;
//标题色
+ (UIColor *)titleColor;
//分割线色
+ (UIColor *)separatorColor;

+ (UIColor *)cellsColor;
+ (UIColor *)selectCellSColor;

+ (UIColor *)titleBarColor;
+ (UIColor *)selectTitleBarColor;
//上导航条颜色
+ (UIColor *)navigationbarColor;
//文本颜色
+ (UIColor *)labelTextColor;
+ (UIColor *)teamButtonColor;

+ (UIColor *)infosBackViewColor;
+ (UIColor *)lineColor;
//字体颜色
+ (UIColor *)contentTextColor;
//边缘颜色
+ (UIColor *)borderColor;
//旋转更新的颜色
+ (UIColor *)refreshControlColor;

@end
