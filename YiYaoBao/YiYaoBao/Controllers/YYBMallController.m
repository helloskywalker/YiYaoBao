//
//  YYBMallController.m
//  YiYaoBao
//
//  Created by 泥红 on 16/4/21.
//  Copyright © 2016年 YYBTeam. All rights reserved.
//

#import "YYBMallController.h"

#define kScrollViewSize (_adScrollView.frame.size)
#define kImageCount 3

@interface YYBMallController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation YYBMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    
    // 设置控制器成为scrollView的代理
    _adScrollView.delegate = self;
    
    [self setupScrollView];
    
    
    [self setupPageControll];
    
    // 创建计时器
    [self initImageTimer];
    
}


#pragma mark -  scrollView设置
- (void)setupScrollView {
       for (int i = 0; i < kImageCount; i++) {
       
        CGFloat imageViewX = i * kScrollViewSize.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, kScrollViewSize.width, kScrollViewSize.height)];
        
        //NSString *imageName = [NSString stringWithFormat:@"img_%02d",i + 1];
        
           if (i==0) {
               imageView.backgroundColor = [UIColor redColor];
           } if (i==1) {
               imageView.backgroundColor = [UIColor blueColor];
           }  else {
               imageView.backgroundColor = [UIColor purpleColor];
           }
        
        [_adScrollView addSubview:imageView];
    }
    
    // 设置 scrollView的contentSize
    _adScrollView.contentSize = CGSizeMake(kImageCount * kScrollViewSize.width, 0);
    
    // 隐藏滚动指示器
    _adScrollView.showsHorizontalScrollIndicator = NO;
    
    // scrollView的分页效果 (根据scrollView的宽度进行分页的)
    _adScrollView.pagingEnabled = YES;
    
}


#pragma mark -  设置pageControll
- (void)setupPageControll {

    _pageControl.numberOfPages = kImageCount;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.currentPage = 0;
}



#pragma mark -  创建计时器
- (void)initImageTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:2
                                              target:self
                                            selector:@selector(pageChange)
                                            userInfo:nil
                                             repeats:YES];
    
    // [_timer fire];  调用fire ， 这个计时器会立即执行， 不会等待 interval 设置的时间
    
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)pageChange {

    CGPoint offset = _adScrollView.contentOffset;

    NSInteger currentPage = _pageControl.currentPage;
    
    if (currentPage == kImageCount-1) {
        // currentPage是从0开始的，到了最后一张, 再次点击的时候， 到第一张图片的位置
        // currentPage 修改为0
        currentPage = 0;

        offset = CGPointZero;
        
    } else {
        
        currentPage += 1;
        
        offset.x += kScrollViewSize.width;
    }
    
    // 4. 赋值回去
    _pageControl.currentPage = currentPage;
    [_adScrollView setContentOffset:offset animated:YES];
    
}

#pragma mark scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 让计时器无效
    [_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_timer fire];
    
    [self initImageTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // currentPage = scrollView.contentOffset.x / kScrollViewSize.width
    
    _pageControl.currentPage = scrollView.contentOffset.x / kScrollViewSize.width;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
