# CSS 學習筆記

> 沒有 CSS 的 HTML 是一個語義系統而不是 UI 系統。

## 語法

語法由一個選擇器(selector)起頭。 它選擇了我們將要用來添加樣式的 HTML 元素。

接著輸入一對大括號 { }。 在大括號內部定義一個或多個形式為 `屬性(property):值(value` 的聲明。每個聲明都指定了我們所選擇元素的一個屬性，之後跟一個我們想賦給這個屬性的值。

冒號之前是屬性，冒號之後是值。不同的 CSS 屬性對應不同的合法值。

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

單位可以分為「網頁」和「印刷」兩大類，通常對於 CSS 來說只會應用到網頁的樣式，畢竟真正要做印刷，還是會傾向透過排版軟體來進行設計。

#### 網頁 ( 單位 )

* px：絕對單位，代表螢幕中每個「點」( pixel )。
* em：相對單位，每個子元素透過「倍數」乘以父元素的 px 值。
* rem：相對單位，每個元素透過「倍數」乘以根元素的 px 值。
* %：相對單位，每個子元素透過「百分比」乘以父元素的 px 值。

#### 印刷

    1 in = 2.54cm = 25.4mm = 72pt = 6pc。

* pt：印表機的每個「點」，定義為 1 pt ＝ 1/72 in，如果在 72 dpi 的系統上 1 px = 1 pt，但如果在 96 dpi 的系統上 1 px = 0.75 pt ( 72/96 = 0.75 )。
* in：英吋，在 96 dpi 的系統上 1 in = 96 px。
* cm：公分，在 96 dpi 的系統上 1 cm = 37.795275593333 px。
* mm：公釐，在 96 dpi 的系統上 1 cm = 3.7795275593333 px。

* 網頁 (屬性名稱)
    * medium：預設值，等於 16px ( h4 預設值 )
    * xx-small：medium 的 0.6 倍 ( h6 預設值 )
    * x-small：medium 的 0.75 倍
    * small：medium 的 0.8 倍 ( h5 預設值，W3C 定義為 0.89，實測約為 0.8 )
    * large：medium 的 1.1 倍 ( h3 預設值，W3C 定義為 1.2，實測約為 1.1 )
    * x-large：medium 的 1.5 倍 ( h2 預設值 )
    * xx-large：medium 的 2 倍 ( h1 預設值 )
    * smaller：約為父層的 80%
    * larger：約為父層的 120%

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

盒子模型，英文即 box model。無論是 div、span、還是 a 都是盒子。

在 CSS 中我們廣泛地使用兩種「盒子」

* 塊級盒子 (block box)
* 內聯盒子 (inline box)

我們通過對盒子 display 屬性的設置，比如 inline 或者 block ，來控制盒子的外部顯示類型。

display 有一個特殊的值，它在內聯和塊之間提供了一個中間狀態。這對於以下情況非常有用:您不希望一個項切換到新行，但希望它可以設定寬度和高度。

這兩種盒子會在頁面流（page flow）和元素之間的關系方面表現出不同的行為。

### 塊級盒子 (block box)

一個被定義成塊級的（block）盒子會表現出以下行為：

* 盒子會在內聯的方向上擴展並佔據父容器在該方向上的所有可用空間，在絕大數情況下會和父容器一樣寬
* 會換行
* width 和 height 屬性可以發揮作用
* 內邊距（padding）, 外邊距（margin） 和 邊框（border） 會將其他元素從當前盒子周圍「推開」

除非特殊指定，諸如標題(如 `<h1>`)和段落(如 `<p>`)默認情況下都是塊級的盒子。

### 內聯盒子 (inline box)

如果一個盒子對外顯示為 inline，那麼他的行為如下:

* 盒子不會換行。
* width 和 height 屬性沒用。
* 垂直方向的內邊距、外邊距以及邊框會被應用但是不會把其他處於 inline 狀態的盒子推開。
* 水平方向的內邊距、外邊距以及邊框會被應用且會把其他處於 inline 狀態的盒子推開。

用做鏈接的 `<a>` 元素、 `<span>` 、 `<em>` 以及 `<strong>` 都是默認處於 inline 狀態的。

### CSS 盒模型

所有的內容都會有一些空白和與其他元素的間距，所以 css 抽象出了盒模型的概念，也就是任何一個塊都是由 content、padding（空白）、border、margin（間距）這幾部分構成。

