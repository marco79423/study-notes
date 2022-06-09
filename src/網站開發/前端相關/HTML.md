# HTML 學習筆記

## img

### 懶加載

懶加載是一種常見的技術，通過按需加載資源來減少網頁的數據使用。

如今懶加載已經是一種 Web 標准，大部分的主流瀏覽器都支持通過 loading="lazy" 屬性使用懶加載。

```html
<!-- with img tag -->
<img src="bits.jpeg" loading="lazy" alt="an image of a laptop" />

<!-- with IFrame -->
<iframe src="about-page.html" loading="lazy"></iframe>
```

一旦啟用懶加載，只有當用戶滾動到需要該內容顯示的地方才會去加載。

懶加載肯定可以提升應用性能以及用戶體驗，這也是為什麼它已成為開發者在開發應用時的首選優化措施。

懶加載可以實現兩種優勢：

* 減少頁面加載時間（PLT）
    * 通過延遲資源加載減少首屏頁面加載時間。
* 優化資源消耗
    * 通過資源懶加載優化系統資源使用，這在內存以及處理能力較低的移動設備上效果比較好。

懶加載會對性能的負面影響：

* 減慢快速滾動的速度
    * 如果你有一個 Web 應用 (比如在線商店) 需要讓用戶可以快速上下滾動以及導航。對這樣的應用使用懶加載會減慢滾動速度，因為我們需要等待數據加載完成。這會降低應用性能以及引發用戶體驗問題。

* 因為內容變化而導致的延遲
    * 如果沒有為懶加載的圖片定義的 width 和 height 屬性，那麼在圖片渲染過程中會出現明顯的延遲。因為資源在頁面初始化時沒有加載，瀏覽器不知道適用於頁面佈局的內容尺寸。
    * 一旦內容加載完成，而用戶滾動到特定視圖中，瀏覽器需要處理內容以及再一次改變頁面佈局。這會使其他元素移位，也會帶來糟糕的用戶體驗。

* 內容緩沖
    * 如果你在應用中使用非必要的懶加載，這會導致內容緩沖。當用戶快速向下滾動而資源卻還在下載中時會發生這種情況。尤其是帶寬連接較慢時會發生這種情況，這會影響網頁渲染速度。

使用懶加載的時機：

1. 在正確的地方懶加載正確的資源
    * 如果一個需要很多資源的冗長的網頁，可以考慮使用懶加載，但只能針對用戶視圖外或者被折疊的內容使用。
    * 確保你沒有懶加載後台任務執行所需的資源，比如 JavaScript 組件，背景圖片或者其他多媒體內容。
    * 可以使用谷歌瀏覽器的 Lighthouse 工具來檢查，識別那些可添加懶加載屬性的資源。
2. 懶加載那些不妨礙網頁使用的內容
    * 懶加載最好是用於不重要的非必需的 Web 資源。另外，如果資源沒有像預期那樣懶加載，那麼不要忘記錯誤處理和提供良好的用戶體驗。
    * 注意原生懶加載依然沒有被所有平台和瀏覽器普遍支持。如果你在使用一個庫或者自定義的 JavaScript 腳本，那麼這不會對所有用戶都生效。

3. 懶加載對搜索引擎優化（SEO）而言不重要的資源
    * 隨著內容懶加載，網站將逐漸渲染，這也就是說某些內容在首屏加載時並不可用，但我們並不希望 SEO 遺漏我們重要的業務數據。所以不要將懶加載用在針對 SEO 的

## iframe

```html
<body>
  <iframe>
  </iframe>
  <script>
    const win = frames[0].window;
    console.assert(win.globalThis !== globalThis); // true
    console.assert(win.Array !== Array); // true
  </script>
</body>
```

每個 iframe 都有一個獨立的運行環境，document 的全局對象不同於 iframe 的全局對象，類似的，全局對象上的 Array 肯定也不同。

## Event

### target 和 currentTarget 的差別

當你觸發一個元素的事件的時候，該事件從該元素的祖先元素傳遞下去，此過程為捕獲，而到達此元素之後，又會向其祖先元素傳播上去，此過程為冒泡

```html
<div id="a">
  <div id="b">
    <div id="c">
      <div id="d">哈哈哈哈哈</div>
    </div>
  </div>
</div>
```

![html-1](./images/html-1.png)

addEventListener 是為元素綁定事件的方法，他接收三個參數：

* 第一個參數：綁定的事件名
* 第二個參數：執行的函數
* 第三個參數：
    * false：默認，代表冒泡時綁定
    * true：代表捕獲時綁定

如果為 a、b、c、d 都綁定事件，而且都用默認的 false，看看輸出的東西可以發現觸發的是 d，而執行的順序是冒泡的順序

    target是 d currentTarget是 d
    target是 d currentTarget是 c
    target是 d currentTarget是 b
    target是 d currentTarget是 a

如果改為第三個參數都設置為 true，我們看看輸出結果，可以看出觸發的是 d，而執行的元素是捕獲的順序

    target是 d currentTarget是 a
    target是 d currentTarget是 b
    target是 d currentTarget是 c
    target是 d currentTarget是 d

可以總結出：

* e.target：觸發事件的元素
* e.currentTarget：綁定事件的元素

## Open Graph

