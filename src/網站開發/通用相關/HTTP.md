# HTTP 學習筆記

## 快取

如果讓大家設計 HTTP 的快取功能，大家會怎麼設計呢？

最容易想到的就是指定一個時間點了，到這個時間之前都直接用快取，過期之後才去下載新的。

HTTP 1.0 的時候也是這麼設計的，也就是 Expires 的 header，它可以指定資源過期時間，到這個時間之前不去請求伺服器，直接拿上次下載好被快取起來的內容。

```http
Expires: Wed, 21 Oct 2021 07:28:00 GMT
```

但是這種設計有個 bug，那就是假定瀏覽器的時間是精準的，但萬一瀏覽器的時間不准就會出問題，所以過期時間不能讓伺服器端來算，應該讓瀏覽器自己算。

這也是為什麼在 HTTP 1.1 里面改為了 max-age 的方式：

```http
Cache-Control: max-age=600
```

上面就代表資源快取 600 秒，也就是 10 分鐘。

讓瀏覽器來自己算啥時候過期，也就沒有 Expires 的問題了。（這也是為什麼同時存在 max-age 和 Expires 會用 max-age 的原因）

但即使過期了，資源並不一定有變化呀，再下載一次同樣的內容還是很沒必要。所以 HTTP 1.1 又設計了協商快取的 header。

兩種方法

* 通過檔案內容的 hash，叫 Etag
* 通過最後修改時間，則是 Last-Modified

```http
etag: "fadfafawdfasdfadfad"
last-modified: Thu, 04 Mar 2021 08:04:12 GMT
```

那在 max-age 時間到了的時候，就可以帶上 etag 和 last-modified 就請求伺服器，問下是否資源有更新。

帶上 etag 的 header 叫做 If-None-Match:

```http
If-None-Match: "bfc13a64729c4290ef5b2c2730249c88ca92d82d"
```

帶上 last-modified 時間的叫做 If-Modified-Since：

```http
If-Modified-Since: Wed, 21 Oct 2015 07:28:00 GMT
```

如果資源有變化，伺服器端就返回 200，並在響應體帶上新的內容，瀏覽器就用這份新下載的資源。如果沒有變化，就返回 304，響應體是空的，瀏覽器會直接讀快取。

如果檔案確定不會變，不需要協商的話，怎麼告訴瀏覽器呢？可以用 immutable 的 directive 來告訴瀏覽器，這個資源就是不變的，不用協商了。這樣就算快取過期了也不會發驗證的 header

```http
Cache-control: immutable
```

簡單總結一下，HTTP 1.0 的時候是使用 Expires 的 header 來控制的，指定一個 GMT 的過期時間，但是當瀏覽器時間不准的時候就有問題了。

HTTP 1.1 的時候改為了 max-age 的方式來設定過期時間，讓瀏覽器自己計算。並且把所有的快取相關的控制都放到了 Cache-control 的 header 裡，像 max-age 等叫做指令。

快取過期後，HTTP 1.1 還設計了個協商階段，會分別通過 If-None-Match 和 If-Modified-Since 的 header 帶資源的 Etag 和 Last-Modied 到伺服器端問下是否過期了，過期了的話就返回 200 帶上新的內容，否則返回 304，讓瀏覽器拿快取。

### 其他相關語法

* public：允許代理伺服器快取資源
* s-maxage：代理伺服器的資源過期時間
* private：不允許代理伺服器快取資源，只有瀏覽器可以快取
* immutable：就算過期了也不用協商，資源就是不變的
* max-stale：過期了一段時間的話，資源也能用
* stale-while-revalidate：在驗證（協商）期間，返回過期的資源
* stale-if-error：驗證（協商）出錯的話，返回過期的資源
* must-revalidate：不允許過期了還用過期資源，必須等協商結束
* no-store：禁止快取和協商
* no-cache：允許快取，但每次都要協商

瀏覽器裡的快取都是使用者自己的，叫做私有快取，而代理伺服器上的快取大家都可以訪問，叫做公有快取。如果這個資源只想瀏覽器裡快取，不想代理伺服器上快取，那就設定 private，否則設定 public：

```http
Cache-control:public, max-age=600,s-maxage:31536000
```

這樣設定就是資源可以在代理伺服器快取，快取時間一年（代理伺服器的 max-age 用 s-maxage 設定），瀏覽器裡快取時間 10 分鐘。

快取過期了就完全不能用了麼？

不是的，其實也想用過期的資源也是可以的，有這樣的指令：

```http
Cache-control: max-stale=600
```

stale 是不新鮮的意思。請求裡帶上 max-stale 設定 600s，也就是說過期 10 分鐘的話還是可以用的，但是再長就不行了。

也可以設定 stale-while-revalidate，也就是說在和瀏覽器協商還沒結束的時候，就先用著過期的快取吧。

```http
Cache-control: stale-while-revalidate=600
```

或者設定 stale-if-error，也就是說協商失敗了的話，也先用著過期的快取吧。

```http
Cache-control: stale-if-error=600
```

所以說，max-age 的過期時間也不是完全強制的，是可以允許過期後用一段時間的。

那如果我想強制在快取還沒協商完的時候不用過期的快取怎麼辦呢？就用指令 must-revalidate：

```http
Cache-Control: max-age=31536000, must-revalidate
```

名字上就可以看出來，就是快取失效了的話，必須等驗證結束，中間不能用過期的快取。

最後，HTTP 當然也支援禁止快取，也就是這樣：

```http
Cache-control: no-store
```

設定了 no-store 的指令就不會快取檔案了，也就沒有過期時間和之後的協商過程。

如果允許快取，但是需要每次都協商下的話就用 no-cache:

```http
Cache-control: no-cache
```

## 參考文章

* [HTTP 的快取為什麼這麼設計？](https://mp.weixin.qq.com/s?__biz=Mzg3OTYzMDkzMg==&mid=2247490336&idx=1&sn=fc9a3fcd2e0263308577127cb1820590&scene=21)