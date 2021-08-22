# NATS 學習筆記

## NATS Streaming

### Durable Subscription

NATS Streaming 有 Durable Subscription 的概念，如果有設定 Durable Name，NATS Server 就會維護一份 subscription 記錄 (以 clientID + Durable Name 為 Key)。

意思是如果沒有設定 Durable Name，NATS 就不會管 client 上次最後收到最後的訊息是什麼，直接送最新的。反過來說，如果有設定就會從 client 上次斷線的地方重新送訊息。

例子：

- MPS 需要設定 Durable Name，因為不能因為 MPS 掛掉，中間的訊息就不處理了
- 而 GS 不需要設定 Durable Name，因為他只需要知道最新的，漏掉的都不用管。


### Subscription 和 Queue Subscription

NATS Streaming 可以分為普通的 Subscription 和 Queue Subscription，現在有多個 client 訂閱同一個 topic，如果是普通的 Subscription，每次有新的 event，NATS 就會將這個 event 送往每個 client，但如果是 Queue Subscription，NATS 同一個 group 只會輪流送一個 client。

例子：

- MPS 需要使用 Queue Subscription，因為它必須確保如果有多台 MPS 時，同樣的訊息不會重覆被處理
- GS 則是使用普通的 Subscription (其實就是空的 group)，因為每個 GS 都要收到同樣的訊息才行

### MaxReconnect

Client 發現斷線後，如果有設定重連，就會自動重連，但預設的 MaxReconnect 只會有 60 次(Go 的官方庫是這樣，其他函式庫不確定)，而且每次重連只會等 2 秒，換言之如果真的斷了只會試兩分鐘就不試了，所以可以將 MaxReconnect 改為負值，這樣他就不會放棄重連。

### ManualAck

可以設定 ManualAck，因為有收到訊息不代表處理會成功，如果不成功我們需要 NATS 的重送機制，所以設定手動 Act，那麼 NATS 就會在超過時間沒有 Ack 的情況下自動重送。

NATS Streaming 沒有 NACK 的方法，要等到之後的 JetStream 才有。

### 重線重連

雖然低層的 NATS 可以自動重連，但不代表 NATS Streaming 會重新訂閱，所以對 NATS Streaming 來說，重連這件事並不是透明的，必須要另外處理。
