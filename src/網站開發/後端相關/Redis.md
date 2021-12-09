# Redis 學習筆記

## 持久化

提供了兩種持久化方案：

* RDB 方式（默認）
    * RDB方式是通過快照（snapshotting）完成的，當符合一定條件時會自動將內存中的數據進行快照並持久化到硬盤。
    * 觸發快照的時機
        * 符合自定義配置的快照規則 redis.conf
        * 執行 save 或者 bgsave 命令
        * 執行 flushall 命令
        * 第一次執行主從復制操作
    * Redis 在進行快照過程中不會修改 RDB 文件，只有快照結束後才會將舊的快照文件替換為新的，也就是說任何時候RDB文件都是完成的，不存在中間狀態，保證了數據的完整性
    * 可以通過定時備份 RDB 文件來實現 Redis 數據庫的備份，RDB 文件是經過壓縮的二進制文件 ,佔用空間會小於內存中的數據，更加利於傳輸
    * 使用 RDB 方式進行持久化，如果異常宕機或者重啟，就會丟失最後一次快照之後的所有數據修改。
        * 需要根據具體的應用場景，通過組合設置自動快照條件的方式來將可能發生的數據損失控制在能夠接受范圍。
    * RDB 方式最大化了 Redis 性能，父進程在保存快照生成 RDB 文件時唯一要做的就是fork出一個子進程，然後這個子進程就會處理接下來的所有文件保存工作，父進程無需執行任何磁盤 I/O 操作。
        * 但如果數據集比較大的時候，fork 可能比較耗時，造成服務器在一段時間內會停止處理客戶端請求。
* AOF 方式（append only file）
    * 開啟 AOF 持久化後，每執行一條會更改 Redis 中的數據的命令， Redis 就會將該命令寫入硬盤中的 AOF 文件，這一過程顯然會降低 Redis 的性能，但大部分情況下這個影響是能夠接受的，另外使用較快的硬盤可以提高 AOF 的性能。

選擇方案

* 內存數據庫，數據不能丟：RDB（redis database）+ AOF
* 緩存服務器：RDB
* 不建議只使用 AOF (性能差)
* 恢復時：有 AOF 就先選擇 AOF 恢復，沒有的話選擇 RDB 文件恢復

## 實用工具

* [Redis Memory Analyzer](https://github.com/gamenet/redis-memory-analyzer)
* [Another Redis Desktop Manager](https://github.com/qishibo/AnotherRedisDesktopManager)

## 參考文章

* [Redis 主從復制，愛了](https://mp.weixin.qq.com/s/x1KNcAOMow4MWrDUYS3tVg)
