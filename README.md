# YLBanner
YLBanner是一个很好用的可高度配置循环轮播图开源项目，可同时支持本地图片和网络图片，支持自定义轮播时间和是否自动轮播，支持自定义默认图，不会滑倒一半卡住图片，没有内存泄漏，集成简单。喜欢的朋友记得分享和star哦，方便更多的朋友使用。

使用方法：将最里面的YLBanner文件夹拖自工程即可，集成代码如下：

YLBannerView *bannerFirst = [[YLBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) images:imagesFirst];
或
YLBannerView *bannerFirst = [[YLBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
[bannerFirst setImages:imagesFirst];


bannerFirst.shouldAuto = YES;//是否自动轮播
bannerFirst.autoScrollDelay = 3;//轮播时间间隔
bannerFirst.delegate = self;//设置点击图片代理
[bannerFirst setPlaceHolder:[UIImage imageNamed:@"placeHolder"]];//自定义默认图


其中，imagesFirst为轮播图实体对象数组。


注意：项目中使用到了第三方库SDWebImage加载图片，网络图片加载需要导入该框架。


