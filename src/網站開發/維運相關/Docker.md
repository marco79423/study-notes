# Docker 相關

Docker 是當前流行的 Linux 容器解決方案

是一個開源的應用容器引擎，讓開發者可以打包他們的應用以及依賴包到一個可移植的容器中，然後發布到任何流行的 Linux 機器上，也可以實現虛擬化。容器是完全使用沙箱機制，相互之間不會有任何接口。

* Build, Ship and Run（搭建、運輸、運行）
* Build once, Run anywhere（一次搭建，處處運行）

## 基礎概念

Docker技術的三大核心概念，分別是：

* 鏡像（Image）
* 容器（Container）
* 倉庫（Repository）

## 基礎原理

利用 Namespaces 、Cgroups 以及聯合文件系統UnionFS 實現了同一主機上容器進程間的相互隔離。

* NameSpaces
    * 隔離進程，讓進程只能訪問到本命名空間裡的掛載目錄、PID、NetWork 等資源
* Cgroups
    * 限制進程能使用的計算機系統各項資源的上限，包括 CPU、內存、磁盤、網絡帶寬等等
* 聯合文件系統 UnionFS
    * 保存一個操作系統的所有文件和目錄，在它基礎之上添加應用運行依賴的文件。創建容器進程的時候給進程指定Mount Namespace 把鏡像文件掛載到容器裡，用 chroot 把進程的 Root目錄切換到掛載的目錄裡，從而讓容器進程各自擁有獨立的操作系統目錄。

## 基本操作

### 實用命令

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

## Dockerfile

### FROM

指定基礎鏡像，所有構建的鏡像都必須有一個基礎鏡像，且 FROM 命令必須是 Dockerfile 的第一個命令

* `FROM <image> [AS <name>]`
    * 指定從一個鏡像構建起一個新的鏡像名字
* `FROM <image>[:<tag>] [AS <name>]`
    * 指定鏡像的版本 Tag
* 示例
    * `FROM mysql:5.0 AS database`

### MAINTAINER

鏡像維護人的信息

`MAINTAINER <name>`

示例： `MAINTAINER marco79423`

### RUN


構建鏡像時要執行的命令

`RUN <command>`

示例： `RUN ["executable", "param1", "param2"]`

### ADD

將本地的文件添加復制到容器中去，壓縮包會解壓，可以訪問網絡上的文件，會自動下載

`ADD <src> <dest>`

示例： `ADD *.js /app` 添加 js 文件到容器中的 app 目錄下

### COPY

功能和 ADD 一樣，只是復制，不會解壓或者下載文件

### CMD

啟動容器後執行的命令，和 RUN 不一樣，RUN 是在構建鏡像是要運行的命令

當使用 docker run 運行容器的時候，這個可以在命令行被覆蓋

示例： `CMD ["executable", "param1", "param2"]`

### ENTRYPOINT

也是執行命令，和 CMD 一樣，只是這個命令不會被命令行覆蓋

`ENTRYPOINT ["executable", "param1", "param2"]`

示例： `ENTRYPOINT ["donnet", "myapp.dll"]`

### LABEL

為鏡像添加元數據，key-value 形式

`LABEL <key>=<value> <key>=<value> ...`

示例： `LABEL version="1.0" description="這是一個web應用"`

### ENV

設置環境變量，有些容器運行時會需要某些環境變量

* `ENV <key> <value>` 
    * 一次設置一個環境變量
* `ENV <key>=<value> <key>=<value> <key>=<value>` 
    * 設置多個環境變量

示例：`ENV JAVA_HOME /usr/java1.8/`

### EXPOSE

暴露對外的端口（容器內部程序的端口，雖然會和宿主機的一樣，但是其實是兩個端口）

`EXPOSE <port>`

示例： `EXPOSE 80`

容器運行時，需要用 -p 映射外部端口才能訪問到容器內的端口

### VOLUME

指定數據持久化的目錄，官方語言叫做掛載

* `VOLUME /var/log`
    * 指定容器中需要被掛載的目錄，會把這個目錄映射到宿主機的一個隨機目錄上，實現數據的持久化和同步。
* `VOLUME ["/var/log","/var/test".....]`
    * 指定容器中多個需要被掛載的目錄，會把這些目錄映射到宿主機的多個隨機目錄上，實現數據的持久化和同步
* `VOLUME /var/data var/log`
    * 指定容器中的 var/log 目錄掛載到宿主機上的 /var/data 目錄，這種形式可以手動指定宿主機上的目錄

### WORKDIR

設置工作目錄，設置之後 ，RUN、CMD、COPY、ADD 的工作目錄都會同步變更

`WORKDIR <path>`

示例： `WORKDIR /app/test`

### USER

指定運行命令時所使用的用戶，為了安全和權限起見，根據要執行的命令選擇不同用戶

`USER <user>:[<group>]`

示例： `USER test`

### ARG

設置構建鏡像是要傳遞的參數

* `ARG <name>[=<value>]`

示例： `ARG name=sss`

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

## 學習資源

* [Docker 系列](https://medium.com/lily-engineer/docker/home)

## 參考文章

* [你在 Docker 中跑 MySQL？恭喜你，可以下崗了！](https://mp.weixin.qq.com/s/LaADoyFEqfOPHtQ_XByI4Q)
* [解惑篇｜Docker和 K8s 到底啥关系？想学K8s，必须得先学 Docker 吗？](https://mp.weixin.qq.com/s?__biz=MzUzNTY5MzU2MA==&mid=2247493651&idx=1&sn=e9793e68375e5ef2c48e7cf8a53459f8&chksm=fa833984cdf4b09281adad62b748c9567536fd56c9a659cff800ac154be168b25e8c59f39f44&token=2015934396)
* [寫給前端的 Docker 入門終極指南，別再說不會用 Docker 了！](https://mp.weixin.qq.com/s/oEygasL-5owZ5b8mV6uMTw)
