# Docker 相關

## 學習資源

* [Docker 系列](https://medium.com/lily-engineer/docker/home)

## 基礎概念

Docker技術的三大核心概念，分別是：

* 鏡像（Image）
* 容器（Container）
* 倉庫（Repository）

## 基本操作


## 實用命令

* 刪除所有 docker container 和 images
    * 法一
        ```bash
        docker stop $(docker ps -a -q)  # 關閉所有 Docker Container
        docker rm $(docker ps -a -q)    # 刪除所有 Docker Container
        docker rmi $(docker images -q)  # 刪除所有 Docker Image
        ```
    * 法二
        ```bash
        docker system prune -a --volumes
        ```

## 議題

### Docker 跑資料庫？

可能的問題：

* 數據安全問題
    * 不要將數據儲存在容器中，這也是 Docker 官方容器使用技巧中的一條。
    * 容器隨時可以停止、或者刪除。當容器被rm掉，容器裡的數據將會丟失。雖然為了避免數據丟失，用戶可以使用數據卷掛載來存儲數據。但是容器的 Volumes 設計是圍繞 Union FS 鏡像層提供持久存儲，數據安全缺乏保證。如果容器突然崩潰，數據庫未正常關閉，可能會損壞數據。
        * 另外容器裡共享數據卷組，對物理機硬件損傷也比較大。
* 性能問題
    * MySQL 屬於關系型數據庫，對IO要求較高。當一台物理機跑多個時，IO就會累加，導致IO瓶頸，大大降低 MySQL 的讀寫性能。
    * 在一次Docker應用的十大難點專場上，某國有銀行的一位架構師也曾提出過：“數據庫的性能瓶頸一般出現在IO上面，如果按 Docker 的思路，那麼多個docker最終IO請求又會出現在存儲上面。
* 資源隔離方面
    * 資源隔離方面，Docker 確實不如虛擬機，Docker 是利用 Cgroup 實現資源限制的，只能限制資源消耗的最大值，而不能隔絕其他程序佔用自己的資源。如果其他應用過渡佔用物理機資源，將會影響容器裡 MySQL 的讀寫效率。
    * 需要的隔離級別越多，獲得的資源開銷就越多。相比專用環境而言，容易水平伸縮是 Docker 的一大優勢。然而在 Docker 中水平伸縮只能用於無狀態計算服務，數據庫並不適用。

可能的好處

* 對數據丟失不敏感的業務（例如用戶搜索商品）就可以利用數據庫分片來來增加實例數，從而增加吞吐量。
* docker適合跑輕量級或分佈式數據庫，當docker服務掛掉，會自動啟動新容器，而不是繼續重啟容器服務。

## 參考文章

* [你在 Docker 中跑 MySQL？恭喜你，可以下崗了！](https://mp.weixin.qq.com/s/LaADoyFEqfOPHtQ_XByI4Q)