完整的 CSS 盒模型應用於塊級盒子，內聯盒子只使用盒模型中定義的部分內容。

但是，圖片、表單元素一律看作是文本，它們並不是盒子。這個很好理解，比如說，一張圖片裡並不能放東西，它自己就是自己的內容。

一個盒子中主要的屬性就5個：width、height、padding、border、margin。

組成：

* Content box
    * 這個區域是用來顯示內容
    * 大小可以通過設置 width 和 height.
* Padding box
    * 包圍在內容區域外部的空白區域
    * 大小通過 padding 相關屬性設置。
* Border box
    * 邊框盒包裹內容和內邊距。
    * 大小通過 border 相關屬性設置。
* Margin box
    * 這是最外面的區域，是盒子和其他元素之間的空白區域。
    * 大小通過 margin 相關屬性設置。

![box-model](./images/box-model.png)

#### 寬度計算實例

```css
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

![css-1](./images/css-1.png)

> **注：** margin 不計入實際大小 —— 當然，它會影響盒子在頁面所佔空間，但是影響的是盒子外部空間。盒子的範圍到邊框為止 —— 不會延伸到 margin。

#### Margin 外邊距

外邊距是盒子周圍一圈看不到的空間。它會把其他元素從盒子旁邊推開。 外邊距屬性值可以為正也可以為負。設置負值會導致和其他內容重疊。無論使用標准模型還是替代模型，外邊距總是在計算可見部分後額外添加。

我們可以使用 margin 屬性一次控制一個元素的所有邊距，或者每邊單獨使用等價的普通屬性控制：

* margin-top
* margin-right
* margin-bottom
* margin-left

##### 外邊距折疊（Margin Collapse）

理解外邊距的一個關鍵是外邊距折疊的概念。如果你有兩個外邊距相接的元素，這些外邊距將合並為一個外邊距，即最大的單個外邊距的大小。

例子中，我們有兩個段落。頂部段落的頁 margin-bottom 為 50px。第二段的 margin-top 為 30px。因為外邊距折疊的概念，所以框之間的實際外邊距是 50px，而不是兩個外邊距的總和。

##### `<body>` 標簽也有 margin

整個網頁最大的盒子是 `<document>`，即瀏覽器，而 `<body>` 是 `<document>` 的兒子。瀏覽器給 `<body>` 默認的 margin 大小是 8 個像素，此時 `<body>` 佔據了整個頁面的一大部分區域，而不是全部區域。

### Border 邊框

邊框是在邊距和填充框之間繪制的。如果正在使用標准的盒模型，邊框的大小將添加到框的寬度和高度。如果使用的是替代盒模型，那麼邊框的大小會使內容框更小，因為它會佔用一些可用的寬度和高度。

分別設置每邊的寬度、顏色和樣式，可以使用：

* border-top
* border-right
* border-bottom
* border-left

### Padding 內邊距

內邊距位於邊框和內容區域之間。與外邊距不同，您不能有負數量的內邊距，所以值必須是0或正的值。

我們可以使用 padding 簡寫屬性控制元素所有邊，或者每邊單獨使用等價的普通屬性：

* padding-top
* padding-right
* padding-bottom
* padding-left

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

![css-6](./images/css-6.png)

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

## CSS 開發中的防禦規則

* 避免用 JavaScript 控制佈局 (我覺得可以討論)
    * 不要用 JavaScript 實現的佈局組件。它會多出很多層沒用的嵌套，同時把佈局定義的很死，難以再用 CSS 控制。而且永遠沒有原生的流暢，同時增加代碼的復雜，容易用問題。除非解決一些必要的兼容性問題。

* 避免用 float / position: absolute / display: table 等過時的佈局技術
    * 優先用 Flexbox/Grids 佈局。

* 避免定高/定寬
    * 固定寬/高最容易出現的問題是內容溢出。沒必要通過定寬高對齊，可以利用 Flexbox 的位伸/收縮特性。一般情況下用最小寬/高、calc()、相對單位替代。

* 避免侵入性的寫法
    * 避免影響全局樣式，如：* { ... }、:root {...} 、div { ....} 等。
    * 避免影響通用組件樣式，如：.next-card {...}，如果要定製單加一個 class 名。
    * 不要直接修改全局 CSS 變量，把自己的 CSS 變量定義在模塊的范圍內。
    * 不要寫 z-index:999。一般 1～9，防止被遮擋 10～99，絕對夠用了。
    * 不要在標簽上定義 style 屬性。不要在 JS 代碼中做樣式微調，這樣今後無法統一升級 CSS 樣式。
    * 只有完全不可修改的樣式才能用 !important，利用選擇器優先級調整樣式。

* 避免CSS代碼的誤改 / 漏改
    * 將樣式集中在一起，容易改錯。保持 CSS 代碼和文件在相應的層級上，同一模塊的放一起。避免混入通用樣式中，為了避免改錯，允許適當冗餘。
    * 用 @media 時，會集中覆寫一批元素的樣式，更新樣式時非常容易遺漏。所以必須拆開寫，和對應模塊的樣式放在一起。不要集中放在文件底部，或是集中放在某一個文件裡。
    * 及時清除「死代碼」。

* 避免 CSS 樣式衝突
    * 限定作用范圍。如，.my-module .xxx { ... }。
    * 業務代碼中的樣式要加前綴，或借鑑 BEM 命名方式。如：.overview-card-title { ... }。用CSS Module。
    * 注意選擇器的精確性。層級過長過於複雜的 CSS 選擇器會影響性能，但要注意：有時需要精確選擇某些元素，如僅選擇一級子元素，.overview-card-content > .item { ... }。

* 防止內容不對齊
    * flexbox 側重「對齊」，Grids是專為佈局設計的。受字體、行高等因素影響（如圖），用 Flexbox 實現對齊最可靠：
        1. height / line-height 不可靠。
        2. display:inline-block / vertical-align:middle 不可靠。

* 防止內容溢出
    * 文字 / 圖表等內容在寬度變化時或是英文版下容易出現溢出。
        ![css-7](./images/css-7.png)
        * 圖表要支持自動 resize。
        * 圖片要限制大小范圍，如：max-width、max-height、min(100px, 100%)、max(100px, 100%)
            * （注意：min() / max() 兼容性：chrome 79+ / safari 11 / firefox 75）
        * 不要固定寬/高

* 防止內容過度擁擠
    * 為了防止內容過長時緊帖到後面的內容，水平排列元素之間要設置間距，一般是 8px。
    * 如果用 flexbox 可以用 gap (但要考慮兼容性問題，穩定起見可用 margin)。

* 防止內容被遮擋
    * 避免定義負值時（負 margin / top / left），小心內容被遮擋。定義 margin 統一朝一個方向，向下和向右定義，再重置一下:last-child。position: relative 平時很常用，發生遮擋時會造成鏈接無法點擊。

* 防止可點擊區域過小
    * 小於 32x32 像素的可點擊元素，通過下面的方式擴大可點擊區域：
        ```css
        .btn-text {
            position: relative;
        }

        /* 比 padding 副作用小 */
        .btn-text::before {
            content: '';
            position: absolute;
            top: -6px;
            left: -8px;
            right: -8px;
            bottom: -6px;
        }
        ```

* 防止內容顯示不全 / 被截斷
    * 在定義 overflow:hidden 時，就要考慮內容是否有被截斷的可能。一般不要加在容器元素上。
    * 防止長文字被生生截斷，加省略號。UI實現過程中要對內容做出判斷，哪些是不應該折行的，哪些是不應該省略的，如：
        * white-space: nowrap;
        * overflow: hidden;
        * text-overflow: ellipsis;

* 防止該折行不折行 / 不該折行的折行
    * 首先必須理解UI，折行有3種情況：哪些需要折行，哪些不能折行，哪些不能從中間斷行。
        1. 大部分情況需要折行，不能為了保持 UI 美觀而損失內容的完整性。一般用overflow-wrap，盡量不要用 word-wrap（不符CSS標准）：
            * overflow-wrap: break-word 配合 overflow-wrap，可再加上 hyphens: auto（目前兼容性不夠）
        2. 不能折行，如標題 / 列頭 / 按鈕等。
        3. 避免表頭折行。表格列數過多（>5列）時，會要求鎖列，此時，th定義white-space: nowrap強制不折行。
        4. 不能從中間斷行
            ![css-8](./images/css-8.png)

* 防止滾動鏈問題
    * 浮層的場景下需要避免滾動鏈問題：子元素可滾動，如果父元素也有滾動區域，在子元素上滾動時，觸頂/觸底後，會影響父元素滾動。關掉浮層後，用戶會發現頁面滾到了其它位置。
        ```css
        overscroll-behavior: contain;
        overflow-y: auto;
        overflow-x: hidden;
        ```
    * 注意：避免出現同時出現水平/垂直滾動條

* 防止圖片變形
    * 圖片被置於特定比例的容器中時，固定寬/高和約束最大寬/高，都可能會導致圖片變形。
        ```css
        .head img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        ```
        * 在 Flexbox 容器內，圖片高度會被自動拉伸。因為不要定義 align-items，默認是stretch。

* 防止圖片加載失敗
    * 需要考慮圖片加載慢或加載失敗的情景。在圖片的容器上加邊或加底色。

* 防止CSS變量未引入
    * 在標准化開發中，我們提倡使用全局的CSS變量。業務代碼中，利用CSS變量也可以方便的進行全局的控制。在使用CSS變量時要加上預設值。
        * font-size: var(--tab-item-text-size-s, 12px);

* 防止CSS兼容性問題
    * 不要加瀏覽器廠商前綴，讓CSS預編譯自動處理，像-webkit-、-moz-。
    * 不要用僅特定瀏覽器廠商支持的屬性。

* Flexbox常見防禦性寫法
    * Flexbox的默認表現比較多，不能簡單的定義display:flex，或是flex:1。
        * Flexbox容器元素通常要做如下定義：
            * 要支持多行（默認是單行）
            * 交叉軸上垂直居中（默認是stretch）
            * 主軸上採用 space-between，將自由空間分配到相鄰元素之間。
        * 一般都要寫上：
            ```css
            {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                align-items: center;
            }
            ```
    * Flexbox的盒子元素要定義間距。

* Grid常見防禦性寫法
    * 不固定網格的寬度，用 minmax (最小值，1fr)。
    * 定義間距，如grid-gap: 8px。
    * 不固定列數, 利用auto-fit / auto-fill自動適配。

## 例子 - VSCode

vscode 是上中下嵌套左中右的結構，窗口改變或者拖動都可以調整每塊大小，所以使用嵌套的 absolute 的方式來做整體的佈局。每一塊的內部則綜合使用流式、彈性等方式配合 position 分別做更細節的佈局。

### vscode 是如何佈局的

![css-2](./images/css-2.png)

vscode 分為了標題欄、狀態欄、內容區，是上中下結構，而內容區又分為了活動欄、側邊欄、編輯區，是左中右結構。窗口可以調整大小，而這個上中下嵌套左中右的結構是不變的。

這種佈局如何實現呢？

css 的佈局就是 display 配合 position 來確定每一塊內容的位置。我們的需求是窗口放縮但每一塊的相對位置不變，這種用 absolute 的佈局就可以實現。

首先，最外層是上中下的結構，可以把每一塊設置為 absolute，然後分別設置 top 值，然後中間部分由分為了左中右，可以再分別設置左中右部分的 left 值，這樣就完成了每一塊的佈局。

![css-3](./images/css-3.png)

![css-4](./images/css-4.png)

這是整體的佈局，每一塊內部則根據不同的佈局需求分別使用流式、彈性等不同的盒，配合絕對、相對等定位方式來佈局。

但是，絕對定位是要指定具體的 top、bottom、left、right 值，是靜態的，而窗口大小改變的時候需要動態的設置具體的值。這時候就需要監聽窗口的 resize 事件來重新佈局，分別計算不同塊的位置。

而且 vscode 每一塊的大小是也是可以拖動改變大小的，也要在拖動的時候重新計算 left、top 的值。

## 參考資料

* [06-CSS盒模型詳解](https://github.com/qianguyihao/Web/blob/master/02-CSS%E5%9F%BA%E7%A1%80/06-CSS%E7%9B%92%E6%A8%A1%E5%9E%8B%E8%AF%A6%E8%A7%A3.md)
* [CSS 布局的本质是什么](https://mp.weixin.qq.com/s/ulp8BbbeZAneS4NajDF6-g)
* [防禦性設計和開發](https://mp.weixin.qq.com/s/G4pME9xFHdWnFckgytnofQ)
