# SpringAnimationDemo2
![bounce](http://upload-images.jianshu.io/upload_images/1319710-9a26ccb3e9d384cc.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>弹性动画一直以来都深深地吸引我，随着知识储备增多，渐渐探索出一套弹性动画的实现原理。

# 简介
本文将从零开始，一步步解析弹性动画原理，包教包会。[本文Demo](https://github.com/xietao3/SpringAnimationDemo2)简单地封装了一个动画库来测试，支持``UIView``的三种动画类型：``Size``、``Position``、``Scale``，动画运动曲线有：``bounce``、``easeInOut``。``CALayer``动画暂不支持。

# 运动曲线
从初中开始，我们就开始接触正弦曲线、余弦曲线，现在真的排上用场了(😭后悔当初数学没学好)。我们可以通过对正弦余弦做一些处理，来得到动画的运动曲线。弹性动画稍微复杂一些，主要分为两部分，一是 **波动(波形)** 、二是 **衰减** ，将二者结合就能得到我们想要的动画运动曲线。

### 1. 淡入淡出运动曲线
** 正弦曲线 **，``Y``坐标随着``X``坐标的变化而变化，新手乍一看，这跟动画根本没有半毛钱关系，我们还需要进行精加工处理，才能使用。
![正弦曲线](http://upload-images.jianshu.io/upload_images/1319710-05f96d224992fa2b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/320)

不管是弹性动画还是线性动画，我们都有一个起点和终点，弹性动画不同的是它的值在某些时候会超越最终值，然后又回到最终值。总之，我们需要一个绝对起点值为0，绝对终点值为1，``progress``值范围在0~1。举个栗子🌰，我们要从``(100,100)``移动到``(200，200)``，x和y初始值和最终值相差100，减去初始值，这0~100就是``progress``的从0~1的过程。

不管是正弦还是余弦，经过我们的翻转位移之后都能得到一个从0到1的曲线：

![正弦函数 0~1](http://upload-images.jianshu.io/upload_images/1319710-932bcddfc86cbcd2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)


![余弦函数 0~1](http://upload-images.jianshu.io/upload_images/1319710-38c4baf555b0d3b3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)

这就是``easeInOut``动画的运动曲线图，在开始和结尾比较平缓，而中间波动较大，即淡入淡出的效果。
![easeInOut
](http://upload-images.jianshu.io/upload_images/1319710-87bc42c4c6c36e52.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)


### 2. 弹性运动曲线
**a. 衰减曲线 **弹性动画中从0~1的过程主要由指数衰减函数来控制，指数倍数越小，衰减速度越快，在动画参数中相当于 **弹性阻尼**。

![指数衰减函数](http://upload-images.jianshu.io/upload_images/1319710-b21e3f89d1e68df9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)

![指数衰减曲线](http://upload-images.jianshu.io/upload_images/1319710-6264f2abd3705ad7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

**b. 余弦曲线 **在这里的我们使用余弦来作为弹性动画波动曲线，``x``倍数值越大，**振动频率** 越快。
![余弦振幅函数](http://upload-images.jianshu.io/upload_images/1319710-92b55a2835db51a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)


![余弦曲线](http://upload-images.jianshu.io/upload_images/1319710-32a45f4280d12cb8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

**c. 衰减的余弦曲线 **衰减函数和余弦函数相乘，得到初步的弹性运动曲线。

![衰减的余弦函数](http://upload-images.jianshu.io/upload_images/1319710-e5472a6284d81f95.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)

![衰减的余弦曲线(浅色线为衰减曲线)](http://upload-images.jianshu.io/upload_images/1319710-970a17b72672348a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

**d. 0~1的衰减的余弦曲线 **，将曲线函数翻转(加负号)后上移1(+1)即可得到最终弹性曲线，曲线从0开始，``y``值随着``x``值变化波动后渐渐平稳归于1。``x``值递增越快，** 动画速度 **越快，整个动画所需时间越短。

![0~1的衰减的余弦函数](http://upload-images.jianshu.io/upload_images/1319710-86c4baafb1891680.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![0~1的衰减的余弦曲线](http://upload-images.jianshu.io/upload_images/1319710-2d667b4c5eb53f3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

# 通过运动曲线生成动画
### 1. CADisplayLink
``CADisplayLink``是一个能让我们以和屏幕刷新率相同的频率将动画显示到屏幕上的定时器。通过定时器我们利用当前动画``progress``得出运动曲线当前``Y``的值，即代码中的``timeLineY``。

举个例子，移动``position``的动画，是用动画的``startPoint+(endPoint-startPoint)*timeLineY``=动画当前``progress``的的``position``，当按顺序将这些``position``显示出来就形成了我们需要的动画。


```
// 新建一个displayLink
self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplayLink)];

- (void)updateDisplayLink {
    // 获取弹性动画曲线当前进度的曲线的Y坐标
    float timeLineY = [self getSpringAnimation:animation springOffset:animation.progress];
    // +进度
    animation.progress+=animation.speed;
    // 使用Y坐标值 算出View当前位置
    CGRect tempFrame = animationView.frame;
    NSValue *fromValue = animation.fromValue;
    CGPoint startPoint = fromValue.CGPointValue;
    NSValue *toValue = animation.toValue;
    CGPoint endPoint = toValue.CGPointValue;
      
    tempFrame.origin.x = startPoint.x+(endPoint.x - startPoint.x)*timeLineY;
    tempFrame.origin.y = startPoint.y+(endPoint.y - startPoint.y)*timeLineY;
    animationView.frame = tempFrame;
}
```

下面将会提到各种动画是如何获取当前``timeLineY``，提供了相应的曲线函数、代码和动画效果图。

### 2. 非曲线动画
非曲线意思就是0~1运动轨迹是直线递增，整个动画会显得比较生硬。

函数：y=x

动画效果：
![line_position.gif](http://upload-images.jianshu.io/upload_images/1319710-d5a452b8df816080.gif?imageMogr2/auto-orient/strip)

![line_scale.gif](http://upload-images.jianshu.io/upload_images/1319710-7f1cc59b4a09e323.gif?imageMogr2/auto-orient/strip)

### 3. 淡入淡出动画
EaseInOut曲线在动画在起点和终点的位置递增比较慢，动画开启和结束的地方比较平滑。

曲线函数：
![余弦函数 0~1](http://upload-images.jianshu.io/upload_images/1319710-38c4baf555b0d3b3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)
转换成OC代码：
```
- (CGFloat)getEaseInOutAnimation:(FDSpringAnimation *)animation springOffset:(CGFloat)x {
    result = MIN(-cos(M_PI*animation.progress)/2.0+0.5, 1.000);
    return result;
}
```
动画效果：

![easeInOut_position.gif](http://upload-images.jianshu.io/upload_images/1319710-ab1b9e446018a073.gif?imageMogr2/auto-orient/strip)

![easeInOut_scale.gif](http://upload-images.jianshu.io/upload_images/1319710-490bd047bffe438e.gif?imageMogr2/auto-orient/strip)

### 4. 弹性动画
弹性动画增加了2个参数，分别是阻尼:``damping``和波动频率:``frequency``。

曲线函数：
![0~1的衰减的余弦函数](http://upload-images.jianshu.io/upload_images/1319710-86c4baafb1891680.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
转换成OC代码：
```
- (CGFloat)getSpringAnimation:(FDSpringAnimation *)animation springOffset:(CGFloat)x {
    result = -pow(2, -animation.damping * x) * cos(animation.frequency*x)+1;
}
```  
动画效果：
![bounce_position.gif](http://upload-images.jianshu.io/upload_images/1319710-84cf1273d105f391.gif?imageMogr2/auto-orient/strip)

![bounce_scale.gif](http://upload-images.jianshu.io/upload_images/1319710-0ccc79bf30a3f7af.gif?imageMogr2/auto-orient/strip)


# 拓展
上面的内容基本可以实现一个简单的弹性动画，[本文Demo](https://github.com/xietao3/SpringAnimationDemo2)在此基础上增加了``同时多个动画运行``、``completionBlock``等功能，``正在运行的动画暂停``，``移除正在运行的动画``、``替换正在运行的动画``等功能待加入。

本文所有曲线通过``Grapher``绘画。

![Grapher](http://upload-images.jianshu.io/upload_images/1319710-84e3e8dc286b96e7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/340)

# 总结
以前一直都是直接用``POP``或者``UIView``动画实现弹性动画的效果，对于原理实现不甚了解，但是一直保持着好奇心，终于是自己实现了一套方案(路子比较野😂)。

**个人水平有限，欢迎发表建议。**
