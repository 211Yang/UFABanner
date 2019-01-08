//
//  UFABannerView.m
//  UFABanner
//
//  Created by Yang Lin on 2017/8/16.
//  Copyright © 2017年 Yang Lin. All rights reserved.
//

#import "UFABannerView.h"
#import "UIImageView+WebCache.h"
#import "BannerModel.h"
#import "NSTimer+Action.h"

#define kScrollWidth self.frame.size.width
#define kScrollHeight self.frame.size.height

@interface UFABannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scroll;//滑动视图
@property (nonatomic, copy)NSArray *imageViews;//图片控件数组
@property (nonatomic, strong)UIImageView *firstImage;//第一张图片
@property (nonatomic, strong)UIImageView *secondImage;//第二种图片
@property (nonatomic, strong)UIImageView *thirdImage;//第三张图片
@property (nonatomic, assign)NSInteger maxImageCount;//显示的图片数

@property (nonatomic, strong)UIPageControl *pageControll;//分页指示控件
@property (nonatomic, weak)NSTimer *timer;//定时器
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;//图片点击手势

@end
@implementation UFABannerView

#pragma mark - life cicle


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageContentMode = UIViewContentModeScaleAspectFit;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame images:nil];
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageContentMode = UIViewContentModeScaleAspectFit;
        [self setImages:images];
        
    }
    
    return self;
}


- (void)setUp
{
    
    _shouldAuto = YES;
    _autoScrollDelay = 5;
    if (!_placeHolder) {
        _placeHolder = [UIImage imageNamed:@"placeHolder"];
    }
    
    if (_images.count > 1) {
        
        self.imageViews = @[self.firstImage,self.secondImage,self.thirdImage];
        [self setUpTimer];
    }else if (_images.count == 1)
    {
        self.imageViews = @[self.firstImage];
    }
    
    [self.scroll setContentSize:CGSizeMake(kScrollWidth*self.imageViews.count, kScrollHeight)];
    
    [self.scroll removeFromSuperview];
    [self addSubview:self.scroll];
    
    self.pageControll.numberOfPages = _images.count;
    
    [self.pageControll removeFromSuperview];
    [self addSubview:self.pageControll];
    
    for (UIImageView *imageview in self.imageViews) {
        
        [_scroll addSubview:imageview];
    }
    
    [self resetScroll];
    
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow
{
    if (newWindow) {
        
        //回到当前窗口时重置contenOffset,确保图片居中，四舍五入
        NSInteger index =  round(_scroll.contentOffset.x/kScrollWidth);
        
        [_scroll setContentOffset:CGPointMake(kScrollWidth * index, 0) animated:YES];
        
        [_timer resumeTimerAfterTimeInterval:_autoScrollDelay];
    }else
    {
        [_timer pauseTimer];
    }
}

- (void)dealloc
{
    [self removeTimer];
    
    [_scroll removeGestureRecognizer:_tapGesture];
    
}


#pragma mark - Event


//图片点击手势
- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:didSelectImageWithModel:)]) {
        
        [self.delegate scrollView:self didSelectImageWithModel:_images[_currentIndex]];
    }
}


#pragma mark - pravite method
//设置当前现实下标
- (void)changeImageWithOffset:(CGFloat)offset
{
    
    if (offset >= 2*kScrollWidth) {
        
        _currentIndex ++;
        
        if (_currentIndex == _maxImageCount) {
            _currentIndex = 0;
            
        }
        [self resetScroll];
        
    }
    
    if (offset <= 0) {
        
        _currentIndex --;
        
        if (_currentIndex == -1) {
            
            _currentIndex = _maxImageCount-1;
        }
        [self resetScroll];
        
    }
    
}


//重置图片展示
- (void)resetScroll
{
    
    if (_imageViews.count > 0) {
        
        self.pageControll.currentPage = _currentIndex;
        
        if (_imageViews.count == 1) {
            
            BannerModel *model = [_images firstObject];
            
            if ([[[NSURL URLWithString:model.imageUrl] scheme] isEqualToString:@"http"] || [[[NSURL URLWithString:model.imageUrl] scheme] isEqualToString:@"https"]) {
                
                [[_imageViews firstObject] sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:_placeHolder];
            }else
            {
                [[_imageViews firstObject] setImage:[UIImage imageNamed:model.imageUrl]];
            }
            
            [_scroll setContentOffset:CGPointMake(0, 0)];
            
        }else
        {
            
            NSArray *imageUrls;
            if (_currentIndex == 0) {
                
                imageUrls = @[[_images lastObject],_images[_currentIndex],_images[_currentIndex +1]];
                
            }else if (_currentIndex == _maxImageCount - 1)
            {
                imageUrls = @[_images[_currentIndex-1],_images[_currentIndex],_images[0]];
                
            }else
            {
                imageUrls = @[_images[_currentIndex-1],_images[_currentIndex],_images[_currentIndex+1]];
            }
            
            for (NSInteger i = 0; i< _imageViews.count; i++) {
                
                UIImageView *imageview = _imageViews[i];
                BannerModel *model = imageUrls[i];
                
                if ([[[NSURL URLWithString:model.imageUrl] scheme] isEqualToString:@"http"] || [[[NSURL URLWithString:model.imageUrl] scheme] isEqualToString:@"https"]) {
                    
                    [imageview sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:_placeHolder];
                }else
                {
                    [imageview setImage:[UIImage imageNamed:model.imageUrl]];
                }
                
            }
            [_scroll setContentOffset:CGPointMake(kScrollWidth, 0)];
            
        }
    }
    
}

