//
//  ViewController.m
//  UFABanner
//
//  Created by Yang Lin on 2017/8/16.
//  Copyright © 2017年 Yang Lin. All rights reserved.
//

#import "ViewController.h"
#import "UFABannerView.h"
#import "BannerModel.h"
@interface ViewController ()<UFABannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBanner];
}


- (void)setUpBanner
{
    NSArray *urlsFirst = @[@"http://img.juimg.com/tuku/yulantu/121010/240425-12101021460537.jpg", @"http://pic.58pic.com/58pic/13/87/72/73t58PICjpT_1024.jpg", @"http://pic.58pic.com/58pic/13/46/13/86B58PIC5kQ_1024.jpg", @"http://images.takungpao.com/2015/0624/20150624025338794.jpg", @"http://pic.58pic.com/58pic/17/50/36/22758PICsYm_1024.jpg"];
    NSArray *urlsSecond = @[@"banner_0", @"banner_1", @"banner_2", @"banner_3", @"banner_4"];
    
    NSMutableArray *imagesFirst = [NSMutableArray array];
    NSMutableArray *imagesSecond = [NSMutableArray array];
    
    for (int i = 0; i< 5; i++) {
        
        BannerModel *model = [[BannerModel alloc] init];
        model.imageUrl = urlsFirst[i];
        [imagesFirst addObject:model];
    }
    
    for (int i = 0; i< 5; i++) {
        
        BannerModel *model = [[BannerModel alloc] init];
        model.imageUrl = urlsSecond[i];
        [imagesSecond addObject:model];
    }
    
    UFABannerView *bannerFirst = [[UFABannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) images:imagesFirst];
    bannerFirst.shouldAuto = YES;
    bannerFirst.autoScrollDelay = 3;
    bannerFirst.delegate = self;
    
    UFABannerView *bannerSecond = [[UFABannerView alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 200) images:imagesSecond];
    bannerSecond.delegate = self;

    [self.view addSubview:bannerFirst];
    [self.view addSubview:bannerSecond];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UFABannerViewDelegate

- (void)scrollView:(UFABannerView *)scrollView didSelectImageWithModel:(BannerModel *)model
{
    NSLog(@"点击了%@",model);
}

@end
