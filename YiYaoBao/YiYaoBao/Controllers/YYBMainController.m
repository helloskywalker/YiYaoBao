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

#import "OptionButton.h"

#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "UIImage+Util.h"

@interface YYBMainController ()
@property (nonatomic, strong) UIButton *centerButton;
/**
 *  中间的聊天嗯扭是否被点击
 */
@property (nonatomic, assign) BOOL isPressed;
/**
 *  中间的聊天按钮的物理引擎
 */
@property (nonatomic, strong) UIDynamicAnimator *animator;
/**
 *  聊天按钮点击后生成的蒙板
 */
@property (nonatomic, strong) UIView *dimView;
/**
 *  蒙板上的模糊图像
 */
@property (nonatomic, strong) UIImageView *blurView;
/**
 *  聊天按钮点击后生成的选项
 */
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
/**
 *  聊天按钮的直径
 */
@property (nonatomic, assign) CGGlyph length;

@end

@implementation YYBMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *mallStoryBoard = [UIStoryboard storyboardWithName:@"YYBMallController" bundle:nil];
    UINavigationController *otcMallController = [mallStoryBoard instantiateViewControllerWithIdentifier:@"NAV"];
    
    UINavigationController *classesController = [[UINavigationController alloc]initWithRootViewController:[[YYBClassesController alloc]init]];
    UINavigationController *nearByController = [[UINavigationController alloc]initWithRootViewController:[[YYBNearByController alloc]init]];
    //UINavigationController *chatController = [[UINavigationController alloc]initWithRootViewController:[[YYBChatController alloc]init]];
    UINavigationController *userController = [[UINavigationController alloc]initWithRootViewController:[[YYBUserController alloc]init]];
    
    self.viewControllers = @[otcMallController,classesController,[UIViewController new],nearByController, userController];

    NSArray * titles = @[@"主页",@"分类",@"",@"附近",@"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    self.tabBar.items[1].enabled = YES;
    self.tabBar.items[2].enabled = NO;
    
    /**
     *  A 添加tabbar中间的聊天按钮
     */
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    /**
     *  C kvo监察是否被点击
     */
    [self.tabBar addObserver:self
                  forKeyPath:@"selectedItem"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    // 聊天相关
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 120;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    NSArray *buttonTitles = @[@"售前咨询", @"售后咨询"];
    NSArray *buttonImages = @[@"tweetEditing", @"picture"];
    int buttonColors[] = {0xe69961, 0x0dac6b};
    
    for (int i = 0; i < 2; i++) {
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:buttonTitles[i]
                                                                   image:[UIImage imageNamed:buttonImages[i]]
                                                                andColor:[UIColor colorWithHex:buttonColors[i]]];
        
        optionButton.frame = CGRectMake((_screenWidth/4 * (i%2*2+1) - (_length+16)/2),
                                        _screenHeight + 150 ,
                                        _length + 16,
                                        _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];
        
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        
        /**
         B 处理点击事件
         */
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }

}


#pragma mark  C kvo监察是否被点击
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedItem"]) {
        if(self.isPressed) {[self buttonPressed];}
    }
}


#pragma mark  A 添加tabbar中间的聊天按钮
-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //转换坐标系，self.tabBar.center 从self.view坐标系转换到self.tabBar坐标系，得到转换后的点；
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}

- (void)buttonPressed
{
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    _isPressed = !_isPressed;
}


- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        [self removeBlurView];
        
        //物理引擎
        [_animator removeAllBehaviors];
        for (int i = 0; i < 2; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/4 * (i%2*2+1),
                                                                                                      _screenHeight + 200 )];
            attachment.damping = 0.65;//damp 阻尼
            attachment.frequency = 4;     //频率
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 2; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/4 * (i%2*2+1),
                                                                                                      _screenHeight - 200 )];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}

/**
 *  移除所有蒙板
 */
- (void)removeBlurView
{
    _centerButton.enabled = NO;
    
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             _dimView = nil;
                             
                             [self.blurView removeFromSuperview];
                             self.blurView = nil;
                             _centerButton.enabled = YES;
                         }
                     }];
}

/**
 *  添加蒙板
 */
- (void)addBlurView
{
    _centerButton.enabled = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 270, screenSize.width, screenSize.height);
    
    //** 生成蒙板图片，然后裁切留下想要的范围
    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];
    
    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
    _blurView.frame = cropRect;
    _blurView.userInteractionEnabled = YES;
    [self.view addSubview:_blurView];
    
    //** 生成整块黑色蒙板
    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
    [self.view insertSubview:_dimView belowSubview:self.tabBar];
    
    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if (finished) {_centerButton.enabled = YES;}
                     }];
}

#pragma mark -  B 处理点击事件
/**
 *  功能键被tap后执行的动作
 *
 *  @param recognizer 附带点击的那个手势，可以附带传递被点击的对象
 */
- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 0: {
            UIViewController *oneVC = [UIViewController new];
            UINavigationController *oneNav = [[UINavigationController alloc] initWithRootViewController:oneVC];
            [self.selectedViewController presentViewController:oneNav animated:YES completion:nil];
            break;
        }
        case 1: {
            UIViewController *twoVC = [UIViewController new];
            UINavigationController *twoNav = [[UINavigationController alloc] initWithRootViewController:twoVC];
            [self.selectedViewController presentViewController:twoNav animated:YES completion:nil];
            break;
        }
        default: break;
    }
    
    [self buttonPressed];
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