//点击切换页面
- (void)changePage
{
    NSInteger index =  _scroll.contentOffset.x/kScrollWidth;
    
    //滑动时点击切换不做任何操作
    if (index * kScrollWidth != _scroll.contentOffset.x) {
        
        return;
    }
    [_timer resumeTimerAfterTimeInterval:_autoScrollDelay];
    
    _currentIndex = _pageControll.currentPage;
    [self resetScroll];
    
}


//创建定时器
- (void)setUpTimer
{
    if (_shouldAuto && _autoScrollDelay>=0.5) {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    }
}

//定时滑动
- (void)timeAction
{
    
    NSInteger index =  _scroll.contentOffset.x/kScrollWidth;
    [_scroll setContentOffset:CGPointMake(kScrollWidth * (index +1), 0) animated:YES];
    
}

//移除定时器
- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrolltoIndex:(NSInteger)index
{
    //    [_scroll setContentOffset:CGPointMake(kScrollWidth*(index%self.images.count), 0)];
    //    [self changeImageWithOffset:kScrollWidth*(index)];
    
    _currentIndex = index;
    [self resetScroll];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_timer resumeTimerAfterTimeInterval:self.autoScrollDelay];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [_timer resumeTimerAfterTimeInterval:_autoScrollDelay];
    return YES;
}

#pragma mark - setter and getter


- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    }
    
    return _tapGesture;
}


- (UIScrollView *)scroll
{
    if (!_scroll) {
        
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.delegate = self;
        _scroll.pagingEnabled = YES;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.bounces = NO;
        
        [_scroll addGestureRecognizer:self.tapGesture];
        
    }
    
    return _scroll;
}

- (UIPageControl *)pageControll
{
    if (!_pageControll) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScrollHeight - 38, kScrollWidth, 20)];
        [_pageControll addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
        _pageControll.hidesForSinglePage = YES;
    }
    
    return _pageControll;
}

- (UIImageView *)firstImage
{
    if (!_firstImage) {
        
        _firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScrollWidth, kScrollHeight)];
        [_firstImage setBackgroundColor:[UIColor whiteColor]];
        _firstImage.clipsToBounds = YES;
    }
    _firstImage.contentMode = self.imageContentMode;
    
    return _firstImage;
}

- (UIImageView *)secondImage
{
    if (!_secondImage) {
        
        _secondImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScrollWidth, 0, kScrollWidth, kScrollHeight)];
        [_secondImage setBackgroundColor:[UIColor whiteColor]];
        _secondImage.clipsToBounds = YES;
    }
    _secondImage.contentMode = self.imageContentMode;
    
    return _secondImage;
}

- (UIImageView *)thirdImage
{
    if (!_thirdImage) {
        
        _thirdImage = [[UIImageView alloc] initWithFrame:CGRectMake(2*kScrollWidth, 0, kScrollWidth, kScrollHeight)];
        [_thirdImage setBackgroundColor:[UIColor whiteColor]];
        _thirdImage.clipsToBounds = YES;
    }
    _thirdImage.contentMode = self.imageContentMode;
    
    return _thirdImage;
}

- (NSTimer *)timer
{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.autoScrollDelay
                                                   block:^{
                                                       __strong typeof(self) strongSelf = weakSelf;
                                                       [strongSelf timeAction];
                                                   }
                                                 repeats:YES];
    }
    
    return _timer;
}

- (void)setImages:(NSArray *)images
{
    
    if (_images != images) {
        _images = [images copy];
        _maxImageCount = images.count;
        
        if (_maxImageCount>0) {
            
            [self setUp];
        }
    }
}

- (void)setShouldAuto:(BOOL)shouldAuto
{
    
    if (_shouldAuto != shouldAuto) {
        
        _shouldAuto = shouldAuto;
        //自动轮播关闭时移除定时器
        if (!_shouldAuto) {
            
            [self removeTimer];
        }
    }
    
}

- (void)setAutoScrollDelay:(NSTimeInterval)autoScrollDelay
{
    if (_autoScrollDelay != autoScrollDelay) {
        
        _autoScrollDelay = autoScrollDelay;
        
        //设置轮播时间后重置定时器
        [self removeTimer];
        [self setUpTimer];
    }
    
}


@end

