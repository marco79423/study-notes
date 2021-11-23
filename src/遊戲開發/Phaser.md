# Phaser

## 簡介

* 開源的遊戲框架，支援 WebGL 與 Canvas 渲染模式
* 是從 pixi 延伸出來的遊戲引擎 (不過好像不是了？)
* 可在電腦與手機的 Web 瀏覽器運行
* 可透過第三方工具轉成 iOS、Android Native App
* 支援 PWA（progressive web app）
* 允許使用 JavaScript 和 TypeScript 開發

## 基本元素

* Game
    * 遊戲主控制器，代表整個遊戲的環境設定。
* World
    * 一個遊戲裡只有一個World，所有的遊戲物件都在 World 裡。World 可以是任意尺寸，不受舞台邊界限制。（舞台即螢幕的畫面，受邊界限制）
* Scene
    * 每個場景有自己的系統，類似國家的概念。
    * 一個World裡可以有好幾個國家。
* Camera
    * 觀察遊戲世界的視野。有明確的位置與大小，並只渲染在視線範圍內的物件。

## 基本程式碼架構

```javascript
var config = {
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  scene: {
    preload: preload,
    create: create,
    update: update
  }
};

var game = new Phaser.Game(config);

function preload() {
}

function create() {
}

function update() {
}
```

## 設定相關

### 屬性 - type

* 渲染方式，分別有 `Phaser.AUTO`、`Phaser.CANVAS`、`Phaser.WEBGL`
* 設為 `Phaser.AUTO` 表示預設用 WebGL，若瀏覽器不支援則用 Canvas
* 推薦使用 `Phaser.AUTO`

#### 屬性 - width / height

* 設定生成的畫布尺寸，也是遊戲顯示用的分辨率
* 遊戲世界 (World) 可以是任意尺寸

#### 屬性 - physics

```javascript
const config = {
  // ...
  physics: {
    default: 'arcade',
    arcade: {
      gravity: {y: 300}, // 定義 arcade 世界裡的重力
      debug: false
    }
  },
}
```

* 使用的物理引擎
* 可選的物理引擎
    * Arcade
        * gravity 則定義 arcade 世界裡的重力。
        * arcade 世界是以「塊狀」為單位，只能以矩形框計算碰撞區域，精度低（方格跟方格的角如果碰到就會被視為碰到），但運算速度快。可實現簡單的碰撞、重力效果。
        * 轻量级高性能AABB式物理碰撞系统，AABB即Axis-aligned Bounded Rectangles，译为轴对称盒子，只能以矩形框计算碰撞区域，精度低，运算速度快，可以实现简单的碰撞、重力等效果。
        * 在 arcade 世界裡，物體分成動態與靜態兩種：
            1. 動態物體
                * 可透過速度(velocity)、加速度(acceleration)移動。
                * 可與物體發生反彈(bounce)、碰撞(collide)。（碰撞會受物體質量或其他因素影響）
            2. 靜態物體
                * 只有位置跟尺寸。重力對它沒影響，也不能設定速度。
                * 有東西跟它碰撞時不會動。
    * P2
        * 可以实现多种物理模型和物理特性，如Arcade所不能实现的多边形碰撞区域、弹簧、摩擦力、碰撞材质、反弹系数等，功能强大但也必然会使运算复杂、耗费性能。
    * Ninja
        * 可以实现平面、凹凸面、球面等的碰撞，物体在非平整面上碰撞时不会翻倒，跟忍者一样。

#### 屬性 - scene

* preload
    * 先將 assets 資料夾裡的場景 load 進來。假如場景很多，可以先預載場景，但不先顯示，以節省效率。
* create
    * 加入要用到的角色、場景，它們的命名要跟 preload 內定義的一樣。
* update
    * 不停在背景監聽，等待事件發生，event handler的概念。

## 資源加載場景 Preload

* 加載遊戲中所需的資源，呼唧 Loader

```javascript
function preload() {
  /* 預載場景圖，但先不顯示 */
  this.load.image('sky', 'assets/sky.png');
  this.load.image('ground', 'assets/platform.png');
  this.load.image('star', 'assets/star.png');
  this.load.image('bomb', 'assets/bomb.png');

  /* 預載角色sprite sheet，但先不顯示 */
  this.load.spritesheet('dude', 'assets/dude.png', {frameWidth: 32, frameHeight: 48});
}
```

## 內容生成場景 Create

```javascript
function create() {
  /* 指定加入物體之 x, y 座標 */
  this.add.image(400, 300, 'sky')

  /* 地板是靜態的，所以要設成 staticGroup（不希望破損）*/
  platforms = this.physics.add.staticGroup();

  /* 用 setScale() 設定比例，並以 refreshBody() 更新尺寸 */
  platforms.create(400, 568, 'ground').setScale(2).refreshBody();
  platforms.create(600, 400, 'ground');
  platforms.create(50, 250, 'ground');
  platforms.create(750, 220, 'ground');
}
```

