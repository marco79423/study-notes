# Mongo 學習筆記

## BASE 原則

CAP 理論，在一個分散式的資料儲存架構下，不可能同時滿足下面三個條件：

* Consistency (一致性)
    * 在任何時刻，所有節點的資料須保持一致
* Availability (可用性) 
    * 在正常的響應時間 (response time) 內，使用者都要能夠會得回應
* Partition tolerance
    * (分區容錯性)：在部分區域故障的時候，仍然能夠提供滿足一致性與可用性的服務

為了達到 Partition tolerance，能夠持續提供不間斷的服務給今日大量的使用者，就需要在 Consistency 和 Availability 兩者之間做出妥協。

* Basically Available
    * 保持服務基本可用
* Soft State
    * 狀態可以有一段時間的不同步
* Eventual consistency (最終一致性)
    * 雖然有一段時間不同步，但追求最後結果一致

## 非關聯式資料庫（NoSQL）

特色：

* 不需要事先定義好資料的 schema 以及資料之間的關聯
* 可以自由新增欄位，不需要回頭修改過去的資料文件 (document)
* 可以自由定義資料文件 (document) 的結構

不同於關聯式資料庫使用資料表行與列的的二元關係呈現，NoSQL 的儲存資料的方式相當多元，像是

* Key-Value Cache (e.g. Memcached, Redis)
* Key-Value Store (e.g. Oracle NoSQL Database, Redis)
* Document Store (e.g. MongoDB, Elasticsearch)
* Wide Column Store (e.g. Amazon DynamoDB)
* Graph (e.g. ArangoDB, OrientDB )

## 參考文章

* [是否該用 MongoDB？選擇資料庫前你該了解的事](https://tw.alphacamp.co/blog/mysql-and-mongodb-comparison)
