# ZHNCarouselView
无限滚动 轮播 不依赖第三方 自带缓存 下载 自动处理图片的拉伸问题 因为系统的contentmode感觉老是缺少点什么，于是我自己写了个处理图片的category，但是如果你不把处理完的图片存起来的话相当于要经常去异步绘制，感觉吃cpu性能。所以借鉴sdweimage写了个图片下载和缓存的框架。但是这个下载的框架比较简易，所以在特定的一些情况下还是会存在些许问题。但是用在轮播这里基本没啥问题。于是我就写了这个框架配合以前写的无限轮播，但是问题两者配合起来还是问题有点严重，因为以前的思路要经常设contentoffset 会有一闪一闪的效果。。。痛定思痛 现在用了uicollectionview来实现，虽然理论上不是无限滚动，但是实际情况就是基本不可能滑到头。。。。。。。。今天头好痛~不知道是不是用脑过度了啊。。。。。。。

-----------------------------------------华丽的分割线-----------------------------------------------

######我最近对这个轮播做了点修改和加了点功能。还是放几张图片展示一些基本效果好了

`ZHN_contentModeTop` 对应
![top](https://raw.githubusercontent.com/zhnnnnn/ZHNCarouselView/master/top.png)
`ZHN_contentModeCenter` 对应
![center](https://raw.githubusercontent.com/zhnnnnn/ZHNCarouselView/master/center.png)
`ZHN_contentModeBottom` 对应
![bottom](https://raw.githubusercontent.com/zhnnnnn/ZHNCarouselView/master/bottom.png)


看这几张图片大概能看出来一些效果，还有left right 模式在这个尺寸的图片下显示不太明显的就不截图了。。。里面的图片缓存下载是我仿照sdwebImage写的一个简陋版本，在这种地方显然是够用了。具体什么用法应该看demo就一目了然了而且我对各种属性的设置都写了注释了。虽然没什么人看或者用。。但是如果你有幸能看到这个库有幸能用到这个库，提点意见给个star我还是很开心的~~~~~~~~~~~~~~~~