Open Graph Protocol（開放圖譜協議），簡稱 OG 協議。它是 Facebook 在 2010 年 F8 開發者大會公佈的一種網頁元信息（Meta Information）標記協議，屬於 Meta Tag （Meta 標簽）的範疇，是一種為社交分享而生的 Meta 標簽，用於標准化網頁中元數據的使用，使得社交媒體得以以豐富的“圖形”對象來表示共享的頁面內容。

簡單來說，該協議就是用來標注頁面的類型和描述頁面的內容。

如果網頁採用 OG 協議，分享結果會結構化展示，這樣站點在被鏈接分享時會有更豐富的內容展現，同時站點的轉化率將會提升。

添加方式如下：

```html
<meta property="[NAME]" content="[VALUE]" />
```

範例 - 以下是 IMDB 上 The Rock 的 Open Graph 協議標記

```html
<html prefix="og: https://ogp.me/ns#">
  <head>
    <title>The Rock (1996)</title>
    <meta property="og:title" content="The Rock" />
    <meta property="og:type" content="video.movie" />
    <meta property="og:url" content="https://www.imdb.com/title/tt0117500/" />
    <meta
      property="og:image"
      content="https://ia.media-imdb.com/images/rock.jpg"
    />
    <!-- ... -->
  </head>
  <!-- ... -->
</html>
```

### 基礎屬性

要將你的網頁轉換為可控結構化圖形對象，你需要向頁面添加基本元數據。四個基本開放圖形標簽是：

#### og:title

* 指定想要在共享時展示的標題。這通常與網頁的 `<title>` 標簽相同，例如「百度一下，你就知道」。
* 最多 35 個字符

```html
<meta property="og:title" content="short title of your website/webpage" />
```

#### og:type

* 對象的類型，例如 `video.movie`。根據你指定的類型的不同，可能還需要添加一些其他的不同屬性。

```html
<meta property="og:type" content="article" />
```

[所有可用的 og:type 類型](http://ogp.me/#types)

#### og:image

* 一個圖片 URL。
* 尺寸小於 300KB 且最小尺寸為 300 x 200 的圖像（JPG 或 PNG）。此圖像一般應通過具有有效非自簽名證書的 HTTPS 鏈接提供。

```html
<meta
  property="og:image"
  content="//cdn.example.com/uploads/images/webpage_300x200.png"
/>
```

雖然使用 `og:image` 添加圖像比較容易，但有時讓你的圖像正確顯示可能具有挑戰性。開放圖譜協議包括一些圖像標簽，例如`og:image:url`、 `og:image:secure_url` 以及 `og:image:width` 和 `og:image:height`，可以對圖像進行更細致的控制。

一些社交網絡可能會對圖像有特殊要求。例如，Twitter 要求比例為 2:1，最小尺寸為 300x157，最大尺寸為 4096x4096，小於 5MB，JPG、PNG、WEBP 或 GIF 格式。

#### og:url

* 當前網頁地址的完整鏈接
* 可以是短鏈接，例如， `https://www.baidu.com/[2]`。

```html
<meta property="og:url" content="https://www.example.com/webpage/" />
```

### 其他屬性

#### og:site_name

你的內容所在的整個網站的名稱。如果你的對像是較大網站的一部分，則應為整個網站的名稱。

#### og:description

頁面的描述，最多 65 個字符。類似 og:title，這通常應該和網站的 `<meta type="description">` 標簽相同。

```html
<meta property="og:description" content="description of your website/webpage" />
```

#### og:video

og:video 標簽與 og:image 標簽相同，用於補充“圖形”對象的視頻文件的 URL

#### og:locale

資源的語言環境。如果你有其他語言翻譯可用，你也可以使用 og:locale:alternate。如果不指定 og:locale，則默認為 en_US。

```html
<meta property="og:locale" content="en_GB" />
<meta property="og:locale:alternate" content="fr_FR" />
<meta property="og:locale:alternate" content="es_ES" />
```

### 改進在社交平台支持

#### Twitter

Twitter 允許你指定 `twitter:card`，這是你在展示你的網站時可以使用的“卡片”類型。他們的卡類型包括：

* summary
* summary_large_image
* app
* player

[參考](https://developer.twitter.com/en/docs/twitter-for-websites/cards/guides/getting-started)

#### facebook

[參考](https://developers.facebook.com/docs/sharing/webmasters)

#### Pinterest

[參考](https://developers.pinterest.com/docs/rich-pins/overview/)

#### Linkedin

[參考](https://www.linkedin.com/help/linkedin/answer/46687/making-your-website-shareable-on-linkedin)

### 測試工具

* [Twitter](https://cards-dev.twitter.com/validator)
* [Facebook](https://developers.facebook.com/tools/debug/)
* [Pinterest](https://developers.pinterest.com/tools/url-debugger)

## 參考文章

* [連 OG 都不知道還好意思說自己開發過 H5？](https://mp.weixin.qq.com/s/DiLZZaJ8ru2VqOEzB1EIbA)
* [e.target 和 e.currentTarget 的区别？你到底知不知道？](https://mp.weixin.qq.com/s/B3AHkbdr7wlQB8-Fk5CgTg)
* [過度使用懶加載對 Web 性能的影響](https://mp.weixin.qq.com/s/4Oo4FtNO-mviTiS_dPT1Uw)
