# Linux/Unix 學習筆記

## 時間

* [奇怪！计算机时间居然会倒流？](https://mp.weixin.qq.com/s/qZRVpZ1VMtY_yHoJwtt2iw)

## Linux 源碼

* [你管这破玩意叫操作系统源码](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=Mzk0MjE3NDE0Ng==&action=getalbum&album_id=2123743679373688834)

## 中斷

* [認認真真的聊聊中斷](https://mp.weixin.qq.com/s/bTfeI5p4eO5j6I9edeV73g)
* [認認真真的聊聊"軟"中斷](https://mp.weixin.qq.com/s/g9rGKRQofAlWjdq8lDTTkQ?utm_source=pocket_mylist)

## 計算機的時間來源

推薦參考文章： https://mp.weixin.qq.com/s/A9fgd2xnp1YfHZ1iTMyXvw?utm_source=pocket_mylist

## 變成 root

已整理為文章： https://marco79423.net/articles/unix-%E8%AE%8A%E6%88%90-root/

## 行程 Process

已整理為文章： https://marco79423.net/articles/unix-%E8%A1%8C%E7%A8%8Bprocess/

## 禁止某使用者登入

已整理為文章： https://marco79423.net/articles/unix-%E7%A6%81%E6%AD%A2%E6%9F%90%E4%BD%BF%E7%94%A8%E8%80%85%E7%99%BB%E5%85%A5/

## Shadow Password

已整理為文章： https://marco79423.net/articles/unix-shadow-password/


## FreeBSD - Port 和 Package

已整理為文章： https://marco79423.net/articles/unix-ports-%E5%92%8C-package/

## 常見指令

### Cheat sheet

![](./images/linux_unix-1.png)

### find

已整理為文章： https://marco79423.net/articles/unix-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-find/

### less

已整理為文章： https://marco79423.net/articles/unix-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-less/

### wc

已整理為文章： https://marco79423.net/articles/unix-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-wc/

### sort

已整理為文章： https://marco79423.net/articles/unix-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-sort/

### grep

已整理為文章： https://marco79423.net/articles/unix-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-grep/

### cut

已整理為文章： https://marco79423.net/articles/unix-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-cut/

### rsync

rsync 是一個強大的檔案複製工具，能在複製檔案的時候自動判斷並只複製不同的檔案來減少複製所需的時間。 而且並不只限於本地端的複製，我們可以直接用 rsync 將一台電腦的檔案直接複製到另一台電腦。 並且複製到另一台電腦的過程有加密，還能選擇壓縮要傳輸的資料減少傳輸量，所以 rsync 非常適合用來當作檔案備份的工具。

#### rsync 基本用法

rsync 的語法和 scp 很相似，如果沒有指定 host，即表示本地端。

使用 rsync 的三種情境：

* 本地端的複製，就和 cp 相同
    ```shell
    rsync src dst
    ```

* 將本地端的資料複製到遠端電腦
    ```shell
    rsync src host:dst
    ```

* 將遠端電腦的檔案複製到本地端
    ```shell  
    rsync host:src dst
    ```

rsync 在和遠端電腦傳輸時，預設是使用 ssh 方式。

注意若要使用異地傳輸，兩台電腦都必須安裝 rsync，否則無法使用

一般來說，後面兩種應該是比較常用的方式，因為要保護資料，放在別台電腦自然會比較安穩， 也就是「異地備援」的概念。不過第一種狀況也不是不會發生， 比如說把資料從一顆硬碟複製到另一硬碟上，也是滿常見的做法。

> **註：** 「異地備援」的想法是將資料分開兩地存放，當一地發生問題時， 另一個地方就可以立即接手。 這樣一來就不會因為地理位置所發生的天災人禍等不可抗拒事件而中斷。 簡單來說就是把資料備份到別的地方的意思。

#### rsync 常用參數

* -a, –a
    * 大概是最常使用的參數，差別只在於要不上補上 -H 而已。
    * 封存模式(自己翻的)，相當於加上 -rlptgoD 這些參數，非常常用
    * 會抓取資料夾(預設看到資料夾會跳過)、捷徑(Symbolic links)， 並保留包含所有者、群組等相關資訊。不過除非加上 -H 不然不會保留硬式連結(Hard links)。
    * 要注意的是保留所有者時，只會 root 會有效， 不然從別人抓過來的檔案所有者還是會是自己。
    * 而硬式連結的詳細情況直接舉例說明。假設 src 這個資料夾有 a 和 c 兩個檔案， 而 c 是 a 的硬式連結，也就是說 a 改動的話， c 也會跟著改動。
    * 當打算將 src 裡的資料複製到 dest 時，若沒有加上 -H 參數， rsync 複製完後， dest 一樣會有 a 和 c 兩個檔案，差別在 a 和 c 的關係就不是硬式連結了，若 a 改動， c 不會跟著變化。但若加上 -H 參數，複製過來的 a 和 c 就會保持硬式連結的關係， a 改動 c 就會改動。

* -v, –verbose
    * 預設 rsync 運作時並不會顯示任何資訊，但若加上 -v，就會顯示傳輸時的詳細資料， 越多 v 就會顯示越多資訊。
    * 加上一個 v ，會顯示那些檔案被傳輸，並在最後顯示這次運作的總結。
    * 加上兩個 -v 多顯示那些檔案是被忽略掉的， 並在總結時附加更多相關資訊。 
    * 而超過兩個 -v 則是用來 debug 用的，平常用不到。

* -progress
    * 讓 rsync 在複製時顯示傳輸進度。

* -C, –cvs-exclude
    * 意思是排除不希望傳送的檔案，而且是採用和 CVS 相同的定義。
        * RCS SCCS CVS CVS.adm RCSLOG cvslog.* tags TAGS .make.state .nse_depinfo *~ #* .#* ,* _$* *$ *.old *.bak *.BAK *.orig *.rej .del-* *.a *.olb *.o *.obj *.so *.exe *.Z *.elc *.ln core .svn/ 檔案名稱符合這些條件的都會被忽略掉。

* -z, –compress
    * 表示傳輸時會壓縮資料。

* –delete
    * 用在同步資料的時候，意思是把目的資料夾裡無關的檔案刪掉。 換言之，複製完後兩個資料夾裡的內容會完全一樣。
    * 要注意的是這個參數只能作用在資料夾上，不能針對個別檔案， 來源和目的都要是資料夾，不然會出錯。
    * 另外在複製時，排除不複製的檔案，預設是不會刪的，除非加上 –delete-excluded 這個參數。
    * 舉個例子，假設甲地的資料要複製到乙地，而甲有 A、B 兩個檔案，第一次用 rsync 複製完後， 甲、乙兩地都會有 A、B 兩個一樣的檔案。假設這時甲地的 A 被刪掉了，第二次複製時， 若加上 –delete 這個參數，乙地的 A 就會被刪掉，反之，若不加上 –delete ，因為只是複製， 所以乙地的 A 一樣會保留。

#### 與遠端主機的互動

rsync 可以將資料複製到遠端主機，也可以將資料由遠端主機複製到本地。我們可以透過兩種方式達成這個目的，分別是：

* 使用像是 ssh 和 rsh 的軟體連接
* 直接使用 rsync daemon 連接

第一個方式就是先前所提及的方法，語法和 scp 相似，無論是遠端主機要複製內容到本地，還是本地複製到遠端主機， 只要是遠端主機的路徑，就用「遠端主機的名稱:遠端路徑」來表示。

#### 斜線的使用

有兩種使用情況，假設 src 和 dest 都是資料夾。

```shell
rsync -av src dest
```

意思是把 src 複製到 dest 這個資料夾裡，所以 dest 裡會出現 src 這個資料夾。

```shell
rsync -av src/ dest
```

意思是 src 這個資料夾裡面的內容複製到 dest 裡，所以複製完後 src 和 dest 裡面的資料會是一樣的。

所以下面兩種使用方式是同義的

```shell
rsync -av src src dest
```

```shell
rsync -av src/ dest/src
```

不過測試結果，似乎 dest 加不加斜線都不會影響結果。

> **註** scp 好像沒有這種差異。

#### 使用情境

基本上我們使用 rsync 的原因，大部分都是因為備份。所以我想特別討論 rsync 關於備份的議題。 網路上雖然有很多關於使用 rsync 備份的教學文章，甚至還有指令的範例，不過問題來了， 每個人備份的需求不同，直接照抄別人使用的指令，真的沒問題嗎？

而且很多篇文章的作者使用的指令似乎也是修改自另一篇文章的指令，而沒有真的去研究過 rsync 的說明文件。 所以常常會發生諸如「使用沒有意義的參數」、「忽略不該忽略的檔案」之類的問題。

所以我想盡量把各種我認為比較常見的用法整理出來，並附上說明， 讓每個人都可以依據自己的需求調整適合自己的設定。

#### 隱藏議題

這裡會有一個隱藏的議題，那就是備份的內容我平常可能不會使用， 所以是不是可以透過壓縮的方式來減少我空間的佔用量呢？

所以說，首先要掌握的是如何用 rsync 來同步資料。

>>> rsync -aHz --delete --progress 來源路徑 遠端路徑

基本上如果想把一個地方的資料，完整的複製到另一個地方，就是使用 -aH 這兩個參數， -a 包含了複製資料夾、檔案權限和捷徑等內容，相當於(-rlptgoD)，而加上 -H 則是保留硬式連結的資訊。原則上透過這兩個參數， 就可以完整複製資料，而不會遺漏資訊了。

加上 –delete 是為了要同步，我們要讓兩個地方的資料完全一樣，就必須要加上這個參數(詳情請閱前文)。

至於 -z 的部分則是壓縮傳輸的資料，我個人是覺得不加白不加，但要知道 -z 是壓縮傳輸的資料，而不是壓縮結果， 所以複製過去的檔案與來源沒什麼不同，不要搞錯。

至於 –progress 就是個人喜好了，看是要單純用這個參數顯示進度，還是要再加上 -v 或 -v -v 增加要顯示的資訊， 又或是不想顯示進度，但是想顯示傳輸的檔案都沒問題。

接下來考慮另一個問題，那就是要資料應該備份到那裡呢？在此我簡單分為兩種情況，一是備份到本地， 另一是本地備份到遠端主機(或遠端主機備份到本地)。

備份到本地我不提，直接使用先前說的指令即可。比較不一樣的是備份到遠端主機上的情況， 備份到遠端主機有兩種方法，用的指令有所不同。

**>>>** rsync -e "/usr/bin/ssh" -avz --delete

#### 進階議題

* [實際使用的演算法](http://rsync.samba.org/tech_report/)
* Rsync 會在傳輸時做排序，這是為了像是方便刪除重覆的檔案等的原因， 所以發現傳輸的順序和指定的順序不同，不用覺得驚訝。
