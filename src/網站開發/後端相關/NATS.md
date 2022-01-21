# NATS 學習筆記

已整理至 [淺談 NATS、STAN 和 JetStream 兩三事](https://marco79423.net/articles/%E6%B7%BA%E8%AB%87-natsstan-%E5%92%8C-jetstream-%E5%85%A9%E4%B8%89%E4%BA%8B)

## 補充資訊

### NATS

#### MaxReconnect

Client 發現斷線後，如果有設定重連，就會自動重連，但預設的 MaxReconnect 只會有 60 次(Go 的官方庫是這樣，其他函式庫不確定)，而且每次重連只會等 2 秒，換言之如果真的斷了只會試兩分鐘就不試了，所以可以將 MaxReconnect 改為負值，這樣他就不會放棄重連。

### STAN

#### 斷線重連

使用 STAN 的時候，雖然低層的 NATS 可以自動重連，但不代表 NATS Streaming 會重新訂閱，所以對 NATS Streaming 來說，重連這件事並不是透明的，必須要另外處理。

### JetStream

#### Retention Policy

* LimitsPolicy 為多少訊息、大小多舊設限制
* WorkQueuePolicy 一直保留，直到有人消費過就刪除 (還是會看多少訊息、大小多舊)
    * 有特殊要求，不能有多個 consumer 共用
* InterestPolicy 只要有消費者 active 就會保留 (還是會看多少訊息、大小多舊)

#### Discard Policy

設定訊息丟棄的策略

* DiscardOld 丟舊的
* DiscardNew 拒絕新訊息

#### DeliverPolicy

建立 Consumer 的時候，可以指定從什麼訊息開始

* DeliverAll 全送 預設 最早可用訊息開始收
* DeliverLast 最後的訊息 (好像有沒有 ack 都會)
* DeliverNew 創建 consumer 後新的，
* DeliverByStartSequence 從指定訊息開始 (需要設  OptStartSeq 開始的序列號 ) 根據 sequence 往前移重，最接近的可用訊息
* DeliverByStartTime 根據時間 (需要設 OptStartTime)

#### FlowControl

Consumer 控制的方法，不像 rate limit 依賴速度限制，而是根據訊息數量和大小控制

如果超過，server 就不會再送訊息 (server 會通知)，即使都 ack 了，除非 client tells ther server 好了
(不確定這個過程是手動還是自動)

#### IdleHeartbeat

如果有設置，太久沒送，server 會送 status，告訴 client 說還活著，只是沒新訊息

#### MaxAckPending

未 ack 最大訊息數，如果超過傳遞會暫停，不能和 acknone 一起用

#### MaxDeliver

傳遞訊息的最大次數，有些訊息會害程式掛掉，可以設定 MaxDeliver 限制傳遞的次數上限。

#### RateLimit

限制速度 bits per seconds

#### 命名規則

Stream、Consumer、Account 都是用檔案系統存的，所以命名必須遵守檔案系統的命名規則
(不要太長、不要特殊字元、不同作業系統可能有差異)

https://docs.nats.io/jetstream/administration/naming

## 參考資料

* [NATS Docs](https://docs.nats.io/)
* [nats-io/nats.go: Golang client for NATS, the cloud native messaging system.](https://github.com/nats-io/nats.go)
* [NATS-Server(JetStream)和NATS Streaming Server對比](https://www.gushiciku.cn/pl/g4zz/zh-tw)
* [基于NATS JetStream构建分布式事件流系统](https://www.jianshu.com/p/27a49b9d4306)
