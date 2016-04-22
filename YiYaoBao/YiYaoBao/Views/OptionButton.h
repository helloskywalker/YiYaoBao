//
//  OptionButton.h
//  iosapp
//
//  Created by ChanAetern on 12/17/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  聊天按钮点击后，生成的图标
 */
@interface OptionButton : UIView

@property (nonatomic, strong) UIView *button;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color;

@end
