# SEO 學習筆記

## 什麼是搜尋引擎優化 (SEO)？

SEO 是一種透過自然排序（無付費）的方式增加網頁能見度的行銷規律。SEO包含技術與創意，用以提高網頁排名、流量，以及增加網頁在搜尋引擎的曝光度。SEO有很多方式，可以從網頁上的文字，或著其它網站連結到你的網頁，有時SEO只是運用簡單的方法，確保搜尋引擎可以了解你的網站架構。

![seo-1](./images/seo-1.jpg)

SEO 並不僅僅是建構搜尋引擎友善的網頁，SEO 可以讓網頁更容易被人們使用，並且帶給人們更多的資訊，這些是與SEO原則密切相關的。

## 為什麼需要SEO？

網頁流量的主要來源來自於各大商業搜尋引擎，Google、Bing、Yahoo!，雖然社群媒體或其他方式一樣能夠讓人訪問你的網頁，但搜尋引擎仍然是大多數網路用戶搜尋瀏覽的主要方式，不管你的網頁是提供內容、服務、產品、資訊、或其他任何東西。

搜尋引擎獨特的地方在於它們提供“針對性”的流量 – 人們會搜尋你所提供的訊息，而搜尋引擎是通往這目標的道路，若搜尋引擎無法找到你的網頁，或無法把你的網頁文章加入到他們的資料庫，你就喪失了吸引流量到你網站的最好機會。

搜尋查詢 – 瀏覽者輸入到搜尋框的文字 – 是非常有價值的關鍵字，經驗證明搜尋引擎的流量可以成就（或破壞）一家公司的成敗，對網站來說，“針對性”的流量所提供的宣傳、收入和曝光是沒有其他的行銷方式可以比擬，並且比起其它類型的行銷與宣傳，SEO 的投資報酬率來的有效率多了。

![seo-2](./images/seo-2.jpg)

## 各大搜尋引擎

### Google

#### Google 三種動物演算法

