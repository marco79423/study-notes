# CSS 學習筆記

> 沒有 CSS 的 HTML 是一個語義系統而不是 UI 系統。

## 語法

### 屬性的寫法

方法有兩種，第一種寫小屬性；第二種寫綜合屬性，用空格隔開。

* 小屬性的寫法：

    ```css=
    .a {
        padding-top: 30px;
        padding-right: 20px;
        padding-bottom: 40px;
        padding-left: 100px;
    }
    ```
* 綜合屬性的寫法：(上、右、下、左)（順時針方向，用空格隔開）
    ```css
    .a {
        padding:30px 20px 40px 100px;
    }
    ```
    * 如果寫了四個值，則代表：上、右、下、左。
    * 如果只寫了三個值，則代表：上、左右、下。
    * 如果只寫了兩個值，則為：上下、左右

* 後面會蓋前面

    ```css
    .a {
        padding: 20px;  /*上、下、右為 20px */
        padding-left: 30px; /* 左為 30px */
    }

    .a {
        padding: 20px;  /*上、下、右為 20px */
        padding-left: 30px; /* 左為 30px */
    }

    ```

### 單位

html 中的單位只有一種，那就是像素 px，所以單位是可以省略的，但是在 CSS 中不一樣。 CSS 中的單位是必須要寫的，因為它沒有默認單位。

#### 絕對單位

1 in = 2.54cm = 25.4mm = 72pt = 6pc。

各種單位的含義：

* in：英吋 Inches (1 英吋 = 2.54 釐米)
* cm：釐米 Centimeters
* mm：毫米 Millimeters
* pt：點 Points，或者叫英鎊 (1點 = 1/72英吋)
* pc：皮卡 Picas (1 皮卡 = 12 點)

#### 相對單位

* px：像素 
* em：印刷單位相當於12個點 
* %：百分比，相對周圍的文字的大小

之所以說 px 是相對單位，是因為在電腦螢幕的尺寸不變的情況下，可以使用顯示不同的解析度，在不同的解析度下，單個像素的長度自然是不一樣的。

## 佈局相關

css 是瀏覽器提供給開發者的描述界面的方式，而描述界面分為兩部分：

* 佈局 - 內容繪制在什麼地方？
    * 確定每個元素的位置，由 display 配合 position 來確定。
* 具體元素的渲染 - 內容怎麼繪制？
    * 具體內容相關，font、text、image 等分別有不同的樣式來描述如何渲染

## 盒模型

盒子模型，英文即box model。無論是div、span、還是a都是盒子。

所有的內容都會有一些空白和與其他元素的間距，所以 css 抽象出了盒模型的概念，也就是任何一個塊都是由 content、padding（空白）、border、margin（間距）這幾部分構成。

但是，圖片、表單元素一律看作是文本，它們並不是盒子。這個很好理解，比如說，一張圖片裡並不能放東西，它自己就是自己的內容。

一個盒子中主要的屬性就5個：width、height、padding、border、margin。

![](./images/css-1.png)

補充 - CSS盒模型和IE盒模型的區別：

* 在 標准盒子模型中，width 和 height 指的是內容區域的寬度和高度。增加內邊距、邊框和外邊距不會影響內容區域的尺寸，但是會增加元素框的總尺寸。
* IE盒子模型中，width 和 height 指的是內容區域+border+padding的寬度和高度。

### `<body>` 標簽也有 margin

整個網頁最大的盒子是 `<document>`，即瀏覽器，而 `<body>` 是 `<document>` 的兒子。瀏覽器給 `<body>` 默認的margin大小是8個像素，此時 `<body>` 佔據了整個頁面的一大部分區域，而不是全部區域。

### 寬度計算

```css=
/* 長寬 302 * 302 */
.box1 {
    width: 100px;
    height: 100px;
    padding: 100px;
    border: 1px solid red;
}
```

* 真實佔有長度 = 上 border + 上 padding + height + 下 padding + 下 border
* 真實佔有寬度 = 左 border + 左 padding + width + 右 padding + 右 border

### `padding` 也有顏色

padding 就是內邊距，padding的區域有背景顏色，並且背景顏色一定和內容區域的相同。

```css=
.a {
    width: 100px;
    height: 100px;
    padding: 50px;
    background-color: lightgreen;
    border: 10px;
}
```

![](./images/css-6.png)

### 預設就有 `padding` 的元素

有些元素預設就有 padding，所以為了方便控制，通常會清除掉 (不過一般都用套件，而非自己清)

```css
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td{
    margin:0;
    padding:0;
}
```

### 屬性 border

border 就是邊框。邊框有三個要素：

* 像素（粗細）border-width
  * 若無就不會有邊框
* 線型 border-style
  * 若無就不會有邊框
* 顏色 border-color
  * 預設為黑

border屬性是能夠被拆開的，有兩大種拆開的方式：

* 按三要素拆開：border-width、border-style、border-color
* 按方向拆開：border-top、border-right、border-bottom、border-left。

#### 線型 border-style

![](./images/css-5.png)

* 不同瀏覽器顯示會有區別
* 如果要追求完全的一致性，就不能用 CSS 來做邊框

## display

