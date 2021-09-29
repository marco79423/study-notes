# NATS 學習筆記

* NATS-Server （NATS）
    * 一個開源的、雲原生的、高效能的訊息傳遞系統，是 NATS 最基礎的產品。
    * 核心是一個釋出/訂閱（Pub/Sub）系統，客戶端可以在不同叢集中的服務間 NATS 進行通訊，而不需要關注具體的訊息在哪個服務上。
    * 基於「最多一次」交付模型，不進行任何持久性處理，所以如果訂閱者的系統掛掉，訊息就有可能丟失。
    * 支援多流多服務進行 pub/sub、負載均衡，保障訊息最多/最少一次送達，多租戶和使用者認證等功能。
    * 效能非常好

* NATS Streaming Server（STAN）
    * STAN 添加了持久化功能和訊息送達策略支援。
    * NATS 客戶端 和 NATS Streaming Server 客戶端之間不能相互交換資料。
        * 也就是說，如果一個NATS Streaming Server客戶端在foo上釋出訊息，在同一主題上訂閱的NATS客戶端將不會收到訊息。
        * NATS Streaming Server 訊息是由 protobuf 組成的NATS訊息。NATS Streaming
          Server要向生產者傳送ACK，並接收消費者的ACK，所以如果與NATS客戶端自由交換訊息，就會引起問題。
    * 但是 STAN 雖然提供了持久化和訊息傳遞策略支援，但是在架構設計上卻出現了問題，導致在最開始設計時遺留了很多問題，比如當你確定 stan 叢集是固定的不能無限制水平擴容( #999 )，比如不支援多租戶功能( #1122 )，比如客戶端無法主動拉取訊息只能被推送等等
    * 當使用NATS流發布消息時,發布的消息被持久化到一個可定製的存儲中,由於具備發布者和訂閱者提供ACK消息、發布者速率限制和每個訂閱者速率匹配/限制的能力，這樣我們可以重用發布的消息為消費者提供“At-least-once-delivery”模式。
    * 隨著NATS 2.0的出現，NATS的生態系統也得到了很大的發展，NATS 2.0提供了分佈式安全、去中心化管理、多租戶、更大的網絡、全球可擴展以及安全的數據共享。但NATS流在適應NATS 2.0方面存在很多限制，而且流系統還沒有發展到能夠應對下一代物聯網和邊緣計算的挑戰
    * 個人覺得除了 Golang 以外，其他語言的支援很差

* NATS JetStream（JetStream）
    * 是 NATS 基於 Raft 演算法實現的最新的架構設計嘗試解決上述問題的新方案。
    * 提供了新的持久化功能和訊息送達策略，同時支援水平擴容。
    * 嵌入 NATS Server 中作為其中的一個功能存在。

## NATS Streaming (被淘汰了)

### Durable Subscription

NATS Streaming 有 Durable Subscription 的概念，如果有設定 Durable Name，NATS Server 就會維護一份 subscription 記錄 (以 clientID + Durable
Name 為 Key)。

意思是如果沒有設定 Durable Name，NATS 就不會管 client 上次最後收到最後的訊息是什麼，直接送最新的。反過來說，如果有設定就會從 client 上次斷線的地方重新送訊息。

例子：

- MPS 需要設定 Durable Name，因為不能因為 MPS 掛掉，中間的訊息就不處理了
- 而 GS 不需要設定 Durable Name，因為他只需要知道最新的，漏掉的都不用管。

### Subscription 和 Queue Subscription

NATS Streaming 可以分為普通的 Subscription 和 Queue Subscription，現在有多個 client 訂閱同一個 topic，如果是普通的 Subscription，每次有新的 event，NATS
就會將這個 event 送往每個 client，但如果是 Queue Subscription，NATS 同一個 group 只會輪流送一個 client。

例子：

- MPS 需要使用 Queue Subscription，因為它必須確保如果有多台 MPS 時，同樣的訊息不會重覆被處理
- GS 則是使用普通的 Subscription (其實就是空的 group)，因為每個 GS 都要收到同樣的訊息才行

### MaxReconnect

Client 發現斷線後，如果有設定重連，就會自動重連，但預設的 MaxReconnect 只會有 60 次(Go 的官方庫是這樣，其他函式庫不確定)，而且每次重連只會等 2 秒，換言之如果真的斷了只會試兩分鐘就不試了，所以可以將
MaxReconnect 改為負值，這樣他就不會放棄重連。

### ManualAck

可以設定 ManualAck，因為有收到訊息不代表處理會成功，如果不成功我們需要 NATS 的重送機制，所以設定手動 Act，那麼 NATS 就會在超過時間沒有 Ack 的情況下自動重送。

NATS Streaming 沒有 NACK 的方法，要等到之後的 JetStream 才有。

### 重線重連

雖然低層的 NATS 可以自動重連，但不代表 NATS Streaming 會重新訂閱，所以對 NATS Streaming 來說，重連這件事並不是透明的，必須要另外處理。

## JetStream

* nats.DeliverAll() [預設]
    * 會讀取有效生命週期內的所有訊息，甚至包含已被處理的訊息
* nats.DeliverLast()
    * 包含訊息佇列中的最後一條訊息，即使被處理過的訊息
* nats.DeliverNew()
    * 只處理訂閱之後的新訊息
* nats.StartSequence(seq)
    * 從 seq 開始收，從 1 開始

## 心得

* push base 可能會重覆收
* subscribe 不用 queue 時，不能用同樣的 durable name
* pull subscribe 一定要 ack
* push base 太大量時可能會產生 slow consumer (改 max_pending 可緩解)

## 參考資料

* [NATS-Server(JetStream)和NATS Streaming Server對比](https://www.gushiciku.cn/pl/g4zz/zh-tw)
* [基于NATS JetStream构建分布式事件流系统](https://www.jianshu.com/p/27a49b9d4306)