* [Google熊貓演算法](https://www.newscan.com.tw/all-seo/google-panda.htm)
    * 「熊貓演算法」更新的目的是獎勵高質量的網站，並減少Google有機搜尋引擎結果中低質量網站的存在，它最初也被稱為“農夫”。 據Google聲稱，「熊貓演算法」在首次推出幾個月內的英語搜尋結果高達12％，2011年至2015年，我們已經追蹤了「熊貓演算法」28次更新紀錄。
* [Google企鵝演算法](https://www.newscan.com.tw/all-seo/google-penguin.htm)
    * 緊隨「熊貓演算法」之後，Google的「企鵝演算法」是一項新的努力，主要是在獎勵高質量的網站，並減少搜尋引擎結果頁面（SERP）涉及操縱連結和關鍵字填充存在的網站。
* [Google蜂鳥演算法](https://www.newscan.com.tw/all-seo/google-hummingbird.htm)
    * 與之前發布的「熊貓演算法」和「企鵝演算法」更新不同，後者最初是作為Google現有算法的附件發佈的，目前「蜂鳥演算法」已徹底轉變成為核心算法引用， 雖然核心算法中許多先前組件還是保持著，但「蜂鳥演算法」表明Google開始深入了解搜尋者「查詢資料的意圖為何?」，並將其與相關結果進行匹配。

### 網站核心指標 (Core web  vitals)

Google 在官方部落格中針對使用者體驗推出了新的 3 項 Core web vitals (暫譯網站核心指標)。

![seo-4](./images/seo-4.png)

#### 網站載入速度 (LCP, Largest Contentful Paint）

在 LCP 之前有另外一個指標 First Contentful Paint (FCP)，FCP 針對網站中的第一個元素的載入，但如果只針對第一元素，對使用者來說仍然是看不到重要的內容的，因此 Google 針對這樣的情形另外制定了一個全新的指標 – LCP。

與 FCP 不同的是，LCP 更加注重頁面中最大元素的載入速度。而 Google 是怎麼判定最大元素呢？當頁面在載入的過程中，Google 會去抓取頁面可視範圍中最大的元素，並會隨時針對可視範圍中的內容改變，直到頁面完全載入後，才會將頁面中最大的元素訂為 LCP。

LCP 會偵測的項目：

* 圖片
* svg 向量圖片
* 影片 (預覽大圖)
* 透過 url() 的 CSS 功能載入背景圖片的元素
* 包含文字的區塊級元素 (block-level elements) 或行內元素 (inline elements)

通常 LCP 可以針對以下 4 大點來進行優化：

* 減少伺服器回應時間
    * 針對主機進行優化
    * 使用較近的 CDN 主機
    * 使用網頁快取
    * 讓第三方的資源提早載入
* 排除禁止轉譯的資源
    * 降低 JavaScript 阻擋時間
    * 降低 CSS 阻擋時間
* 加快資源載入的時間
    * 圖片大小優化
    * 預先載入重要資源
    * 將文字檔案進行壓縮
    * 根據使用者的網路狀態提供不同的內容
    * 使用 service worker
* 避免使用客戶端渲染(CSR)
    * 若必須使用 CSR ，建議優化 JavaScript ，避免渲染時使用太多資源
    * 盡量在伺服器端完成頁面渲染，讓用戶端取得已渲染好的內容

#### 可開始互動的時間 (FID, First Input Delay）

有些網站，雖然已經有內容顯示，但不管使用者怎麼與頁面互動都沒有任何回饋，所以 Google 針對這樣的情形制定了另一個指標 – First Input Delay (FID)

什麼是 FID：

首次輸入 (First Input) 與頁面上的響應元件 (responsive elements) 息息相關。這些響應元件可能是連結、按鈕或是跳出式元素 (pop-ups)。

輸入延遲 (Input Delay) 通常發生於瀏覽器的主執行序過度繁忙，而導致頁面內容無法正確地與使用者進行互動。舉例來說，可能瀏覽器正在載入一支相當肥大的 JavaScript 檔案，導致其他元素不能被載入而延遲可互動的時間。

常見延遲的問題有：

* 點選連結或按鈕載入內容延遲
* 文字對話框無法立即輸入文字
* 打開下拉式選單畫面延遲
* 無法勾選對話方塊

優化的方式：

* 減少JavaScript運作的時間
* 降低網站的 request 數並降低檔案大小
* 減少主執行序的工作
* 降低第三方程式碼的影響

#### 頁面穩定性 (CLS, Cumulative Layout Shift）

你是不是也有過這樣的經驗呢？當你正在使用一個頁面時，突然跳出一個按鈕或廣告，導致點擊到非目標按鈕或功能。Google 對於此情形建立了一個頁面穩定性的指標 – CLS。

可預期的版面配置轉移 (Expected layout shifts)：

當你在 web.dev 的網站中，點選內容回饋的收合功能，這時候頁面因為收合而導致的版面配置轉移是可以預期的。因此， Google不會將此判定為是頁面的不穩定性。

![seo-5](./images/seo-5.png)

不可預期的版面配置轉移(Un-expected layout shifts)：

不可預期的版面配置轉移通常是因為網頁內的元素載入順序不同而造成的。在 Google 提供的範例裡，由於 Click Me! 的按鈕是在文字方塊載入後才載入的，導致使用者在閱讀到一半時出現內容位移的情形，這種對於使用者來說不可預期的版面配置轉移就會影響 CLS 指標的分數。

![seo-6](./images/seo-6.png)

優化的方式：

* 透過 CSS 語法，為網頁中的元素提供預留的空位，避免載入後導致頁面中的內容移動
* 透過 `<preload>` 的方式，將會導致頁面內容移動的元素提前載入 (字體、圖片等)

#### 測試 Core Web Vitals 的方式

![seo-7](./images/seo-7.webp)

#### 其他優化指標

* 行動版頁面
    * Google已經宣布會將行動版的使用者體驗作為參考項目之一，網站的排名也會將是否符合行動裝置使用作為一個參考指標。
* 網站瀏覽安全性
    * 當網站含有釣魚內容或可能導致網站使用者中毒的狀況，Google 會將其從搜尋結果上移除。可以透過 Google Search Console 中的「安全性問題」來確認。
* HTTPS/SSL 設定
    * 網站中的傳輸過程需要經由 SSL 進行加密，避免訊息被中途攔截導致資訊外洩。
* 避免蓋版廣告
    * 蓋板式廣告很容易對使用者造成使用上的不便。如果網頁上出現這些類型的跳出式蓋版廣告，那可能就要進行修改了。

### CSR

SEO 背後的流程是 crawling → indexing → ranking 三個階段，而另一件重要的事是「沒有渲染的內容是不會被加入到 indexing 的」。

在 google search engine 團隊不斷的努力，CSR 網站實際上是可以參與 SEO 的，並不像是第一次跟伺服器拿到 HTML 後，發現裡面只有一個 `<div>` 後，就不理這個網站了。

googlebot 有所謂 second wave of indexing 技術，如果一個網站有需要被渲染的需求，亦即像是等待 JavaScript 把內容渲染出來，而 googlebot 遇到這種情況會先丟到 render queue 裡面，等待有資源處理渲染任務後才會回來做這件事。

![seo-3](./images/seo-3.png)

但 googlebot 每天都要處理數量非常龐大的網站，它必須要有些機制判斷有些內容實際上不必參與 SEO，也就是 render budget 的評估機制。

render budget 包括像是等待渲染的時間太久、很少人去的網站等因素，則會造成 googlebot 評估一個網站「不用等到全部的內容渲染完畢後才 indexing」，因此這種情況下只有部分內容會進入到 indexing 跟 ranking 的階段。所以如果比較重要的內容是在 JavaScript 渲染階段才會出現在畫面上，googlebot 有機會不將這些重要的內容納入 indexing 中，最終將會不利於 SEO。

綜合上述，CSR 實際上雖然可以參與 SEO，但是不利於內容變動快速的網站，因為 CSR 沒辦法讓 googlebot 快速地拿到需要的內容。這時候 SSR 跟 SSG 就能夠發揮效用，googlebot 不必經過 second wave of indexing 就可以迅速地跟伺服器拿到資料，因此有利於內容變動快速的網站做 SEO。

如果說伺服器可以承受負擔，而且 SSG 跟 SSR 對於 SEO 從內容上來看都比較好，但 SEO 有很多項指標，而如果全面使用 SSR，把所有資料都在伺服器端處理，其實也不一定有利於 SEO，而且頁面中的有些內容其實不必參與 SEO。因此 SSR 只需把「對使用者有價值的資料」渲染完畢，把剩下的部分交由 CSR 處理就行了，這樣使用者可以更快地看到內容，有利於「First Contentful Paint」的評分。

### Bing

Bing 前身是 MSN Live Search，服務的對象比互聯網世界小得多。所以 Bing 是從原來一個小引擎逐步發展。

已知的事實是：

* Bing 搜尋引擎爬行得比 Google 搜尋引擎慢。
    * Google 2010 推出 Cafferine 令爬行的速度快了幾倍。是 Caffeine 打下的基礎而令 Panda 和 Penguin 變得可行。所以你會發現 Bing 搜尋排名的變動較 Google 慢很多，看起來就像 Bing 偏向舊網站。

* 由於爬行慢所以 Bing 搜尋引擎會經簡單初步判斷放棄檢索沒有潛質的網站，將運算能力留給其他更有潛質的網站。
    * 所以就算你提交網站地圖 sitemap 不一定有幫助。並且不是網站内每一網頁的內容都會被檢索。
    * 例如你網站有 1,000 網頁，Bing 可能只檢索其中 100頁。Google 也是，但由於跑得快，所以可是檢索得網站和網站內更多網頁。

* 對新網站來說最有效的方法避免被 Bing 放棄就是有一個來自權威網站的反向連結。例如將網站提交 dmoz.org。
    * Bing 乎要更加看重權威網站入站連結。Google 已經排除了完全符合關鍵字的域名名稱的排名影響，即得說www.cosmetics.com 關鍵字 “cosmetics” 可不一定排名靠前。
    * Bing 以前專利提到使用的域名和關鍵字相關將提振排名，似乎 Bing 仍然這樣做。

* 如果網域名稱配對關鍵字，Bing 搜尋排名給予很高的分數
    * 這從 Bing 有一份專利文件 “Determining relevance of documents to a query based on identifier distance” 中引證得到。
    * 相對 Google 就不會給了太多優勢，從 2012 年的一份專利文件 Google Exact Match Domain 更新中引證得到。

* Bing 對社交媒體訊號給予的權重比 Google 要大得多。
    * Bing 據說已經可以索引 Facebook 內的帖子和 Twitter 的帖子，而 Google 只能索引 Twitter 的帖子。
    * 而在 Google 輸入相同關鍵字搜尋時是找不同這個 Facebook 粉絲頁，要更新搜尋關鍵字為 “網上生意推廣” 才在搜尋結果第一頁第七位找到，但顯示的是 53 個讚，二星期前的更新。

* 本地搜尋引擎優化 Local SEO 最重要的一點就是告訴搜尋引擎你的生意的所在地區，當搜尋引擎認為提供區域化搜尋結果(例如醫務所，餐廳，店舖等等)對搜尋用戶更有價值時就會對配對地區的搜尋結果提高排名。
    * 在 Bing 搜尋引擎是通過 Bing Places for Business 登記註冊你的店鋪。

* 對 Google 優化有經驗的人大都知道 Google 好多年前已經不再理會 meta keyword 關鍵字, 理由是 meta 關鍵字太容易作假。Bing 搜尋引擎幾年前亦公開說 meta 關鍵字不會影響 Bing 的搜尋排名結果。
    * 但從實驗中發現加入 meta 關鍵字有助於通知 Bing 該網頁內容與某關鍵字相關。
    * 原因可能是 Google 和 Bing 對關鍵字出現頻率有不同的看法。Google 搜尋引擎優化中關鍵字出現太多有反效果，但 Google 的理想關鍵字出現頻率對 Bing 來說可能又太少，不足以引起相關性索性，meta 關鍵字正好加強相關性提示而又不引起 Google 反感。

* 同 meta 關鍵字理由類似，Bing 建議每一網頁只有一個 HTML H1 標題。
    * Bing 會分析 H1 標題找出關鍵字進行索引。多過一個的 H1 標題對 Bing 會是擾亂訊號。從這點來說 Bing 搜尋引擎是比 Google 搜尋引擎笨。

* Bing 要求 meta description 描述必需存在，而 Google 沒有這個要求。
    * 就算你已經定義 meta 描述，對 Google 來說亦只作它的參考，如果 Google 發現網頁中某片段內容更切合當前用戶輸入的搜尋關鍵字，Google 會自動抓取該段文字顯示在搜尋結果中。從這點來說 Google 又比 Bing 聰明。

* Bing 搜尋引擎似乎很看重分類 Category 的 meta 描述，當分類和搜尋關鍵字配匹時，分類在 Bing 比 Google 更容易取得較分類中網頁更高的排名。

* Google 和 Bing 對區域性處理有很大不同。當以 Google 搜尋時，Google 會自動將搜尋用戶所在國家的搜尋 Top Level Domain TLD （例如： 當搜尋者在香港輸入 google.com，會被轉址到 google.com.hk，如搜尋者在台灣，會被轉址到 google.com.tw）, 排名結果會較受區域性影響。Bing 沒有 TLD 轉址，排名結果會較少受區域性影響。

## 學習指南

* [《Google 搜尋中心 - 繁體中文》](https://developers.google.com/search?hl=zh_tw&card=seo)
* [《Google搜尋引擎最佳化初學者指南》](http://static.googleusercontent.com/media/www.google.com/en/us/intl/zh-tw/webmasters/docs/search-engine-optimization-starter-guide-zh-tw.pdf)
* [《Google 搜尋引擎最佳化 (SEO) 速記指南》](https://storage.googleapis.com/support-kms-prod/SNP_DE441AD549FEE9AE5B638F82579D99472297_3027140_zh-TW_v1)

## 檢測網站 SEO

* [關鍵字機會分析工具 Keyword Explorer](https://moz.com/explorer/lists/keywords)
* [網站速度檢測 Google Pagespeed](https://developers.google.com/speed/pagespeed/insights/?hl=zh-TW)
* [網站速度分析工具 WebPagetest](https://www.webpagetest.org/)
* [網站應用工具審查 Lighthouse Web App](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk?hl=zh-tw)
* [行動裝置相容性測試Google](https://search.google.com/test/mobile-friendly?utm_source=mft&utm_medium=redirect&utm_campaign=mft-redirect)
* [網站優化工具 Google Search Console](https://www.google.com/webmasters/tools/home?hl=zh-TW)
* [網站分析統計工具(1) Google Analytics](https://analytics.google.com/analytics/web/)
* [網站分析統計工具(2) Clicky](https://clicky.com/)
* [反向連結抓取工具(1) Open Site Explorer](https://moz.com/researchtools/ose/)
* [反向連結抓取工具(2) Majestic](https://zh.majestic.com/)
* [品牌知名度檢測工具(需註冊登入) Fresh Web Explorer](https://moz.com/researchtools/fwe/)

## 七個成功的SEO步驟

1. 必須讓搜尋引擎可以簡單地抓取你的網站內容。
    * 就算你的網站內容非常優質，如果各大搜尋引擎無法分析並檢索你的內容，最後也將石沉大海之中

2. 讓搜尋者可以得到他們想要或是超出他們預期的內容。
    * 每個搜尋資料的人都想要快速的達到目的，如果你可以一次性的滿足搜尋者的需求，他將不會再去找尋其它網站，也代表你的網頁就是最後的決定，這對SEO是非常有助益的

3. 適當優化你的文章內容關鍵字以便吸引搜尋者與搜尋引擎。
    * 搜尋引擎是依照搜尋大的意圖來做排序的判斷，如果你可以很好的掌握，標題與文章內容，並獲取大多數人的青睞，相同的也會貼近搜尋引擎的喜好，排名提升也不是難事

4. 出色的用戶體驗，包含網頁速度和使用者體驗。
    * 可以參考自己的瀏覽網站經驗，大部分人都不喜歡在很慢的網頁上瀏覽或是看著編排的亂糟糟的網頁不知如何下手，所以好好安排你的網站並且留意多人瀏覽時是否會造成網頁延遲

5. 分享有價值的內容來獲得外部連結、引用來擴展你的網站。
    * 想讓網站排名上升最好的方式沒有之一，就是讓你的網頁更有價值，並且讓人願意分享並且收錄你的網頁，當你的網頁被越多人分享與轉錄，你的排名也會越來越好

6. 用心思在文章標題、連結、描述上，可以在排名上得到好的點擊率。
    * 如果你想到有創意並且不禁會讓人多看一眼的文案或是標題，一定要放上去你的網站，這會讓你的網站在搜尋到達頁上眼中一亮並且帶動點擊率也會上升不少

7. 使用結構化標記與複合資料在搜尋結果頁面(SERPs)上脫穎而出。
    * 使用Snippet/schema markup 告訴搜尋引擎你的網站架構分布，讓你的網站內容更容易讓搜尋引擎使用

## robots.txt

參考： [Google 如何解讀 robots.txt 規格](https://developers.google.com/search/docs/advanced/robots/robots_txt?hl=zh-tw)

基本會用的幾個參數分別如下：

* User-agent
    * 定義下述規則對哪些搜尋引擎生效，即是對象。
* Disallow
    * 指定哪些目錄或檔案類型不想被檢索，需指名路徑，否則將會被忽略。
* Allow
    * 指定哪些目錄或檔案類型可能被檢索，需指名路徑，否則將會被忽略。
* Sitemap
    * 指定網站內的 sitemap 檔案放置位置，需使用絕對路徑。

基本用法：

允許所有搜尋引擎檢索所有內容(通常建議使用)

```plain
User-agent: *
Disallow:
```

拒絕所有搜尋引擎檢索所有內容：

```plain
User-agent: *
Disallow: /
```

拒絕所有搜尋引擎檢索/members/底下所有內容：

```plain
User-agent: *
Disallow: /members/
```

拒絕Google搜圖的爬蟲檢索/images/底下所有內容：

```plain
User-agent: Googlebot-image
Disallow:/images/
```

拒絕所有搜尋引擎檢索網站內png為副檔名的圖檔。

```plain
User-agent: *
Disallow: *.png$
```

拒絕Bing搜尋引擎檢索網站內/wp-admin目錄底下所有內容及網站內開頭為test的所有檔名。

```plain
User-agent: bingbot
Disallow: /wp-admin/
Disallow: ^test*
```

## 技巧

* 限制網頁只有 125 KB
    * Bing 搜尋引擎檢索網頁只限前 125K 左右。所以你應該確保重要內容出現在前面。
        * Bing 官方建議說「如果網頁包含大量的程式碼，搜尋引擎可能無法完全取得該頁面的內容。沒有直接關聯的程式碼會將網頁資源中的內容往下推，使搜尋引擎編目程式更難達到。原則上限為 125 KB，以確保編目程式能夠在網頁資源中快取所有內容和連結。這基本上表示如果網頁大小過大，搜尋引擎可能無法獲取所有內容，或者可能無法完全快取。」
            * 改善方法：請確定網頁原始碼未在網頁頂端包含大量的 CSS 或程式碼。請考慮將程式碼與樣式移到個別的檔案中。
    * 這個原則亦適用於 Google 搜尋引擎。

* 如果要讓網站顯示於搜尋引擎的的顯示中文的搜尋結果，那就要讓搜尋引擎很清楚這個網站的語言就是中文如果網站的編碼用 Big5，那麼毫無疑問，網站的主要語言就是中文但如果用 UTF-8 編碼的中文網站，而且 url 本身也看不出地區(如非 .tw)，怎麼辦？可以在 html 指定語言 `<html lang="zh-tw">` 並不是說不寫，搜尋引擎就搜尋不出來，只是說搜尋引擎會比較懷疑你網站的資料是否一定是繁體中文，相對的搜尋引擎給你的評分自然會比較低。

## 實用工具

* [Facebook 分享偵錯工具](https://developers.facebook.com/tools/debug/)

## 其他議題

### Google Medic Update 做了那些改變? YMYL是什麼?

他所代表的意思很簡單，就是“Your Money or Your Life.”，中文來就就是，生活與財產相關的網頁，將來GOOGLE對於YMYL相關的內容將更為重視。

哪些是YMYL的網頁呢?

雖然GOOGLE有提到Money字眼，但是他說的內容涵蓋並不單單只是金錢，據GOOGLE所描述的，任何可以影響人們健康、快樂、安全或是財務的網站頁面都是屬於YMYL範圍內。

例如：

1. 如果你的網站或是在網頁中有提到股票相關提示，它就是YMYL的範圍。
2. 如果正在部落格中發表關於育兒的經驗或是給其他媽媽們一些建議，它就是YMYL的範圍。
3. 如果你的網站中有關於判斷疾病症狀的內容，它也是YMYL的範圍。

### SERP 功能

SERP 為 Search Engine Results Page 縮寫，中文直譯為「搜尋引擎結果頁」，意思就是在GOOGLE 搜尋你的關鍵字之後，在瀏覽器上所呈現的搜尋結果的網頁，但是目前所呈現的內容跟幾年之前傳統排序的搜尋結果，來說內容已經差距非常大，以下就是目前最普通的SERP特徵：
 
1. 片段摘錄 為已經搜尋出來的結果增加視覺層次。(例如：為產品評分與商家評論幾顆星)
2. 付費結果 商家購買競價的關鍵字廣告將呈現於搜尋結果網頁。(例如：AdWords 關鍵字廣告與 Google 商家廣告)
3. 通用結果 除了自然˙搜尋以外的一般通用搜尋結果都是。(例如：圖片搜尋結果、最新搜尋結果、精選片段)
4. 知識圖表 由數據圖表或是資訊框的方式呈現。(例如：氣象面板、名人介紹面板、知識面板)

在2001年以前，Google 都是採用自然搜尋方式呈現「搜尋引擎結果頁」，但是2001之後開始加入其它非自然搜尋結果，直到現在已經是非常多樣化。

## 參考文章

* [SEO教學 - SEO初學者指南](https://www.newscan.com.tw/all-seo/seo-guide.htm)
* [Bing SEO, Yahoo SEO, Google SEO 優化分別和比較](https://blog.welldevelop.com/bing-seo%E5%92%8Cgoogle-seo%E5%84%AA%E5%8C%96%E7%9A%84%E5%88%86%E5%88%A5%E6%AF%94%E8%BC%83/)
* [Google網站核心指標Core web vitals(LCP、FID、CLS)是什麼？5大SEO UX重點優化項目](https://awoo.ai/zh-hant/blog/core-web-vitals-guide/)