* 在 Phaser 3 中，所有物件默認都是中心點
    * 可以用 `setOrigin` 改變
        * ```javascript
          this.add.image(0, 0, 'sky').setOrigin(0, 0)
          ```
        
### 新增 Sprite

```javascript
player = this.physics.add.sprite(100, 450, 'dude');

player.setBounce(0.2);  // 赋予0.2的一点点反弹（bounce）值。这意味它跳起后着地时始终会弹起那么一点点
player.setCollideWorldBounds(true);
```

### 物理系統

* Phaser支持多种物理系统，每一种都以插件形式运作，任何Phaser场景都能使用它们
* 物理精灵在生成时，即被赋予body（物体）属性，这个属性指向它的Arcade物理系统的Body。它表示精灵是Arcade物理引擎中的一个物体。

```javascript
// 在一个精灵上模仿重力效果，值越大你的对象感觉越重，下落越快
player.body.setGravityY(300)
```

```javascript
function collectStar (player, star)
{
    star.disableBody(true, true);

    score += 10;
    scoreText.setText('Score: ' + score);
}
```

### 文字

scoreText在create函数中构建：

```javascript
scoreText = this.add.text(16, 16, 'score: 0', { fontSize: '32px', fill: '#000' });
```

## 逐帧更新/循环处理的内容，如键盘、鼠标监控 Update


### 鍵盤控制

#### 只用到最常用的按鍵 (監聽常用鍵盤事件)

如果游戏只需要用到方向键和三个常用特殊按键Ctrl/，Shift/Alt，那么可以最简单的创建方向盘对象，在 create 中创建方向键对象：

```javascript
cursors = game.input.keyboard.createCursorKeys()
```

在 update 中实时监测方向键按下的情况，每一个方向键下面都带3个特殊按键的监测，分别是Ctrl(ctrlKey)，Shift(shiftKey)，Alt(altKey)。触发组合按键效果从操作习惯上约定，在特殊按键先按下的前提下才能生效。

```javascript
if (cursors.left.isDown) {
  if (cursors.left.shiftKey) {
    hero.x -= 3
  } else {
    hero.x -= 1
  }
} else if (cursors.right.isDown) {
  if (cursors.right.shiftKey) {
    hero.x += 3
  } else {
    hero.x += 1
  }
}

if (cursors.up.isDown) {
  hero.y -= 1
} else if (cursors.down.isDown) {
  hero.y += 1
}
```

#### 有用到特殊按鍵 (監聽所有鍵盤事件)

如果游戏用到了键盘上非常用特殊按键，也可以监听整个键盘事件，监听某个按键按下代码如下，键盘下所有按键关键字都放在Phaser.Keyboard下，可自行打印查看

```javascript
// update函数中监听
if (game.input.keyboard.isDown(Phaser.Keyboard.LEFT)) {
  // do something...
}
```


## 初始化遊戲


```javascript
var config = {
  type: Phaser.AUTO,

  // 畫布寬高
  width: 800,
  height: 600,

  physics: {
    default: 'arcade',
    arcade: {
      gravity: {y: 300}, // 定義 arcade 世界裡的重力
      debug: false
    }
  },

  scene: {
    preload: preload,
    create: create,
    update: update
  }
}

new Phaser.Game(config)
```

## 操作 Game

* 所有的物件都可以從 Game 讀取，但是不建議，效率差。Phaser 有提供其他方法讀取。




## 鼠标mouse事件监听

鼠标最基本的四个按键是左键(leftButton)、中键(middleButton)、右键(rightButton)、滚轮(wheel)、可能有前进键(forwardButton)、后退键(backButton)。

在update函数中我们可以实时监测除滚轮滑动外的事件：

```javascript
// 左键按下
if (game.input.mousePointer.middleButton.isDown) {
  console.log('mouse middle button clicked!')
}
```

而滚轮事件要在create函数中监听滚动返回mouseWheelCallback：

```javascript
// 在create函数中：
game.input.mouse.mouseWheelCallback = mouseWheel;

function mouseWheel(event) {
  console.log(game.input.mouse.wheelDelta);
}
```

game.input.mouse.wheelDelta，返回1表示滚轮下滚，返回-1表示滚轮上滚。

但经测试发现，除滚轮外的其他鼠标按键事件存在兼容性问题，需谨慎使用，不出现区分三种按键的游戏形式，尽量使用鼠标按下事件统一代替。

掌握这两类基础的交互事件外，基本可以满足大多数的游戏需要。另外Phaser还有一些比较特殊的操作方式，最典型的就是操纵杆joystick，需要另外引入joystick插件，有兴趣的可以自行研究。官方demo


### 触屏事件

#### 屏幕添加单手指触屏事件

```javascript
game.input.onTap.add(onTap, this);  //监听点击
game.input.onDown.add(onDown, this);  //监听手指按下
game.input.onUp.add(onUp, this);  //监听手指放开
game.input.onHold.add(onHold, this);  //监听手指长按放开，3s

function onTap(pointer, doubleTap) {
}

function onDown(pointer) {
}

function onUp(pointer) {
}

function onHold(pointer) {
}
```

