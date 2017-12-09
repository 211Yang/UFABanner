# UFABanner

# 项目简介
UFABanner是一个简单、易用、可高度配置循环轮播图开源组件，可同时支持本地图片和网络图片，支持自定义轮播时间和是否自动轮播，支持自定义默认图，不会滑倒一半卡住图片，没有内存泄漏。

# 项目截图

![image](https://github.com/211Yang/UFABanner/blob/master/UFABanner/screenshots.gif )

# 集成
方法一：手动集成
将最里面的UFABanner文件夹拖自工程即可，

方法二：pods集成
使用cocopods命令  pod 'UFABanner'


# 使用方法

UFABannerView *bannerFirst = [[UFABannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) images:imagesFirst];

或

UFABannerView *bannerFirst = [[UFABannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];

[bannerFirst setImages:imagesFirst];


bannerFirst.shouldAuto = YES;//是否自动轮播

bannerFirst.autoScrollDelay = 3;//轮播时间间隔

bannerFirst.delegate = self;//设置点击图片代理

[bannerFirst setPlaceHolder:[UIImage imageNamed:@"placeHolder"]];//自定义默认图


其中，imagesFirst为轮播图实体对象数组。


# 注意

项目中使用到了第三方库SDWebImage加载图片，网络图片加载需要导入该框架。

# issues

大家使用过程中，遇到任何疑问或建议可随时给我提issues,我会第一时间处理，觉得好用的朋友记得分享和star哦，方便更多的朋友使用。