display 是設置盒的類型，不同的盒有不同的佈局規則，比如 BFC、IFC、FFC、GFC 等。

盒與盒之間也是有區別的，有的盒可以在同一行顯示，有的則是獨佔一行，而且對內容的位置的計算方式也不一樣。於是提供了 display 樣式來設置盒類型，不同的盒類型就會使用不同的計算規則。

* block
    * 元素會獨佔一行、可以設置內容的寬高，具體計算規則叫做 BFC。
* inline
    * 元素寬高由內容撐開不可設置，不會獨佔一行，具體計算規則叫做 IFC。
* flex
    * 子元素可以自動計算空白部分，由 flex 樣式指定分配比例，具體計算規則叫做 FFC。
* grid
    * 子元素則是可以拆分成多個行列來計算位置，具體計算規則叫 GFC。

這些都是不同盒類型的佈局計算規則。

## position

根據不同盒類型的佈局計算規則往往不夠用，很多場景下需要一些用戶自定義的佈局規則，所以 css 提供了 position 樣式，包括 static、relative、absolute、fixed、sticky。

盒與盒之間默認是流式的，也就是 position 為 static，但有的時候想在流中做下偏移，用 relative。當不想跟隨文檔流了，可以設置 absolute 來相對於上個非 static 位置來計算一個固定的位置，如果想直接相對於窗口，就用 fixed。

當需要做吸頂效果的時候，要根據滾動位置切換 static 和 fixed，這時候 css 還有一個 sticky 的定位方式可以直接用。

### 流式

具體什麼內容顯示在什麼位置是不固定的，只適合文字、圖片等內容的佈局。

* static
    * 默認的 position
    * 流式的，上個盒子顯示到什麼地方了，下個盒子就在下面繼續計算位置，顯示在什麼位置是由內容多少來決定的。
    * 最開始的時候網頁主要是用來顯示一些文本，所以流式的位置計算規則就很方便。

* relative
    * 根據上個盒子的位置自動計算出下個盒子的位置，可以使用 relative 做一些偏移
    * 可通過 top、bottom、left、right 來指定如何偏移。
    * 相對佈局給流式佈局增加一些靈活性，可以在流式計算規則的基礎上做一些偏移。

### 非流式

* absolute
    * 如果一些面板需要固定下來，就在某個位置不要動，就可以設置為 absolute 脫離文檔流。
    * 這時候就可以根據上個非流式的 position 來計算現在的 position。

* fixed
    * absolute 是根據上一個脫離了文檔流的 position 來計算位置的，最外層的 absolute 的元素是根據窗口定位。如果想直接根據窗口來定位可以指定 position 為 fixed。這個時候的 top、bottom、left、right 就是相對於窗口的。

### 特殊

* sticky
    * sticky 的效果在滾動的時候如果超過了一定的高度就 fixed 在一個位置，否則的話就 static。相當於基於 static 和 fixed 做的一層封裝，實現導航條吸頂效果的時候可以直接用。
    * 或許就是因為太常用，才封裝出了這樣一個 position 的屬性值吧，之前都是通過 js 監聽滾動條位置來分別設置 static 和 fixed 的。

## 例子 - VSCode

vscode 是上中下嵌套左中右的結構，窗口改變或者拖動都可以調整每塊大小，所以使用嵌套的 absolute 的方式來做整體的佈局。每一塊的內部則綜合使用流式、彈性等方式配合 position 分別做更細節的佈局。

## vscode 是如何佈局的

![](./images/css-2.png)

vscode 分為了標題欄、狀態欄、內容區，是上中下結構，而內容區又分為了活動欄、側邊欄、編輯區，是左中右結構。窗口可以調整大小，而這個上中下嵌套左中右的結構是不變的。

這種佈局如何實現呢？

css 的佈局就是 display 配合 position 來確定每一塊內容的位置。我們的需求是窗口放縮但每一塊的相對位置不變，這種用 absolute 的佈局就可以實現。

首先，最外層是上中下的結構，可以把每一塊設置為 absolute，然後分別設置 top 值，然後中間部分由分為了左中右，可以再分別設置左中右部分的 left 值，這樣就完成了每一塊的佈局。

![](./images/css-3.png)

![](./images/css-4.png)

這是整體的佈局，每一塊內部則根據不同的佈局需求分別使用流式、彈性等不同的盒，配合絕對、相對等定位方式來佈局。

但是，絕對定位是要指定具體的 top、bottom、left、right 值，是靜態的，而窗口大小改變的時候需要動態的設置具體的值。這時候就需要監聽窗口的 resize 事件來重新佈局，分別計算不同塊的位置。

而且 vscode 每一塊的大小是也是可以拖動改變大小的，也要在拖動的時候重新計算 left、top 的值。

## 參考資料

* [06-CSS盒模型詳解](https://github.com/qianguyihao/Web/blob/master/02-CSS%E5%9F%BA%E7%A1%80/06-CSS%E7%9B%92%E6%A8%A1%E5%9E%8B%E8%AF%A6%E8%A7%A3.md)
* [CSS 布局的本质是什么](https://mp.weixin.qq.com/s/ulp8BbbeZAneS4NajDF6-g)
