
### 一、Dynamics简介

##### 1.1、简介：
Dynamics 是UIKit从**iOS 7.0**引入的，旨在将基础的动画附加到视图上。也就是说利用Dynamics可以让视图实现一些基于现实物理的动画效果。当然通过对多种物理效果的叠加可以实现复杂炫酷的效果。文章最后会展示它的一些具体的应用。
- 注意：UIKit动力学的引入，并不是为了替代CA或者UIView动画，在绝大多数情况下CA或者UIView动画仍然是最有方案，只有在需要引入逼真的交互设计的时候，才需要使用UIKit动力学它是作为现有交互设计和实现的一种补充。
##### 1.2、其它仿真引擎：

- BOX2D:C语言框架，免费
- Chipmunk:C语言框架免费，其他版本收费

### 二、Dynamics四个重要概念
- **Dynamic Animators**: 一个可以提供所有相关物理特性和 Dynamic Items动画效果的对象，并且为这些Dynamic Items动画效果提供相应的环境。

- **Behaviors**: 物理特性，目前主要包括如下图
![Behavior.png](https://upload-images.jianshu.io/upload_images/1846524-93d4086c1dc87019.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


他们共同的父类是UIDynamicBehavior。因为有共同父类，所以有共同的一个回调属性**action**，它在执行到每一步动画时都会调用，非常有用。

- **Dynamic Items**: 动力学元素，是任何遵守了UIDynamicItem协议的对象，从iOS 7开始，UIView和UICollectionViewLayoutAttributes默认实现协议。通俗来说就是运用物理特性的目标。

- **Animation Regions**: Dynamic Item可以作用的范围。

### 三、Behaviors的演示
在具体的特性演示之前，来总结下如何使用这些特性
- ###### step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
- ###### step2、 初始化所有需要的特性(上述中的物理特性)
- ###### step3、 将每个特性关联到所需要的视图上(addItem,有些特性是在初始化的时候设置)
- ###### step4、 UIDynamicAnimator添加所有的特性


此处先附上利用重力感应做出来的综合性示例：
![示例.gif](https://upload-images.jianshu.io/upload_images/1846524-28f4838d42ccb9e8.gif?imageMogr2/auto-orient/strip)


##### UIDynamicItemBehavior的相关属性讲解：

- allowsRotation：bool类型值，设定UIDynamicItem是否自身旋转，默认true
- angularResistance：旋转阻力，默认0，值越大，阻力。
- density：密度，默认值1。
- elasticity：弹性。范围0-1(接近0，弹性越小，接近1弹性越大)。默认值1。
friction：摩擦力。范围0-1(接近0，摩擦力越小，接近1摩擦力越大)。默认值1
- resistance：线性阻力。默认值0.
- isAnchored：bool类型值，指定动力项是否固定在当前位置。被固定的动力项参与碰撞时不会被移动，而是像边界一样参与碰撞。默认值是NO。
下图展示elasticity为1的效果，其它属性自行实验：
![elasticity.gif](https://upload-images.jianshu.io/upload_images/1846524-bdc9503b9beba06f.gif?imageMogr2/auto-orient/strip)

##### 3.1、重力特性UIGravityBehavior
示例图：
![UIGravityBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-a975238001c63ff6.gif?imageMogr2/auto-orient/strip)

相关属性：
- **gravityDirection**：重力方向。在利用重力感应是非常有用
- **angle**：设置重力的角度。同时设置gravityDirection和angle，angle会生效，angle只在不持续性更改gravityDirection效果比较明显。但是如果gravityDirection持续更改，angle只会在初始的时候有效。另外，angle是按顺时针方向设置。

示例代码：
```
override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(ballView)

    //step3、 将每个特性关联到相应的视图上(addItem)
    gravityBehavior.addItem(ballView)
    //step4、 UIDynamicAnimator添加所有的特性
    dynamicAnimator.addBehavior(gravityBehavior)
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var gravityBehavior: UIGravityBehavior = {
    let gravityBehavior = UIGravityBehavior()
    return gravityBehavior
}()
```
##### 3.2、碰撞检测UICollisionBehavior
示例图：
![UICollisionBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-36e5f7dce98aba3c.gif?imageMogr2/auto-orient/strip)

示例代码：
```
override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(ballView)

    //step4、 UIDynamicAnimator添加所有的特性
    [gravityBehavior, collisionBehavior].forEach(dynamicAnimator.addBehavior)

    //step3、 将每个特性关联到相应的视图上(addItem)
    gravityBehavior.addItem(ballView)
    collisionBehavior.addItem(ballView)
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var collisionBehavior: UICollisionBehavior = {
    let collisionBehavior = UICollisionBehavior()
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    collisionBehavior.collisionMode = .boundaries
    return collisionBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var gravityBehavior: UIGravityBehavior = {
let gravityBehavior = UIGravityBehavior()
    return gravityBehavior
}()
```

相关属性和方法：

- **translatesReferenceBoundsIntoBoundary**：bool类型，指定是否把reference view作为碰撞边界。默认为false。
- **setTranslatesReferenceBoundsIntoBoundary(with insets: UIEdgeInsets)**：设定某一区域作为碰撞边界。

- **addBoundary(withIdentifier identifier: NSCopying, for bezierPath: UIBezierPath)**：利用UIBezierPath绘制碰撞边界。

- **addBoundary(withIdentifier identifier: NSCopying, from p1: CGPoint, to p2: CGPoint)**：绘制碰撞一条直接边界。

##### 3.3、附着行为UIAttachmentBehavior
示例图：
![UIAttachmentBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-8b3240dc7b1c659d.gif?imageMogr2/auto-orient/strip)

示例代码：
```
override func viewDidLoad() {
super.viewDidLoad()
    view.addSubview(lineView)
    view.addSubview(ballView)
    lineView.frame = view.bounds
    //step4、 UIDynamicAnimator添加所有的特性
    dynamicAnimator.addBehavior(gravityBehavior)
    dynamicAnimator.addBehavior(attatchBehavior)
    //step3、 将每个特性关联到相应的视图上(addItem)
    gravityBehavior.addItem(ballView)
}

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let allTouches = event?.allTouches else { return }
    guard let touch = allTouches.first else { return }
    let point = touch.location(in: touch.view)

    attatchBehavior.action = { [weak self] in
        guard let self = self else {
            return
        }
        self.lineView.endPoint = self.view.convert(CGPoint(x: 25, y: 25), from: self.ballView)
        self.lineView.startPoint = point
    }
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var attatchBehavior: UIAttachmentBehavior = {
    //step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
    let attatchBehavior = UIAttachmentBehavior(item: ballView, attachedToAnchor: CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0))
    attatchBehavior.length = 180;
    //        attatchBehavior.damping = 1
    //        attatchBehavior.frequency = 0
    attatchBehavior.action = { [weak self] in
    guard let self = self else {
    return
    }
    self.lineView.endPoint = self.view.convert(CGPoint(x: 25, y: 25), from: self.ballView)
    self.lineView.startPoint = CGPoint(x: 50, y: 100)
    }
    return attatchBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var gravityBehavior: UIGravityBehavior = {
    let gravityBehavior = UIGravityBehavior()
    return gravityBehavior
}()
```

相关属性：
- **attachedBehaviorType**：连接类型（连接到锚点或视图）
- **items**：连接视图数组
- **anchorPoint**：连接锚点
- **length**：距离连接锚点的距离
只要设置了以下两个属性，即为弹性连接
- **damping**：振幅大小
- **frequency**：振动频率

##### 3.4、吸附行为UISnapBehavior
示例图：
![UISnapBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-2f86d8c7efc9822f.gif?imageMogr2/auto-orient/strip)

示例代码：
```
override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(ballView)
    //step4、 UIDynamicAnimator添加所有的特性
    dynamicAnimator.addBehavior(snapBehavior)
}

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let allTouches = event?.allTouches else { return }
    guard let touch = allTouches.first else { return }
    let point = touch.location(in: touch.view)
    snapBehavior.snapPoint = point
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var snapBehavior: UISnapBehavior = {
    //step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
    let snapBehavior = UISnapBehavior(item: ballView, snapTo: ballView.center)
    return snapBehavior
}()

```

相关属性：
- **snapPoint**：吸附点
- **damping**：阻尼系数，取值范围0-1，0抖动最大 ，1最小

##### 3.5、推动行为UIPushBehavior
示例图：
![5.gif.gif](https://upload-images.jianshu.io/upload_images/1846524-c6bccde801e2b903.gif?imageMogr2/auto-orient/strip)

示例代码：
```
override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(ballView)
    //step4、 UIDynamicAnimator添加所有的特性
    [pushBehavior, collisionBehavior, pushBehavior].forEach(dynamicAnimator.addBehavior)
    //step3、 将每个特性关联到相应的视图上(addItem)
    collisionBehavior.addItem(ballView)
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

lazy var collisionBehavior: UICollisionBehavior = {
    let collisionBehavior = UICollisionBehavior()
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    collisionBehavior.collisionMode = .boundaries
    return collisionBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var pushBehavior: UIPushBehavior = {
//step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
let pushBehavior = UIPushBehavior(items: [ballView], mode: UIPushBehavior.Mode.continuous)
//设置角度 和 力量大小
pushBehavior.setAngle(CGFloat(Double.pi / 4), magnitude: 10)
    return pushBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var gravityBehavior: UIGravityBehavior = {
//step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
let gravityBehavior = UIGravityBehavior(items: [ballView])
    return gravityBehavior
}()
```

相关属性：
- **active**：UIPushBehavior是否生效，默认true
- **magnitude**：推动的力量大小
- **angle**：推动的角度
- **mode**：推动的模式，是否是持续性的(作用在视图上的力是否是持续性的)。只读属性，在初始化时候设置
非持续性运行状态如下图：
![instantaneous.gif](https://upload-images.jianshu.io/upload_images/1846524-3445904286711872.gif?imageMogr2/auto-orient/strip)

##### 3.6、场行为UIFieldBehavior--模仿漩涡

相关属性：

- **region**：UIFieldBehavior作用的区域
- **position**：region的中心点
- **strength**：场的强度，值越大代表场的作用力越大(调试模式下现象是'线'越长)
- **falloff**: 用来计算在某个距离时的场强，默认为0
- **minimumRadius**：起作用的最小半径，配置falloff使用
- **direction**: 场的方向，正常情况是zero.只在 linearGravityFieldWithVector:direction和velocityFieldWithVector:direction类初始化的时候起作用
- **smoothness**：流畅度，正常情况是0，只在noiseFieldWithSmoothness:smoothness:animationSpeed和turbulenceFieldWithSmoothness:smoothness:animationSpeed起作用
- **animationSpeed**：动画速度，可以参考noiseFieldWithSmoothness:smoothness:animationSpeed和turbulenceFieldWithSmoothness:smoothness:animationSpeed起作用

示例图：
![UIFieldBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-60c5a5918a4137cf.gif?imageMogr2/auto-orient/strip)

示例代码：
```
override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(ballView)

    dynamicAnimator.setValue(true, forKey: "debugEnabled")
    //step4、 UIDynamicAnimator添加所有的特性
    dynamicAnimator.addBehavior(gravifyFieldBehavior)
    dynamicAnimator.addBehavior(vortexFieldBehavior)
    //step3、 将每个特性关联到相应的视图上(addItem)
    gravifyFieldBehavior.addItem(ballView)
    vortexFieldBehavior.addItem(ballView)
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var gravifyFieldBehavior: UIFieldBehavior = {
    let gravifyFieldBehavior = UIFieldBehavior.radialGravityField(position: view.center)
    gravifyFieldBehavior.region = UIRegion(size: view.bounds.size)
    gravifyFieldBehavior.position = view.center //region的中心点
    gravifyFieldBehavior.strength = 5  //这里的strength不宜过大，否则很容易重力大于漩涡的吸引力，而逃出漩涡，演示不成功
    gravifyFieldBehavior.falloff = 4.0 //falloff越大，作用区域越小
    gravifyFieldBehavior.minimumRadius = 50
    return gravifyFieldBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var vortexFieldBehavior: UIFieldBehavior = {
    let vortexFieldBehavior = UIFieldBehavior.vortexField()
    vortexFieldBehavior.region = UIRegion(radius: 200) //漩涡的区域不能太长，否则小球跑出屏幕外
    vortexFieldBehavior.strength = 0.005
    vortexFieldBehavior.position = view.center //region的中心点
    return vortexFieldBehavior
}()
```

##### 3.7、场行为UIFieldBehavior--弹性振子运行
示例图：
![UIFieldBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-e4c0877d3aad8337.gif?imageMogr2/auto-orient/strip)

示例代码：
```
override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(ballView)

    dynamicAnimator.setValue(true, forKey: "debugEnabled")
    //step4、 UIDynamicAnimator添加所有的特性
    dynamicAnimator.addBehavior(gravifyFieldBehavior)
    //step3、 将每个特性关联到相应的视图上(addItem)
    gravifyFieldBehavior.addItem(ballView)
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var gravifyFieldBehavior: UIFieldBehavior = {
    let gravifyFieldBehavior = UIFieldBehavior.springField()
    gravifyFieldBehavior.position = view.center //region的中心点
    gravifyFieldBehavior.region = UIRegion(size: view.bounds.size)
    gravifyFieldBehavior.strength = 1.5
    gravifyFieldBehavior.falloff = 1.0
    gravifyFieldBehavior.minimumRadius = 150
    return gravifyFieldBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
    let dynamicItemBehavior = UIDynamicItemBehavior()
    dynamicItemBehavior.addItem(ballView)
    dynamicItemBehavior.density = 0.5
    return dynamicItemBehavior
}()
```

##### 3.8、场行为UIFieldBehavior--线性重力运行
示例图：
![UIFieldBehavior.gif](https://upload-images.jianshu.io/upload_images/1846524-94c3e1dfbb4a27f1.gif?imageMogr2/auto-orient/strip)
示例代码:
```
override func viewDidLoad() {
super.viewDidLoad()
    view.addSubview(ballView)

    dynamicAnimator.setValue(true, forKey: "debugEnabled")
    //step4、 UIDynamicAnimator添加所有的特性
    dynamicAnimator.addBehavior(gravifyFieldBehavior)
    //step3、 将每个特性关联到相应的视图上(addItem)
    gravifyFieldBehavior.addItem(ballView)
}

//step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

//step2、 初始化所有需要的行为(上述中的物理特性)
//模拟水平重力运行
lazy var gravifyFieldBehavior: UIFieldBehavior = {
    let gravifyFieldBehavior = UIFieldBehavior.linearGravityField(direction: CGVector(dx: 0.5, dy: 0))
    gravifyFieldBehavior.position = view.center //region的中心点
    gravifyFieldBehavior.region = UIRegion(size: view.bounds.size)
    gravifyFieldBehavior.strength = 1.5
    gravifyFieldBehavior.falloff = 1.0
    gravifyFieldBehavior.minimumRadius = 150
    return gravifyFieldBehavior
}()

//step2、 初始化所有需要的行为(上述中的物理特性)
lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
    let dynamicItemBehavior = UIDynamicItemBehavior()
    dynamicItemBehavior.addItem(ballView)
    dynamicItemBehavior.density = 0.5
    return dynamicItemBehavior
}()

```

#### 参考文章
[UIKit Dynamics](https://developer.apple.com/documentation/uikit/animation_and_haptics/uikit_dynamics)
[2018-09-24-uifieldbehavior](https://github.com/NSHipster/articles/blob/master/2018-09-24-uifieldbehavior.md)
[一篇文章学会使用UIKit-Dynamics](https://github.com/pro648/tips/wiki/一篇文章学会使用UIKit-Dynamics)