参数pointer记录手势的坐标等信息，onTap第二个参数doubleTap表示是否为双击事件。

#### 屏幕添加多手指触屏事件

Phaser假设人都有10只手指，只要有一只手指触屏，以下代码都能触发一次onDown，并通过pointer参数返回的id字段按照按下的顺序标记手指。

```javascript
game.input.onDown.add(onDown, this);

function onDown(pointer) {
  console.log(pointer)
}
```

我们也可以在render函数中打印手指触屏的实时信息

```javascript
game.debug.pointer(game.input.pointer1);
game.debug.pointer(game.input.pointer2);
// ...
game.debug.pointer(game.input.pointer10);
```

然而，Phaser本身默认只能监听最多两只手指的触屏事件，每需要监听多一只手指的触屏事件，都需要手动在create中如下所示增加一条手指触屏监听，所以，最多能再增加8条。但是，由于IOS本身的机制问题，只能最多监听5只手指的触屏事件，Phaser官方对此表示没有办法。Note:
on iOS as soon as you use 6 fingers you’ll active the minimise app gesture - and there’s nothing we can do to stop that,
sorry

```javascript
game.input.addPointer();
```

#### 物体添加交互事件

每一个sprite包含很多事件，都在events对象下面，如生命周期监听、交互监听，其中常用的交互监听事件有onInputOver(鼠标经过)、onInputOut(鼠标移开)、onInputDown(手指按下)、onInputUp(
手指松开)、onDragStart(拖拽开始)、onDragStop(拖拽结束)、onDragUpdate(拖拽中)。这些事件的回调中返回的参数如下所示：

事件 参数 说明 onInputOver    (sprite)    (当前sprite)
onInputOut    (sprite)    (当前sprite)
onInputDown    (sprite, pointer)    (当前sprite, 当前手指触屏信息)
onInputUp    (sprite, pointer)    (当前sprite, 当前手指触屏信息)
onDragStart    (sprite, pointer)    (当前sprite, 当前手指触屏信息)
onDragStop    (sprite, pointer)    (当前sprite, 当前手指触屏信息)
onDragUpdate    (sprite, pointer, dragX, dragY, snapPoint, fromStart)    (当前sprite, 当前手指触屏信息, 拖拽点x坐标, 拖拽点y坐标, 吸附点坐标,
是否第一次DragUpdate)

举例，我们给艾斯添加点击事件：

```javascript
hero.inputEnabled = true;
hero.events.onInputDown.add(clickedHero, this);

function clickedHero(sprite, pointer) {
  console.log(sprite)
  console.log(pointer)
}
```

我们给艾斯添加拖拽事件：enableDrag中的参数true代表使物体中心与手指触屏点重合，false代表不重合。

```javascript
hero.inputEnabled = true;
hero.input.enableDrag(false);

// Drag events
hero.events.onDragStart.add(dragStart);
hero.events.onDragUpdate.add(dragUpdate);
hero.events.onDragStop.add(dragStop);

function dragStart(sprite, pointer) {
}

function dragUpdate(sprite, pointer, dragX, dragY, snapPoint, fromStart) {

}

function dragStop(sprite, pointer) {
}
```

在drag事件里面onDragUpdate比较复杂，参数多达6个，其中有个涉及到非常强大的吸附功能的参数就是吸附点坐标snapPoint，该参数需要物体开启enableSnap吸附才能返回吸附点，吸附函数如下：

```javascript
enableSnap(snapX, snapY, onDrag, onRelease, snapOffsetX, snapOffsetY)
```

参数 类型 是否必选 默认值 说明 snapX number 是 吸附单位宽度 snapY number 是 吸附单位高度 onDrag boolean 否 true 拖拽的时候是否吸附 onRelease boolean 否 false
拖拽释放的时候是否吸附 snapOffsetX number 否 0 吸附到吸附单位的左边距 snapOffsetY number 否 0 吸附到吸附单位的上边距

```javascript
// 以64x64作为吸附单位，拖拽和释放都吸附
hero.input.enableSnap(64, 64, true, true);
// 以64x64作为吸附单位，但只有在释放的时候才会吸附
hero.input.enableSnap(64, 64, false, true);
```


## 參考資料

* [【技術筆記】AC Meetup：Phaser遊戲引擎](https://medium.com/alpha-camp-%E5%8F%B0%E7%81%A3/%E6%8A%80%E8%A1%93%E7%AD%86%E8%A8%98-ac-meetup-phaser%E9%81%8A%E6%88%B2%E5%BC%95%E6%93%8E-11bfc4be1827)
* [Phaser基础篇上](https://ryangun.github.io/2018/01/04/Phaser%E5%9F%BA%E7%A1%80%E7%AF%87%E4%B8%8A/)
