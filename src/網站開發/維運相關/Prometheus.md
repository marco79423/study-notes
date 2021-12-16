# Prometheus 學習筆記

## 簡介

* 原作者是 Matt T. Proud，從 Google 的集群管理器 Borg 和它的監控系統 Borgmon 中獲取靈感，開發了開源的監控系統 Prometheus，和 Google 的很多項目一樣，使用的編程語言是 Go
* 為了統一雲計算接口和相關標准，2015 年 7 月，隸屬於 Linux 基金會的 雲原生計算基金會（CNCF，Cloud Native Computing Foundation） 應運而生。第一個加入 CNCF 的項目是 Google 的 Kubernetes，而 Prometheus 是第二個加入的（2016 年）

* 關於他們為什麼需要新開發一個監控系統的文章 Prometheus: Monitoring at SoundCloud，在這篇文章中，他們介紹到，他們需要的監控系統必須滿足下面四個特性：
    * 多維度數據模型
    * 方便的部署和維護
    * 靈活的數據採集
    * 強大的查詢語言

多維度數據模型和強大的查詢語言這兩個特性，正是時序數據庫所要求的，所以 Prometheus 不僅僅是一個監控系統，同時也是一個時序數據庫。

> **註：**  
>
> 時序數據庫（Time Series Database, TSDB）
>
> 很多流行的監控系統都在使用時序數據庫來保存數據，這是因為時序數據庫的特點和監控系統不謀而合。
>
> * 增：需要頻繁的進行寫操作，而且是按時間排序順序寫入
> * 刪：不需要隨機刪除，一般情況下會直接刪除一個時間區塊的所有數據
> * 改：不需要對寫入的數據進行更新
> * 查：需要支持高並發的讀操作，讀操作是按時間順序升序或降序讀，數據量非常大，緩存不起作用
>
> DB-Engines 上有一個關於時序數據庫的排名，下面是排名靠前的幾個（2018年10月）：
>
> * InfluxDB：https://influxdata.com/
> * Kdb+：http://kx.com/
> * Graphite：http://graphiteapp.org/
> * RRDtool：http://oss.oetiker.ch/rrdtool/
> * OpenTSDB：http://opentsdb.net/
> * Prometheus：https://prometheus.io/
> * Druid：http://druid.io/

此外，Prometheus 數據採集方式也非常靈活。要採集目標的監控數據，首先需要在目標處安裝數據採集組件，這被稱之為 Exporter，它會在目標處收集監控數據，並暴露出一個 HTTP 接口供 Prometheus 查詢，Prometheus 通過 Pull 的方式來採集數據，這和傳統的 Push 模式不同。

不過 Prometheus 也提供了一種方式來支持 Push 模式，你可以將你的數據推送到 Push Gateway，Prometheus 通過 Pull 的方式從 Push Gateway 獲取數據。目前的 Exporter 已經可以採集絕大多數的第三方數據，比如 Docker、HAProxy、StatsD、JMX 等等，官網有一份 Exporter 的列表。

## 架構圖

![prometheus-1](./images/prometheus-1.webp)

Prometheus 生態系統包含了幾個關鍵的組件：Prometheus server、Pushgateway、Alertmanager、Web UI 等，但是大多數組件都不是必需的，其中最核心的組件當然是 Prometheus server，它負責收集和存儲指標數據，支持表達式查詢，和告警的生成。

## 設定檔

```yaml
# my global config  
global:  
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.  
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.  
  # scrape_timeout is set to the global default (10s).  
   
# Alertmanager configuration  
alerting:  
  alertmanagers:  
  - static_configs:  
    - targets:  
      # - alertmanager:9093  
   
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.  
rule_files:  
  # - "first_rules.yml"  
  # - "second_rules.yml"  
   
# A scrape configuration containing exactly one endpoint to scrape:  
# Here it's Prometheus itself.  
scrape_configs:  
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.  
  - job_name: 'prometheus'  
   
    # metrics_path defaults to '/metrics'  
    # scheme defaults to 'http'.  
   
    static_configs:  
    - targets: ['localhost:9090']  
```

Prometheus 默認的配置文件分為四個部分：

* global
    * Prometheus 的全局配置，比如 scrape_interval 表示 Prometheus 多久抓取一次數據，evaluation_interval 表示多久檢測一次告警規則
* scrape_config
    * 這裡定義了 Prometheus 要抓取的目標，我們可以看到默認已經配置了一個名稱為 prometheus 的 job，這是因為 Prometheus 在啟動的時候也會通過 HTTP 接口暴露自身的指標數據，這就相當於 Prometheus 自己監控自己，雖然這在真正使用 Prometheus 時沒啥用處，但是我們可以通過這個例子來學習如何使用 Prometheus
    * 可以訪問 http://localhost:9090/metrics 查看 Prometheus 暴露了哪些指標；
* rule_files
    * 告警規則
* alerting
    * 關於 Alertmanager 的配置

## PromQL

Prometheus 提供一種特殊表達式來查詢監控數據，這個表達式被稱為 PromQL（Prometheus Query Language）。通過 PromQL 不僅可以在 Graph 頁面查詢數據，而且還可以通過 Prometheus 提供的 HTTP API 來查詢。

按類型來分，可以把 Prometheus 的數據分成四大類：

* Counter
    * 用於計數，代表一種樣本數據單調遞增的指標，值會一直增加，不會減少
    * 通常用來統計請求次數、任務完成數、錯誤發生次數等。
* Gauge
    * Gauge 就是一般的數值，代表一種樣本數據可以任意變化的指標，可增可減
    * 通常用來統計如服務的 CPU 使用值，溫度變化、內存使用變化等
* Histogram
    * Histogram 是直方圖，或稱為柱狀圖，用於表示一段時間內的數據采樣和點分位圖統計結果
    * 常用於跟蹤事件發生的規模，例如請求耗時或響應大小等
    * 它特別之處是可以對記錄的內容進行分組，提供 count 和 sum 的功能。
* Summary
    * Summary 和 Histogram 十分相似，也用於跟蹤事件發生的規模，不同之處是，它提供了一個 quantiles 的功能，可以按百分比劃分跟蹤的結果。
    * 例如：quantile 取值 0.95，表示取采樣值裡面的 95% 數據。更多信息可以參考官網文檔 Metric types，Summary 和 Histogram 的概念比較容易混淆，屬於比較高階的指標類型，可以參考 Histograms and summaries 這裡的說明。

直接輸入指標名稱

```promql
# 表示 Prometheus 能否抓取 target 的指標，用於 target 的健康檢查  
up
```

指定某個 label 來查詢 (Instant vector selectors)，還可以使用 !=、=~、!~。

```promql
up{job="prometheus"} 
```

和 Instant vector selectors 相應的，還有一種選擇器，叫做 Range vector selectors，它可以查出一段時間內的所有數據

```promql
http_requests_total[5m]
```

注意它返回的數據類型是 Range vector，沒辦法在 Graph 上顯示成曲線圖，一般情況下，會用在 Counter 類型的指標上，並和 rate() 或 irate() 函數一起使用（注意 rate 和 irate 的區別）。

```promql
# 計算的是每秒的平均值，適用於變化很慢的 counter  
# per-second average rate of increase, for slow-moving counters  
rate(http_requests_total[5m])  
   
# 計算的是每秒瞬時增加速率，適用於變化很快的 counter  
# per-second instant rate of increase, for volatile and fast-moving counters  
irate(http_requests_total[5m])  
```

## HTTP API

我們不僅僅可以在 Prometheus 的 Graph 頁面查詢 PromQL，Prometheus 還提供了一種 HTTP API 的方式，可以更靈活的將 PromQL 整合到其他系統中使用。

* GET /api/v1/query
* GET /api/v1/query_range
* GET /api/v1/series
* GET /api/v1/label/<label_name>/values
* GET /api/v1/targets
* GET /api/v1/rules
* GET /api/v1/alerts
* GET /api/v1/targets/metadata
* GET /api/v1/alertmanagers
* GET /api/v1/status/config
* GET /api/v1/status/flags

## 告警和通知

Prometheus 的告警功能被分成兩部分：一個是告警規則的配置和檢測，並將告警發送給 Alertmanager，另一個是 Alertmanager，它負責管理這些告警，去除重復數據，分組，並路由到對應的接收方式，發出報警。常見的接收方式有：Email、PagerDuty、HipChat、Slack、OpsGenie、WebHook 等。

我們在上面介紹 Prometheus 的配置文件時瞭解到，它的默認配置文件 prometheus.yml 有四大塊：global、alerting、rule_files、scrape_config，其中 rule_files 塊就是告警規則的配置項，alerting 塊用於配置 Alertmanager

```yaml
rule_files:  
  - "alert.rules"  
```

alert.rules

```yaml
groups:  
- name: example  
  rules:  
   
  # Alert for any instance that is unreachable for >5 minutes.  
  - alert: InstanceDown  
    expr: up == 0  
    for: 5m  
    labels:  
      severity: page  
    annotations:  
      summary: "Instance {{ $labels.instance }} down"  
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."  
   
  # Alert for any instance that has a median request latency >1s.  
  - alert: APIHighRequestLatency  
    expr: api_http_request_latencies_second{quantile="0.5"} > 1  
    for: 10m  
    annotations:  
      summary: "High request latency on {{ $labels.instance }}"  
      description: "{{ $labels.instance }} has a median request latency above 1s (current value: {{ $value }}s)"
```

配置好後，需要重啟下 Prometheus server，然後訪問 http://localhost:9090/rules 可以看到剛剛配置的規則：

使用 Alertmanager 發送告警通知

雖然 Prometheus 的 /alerts 頁面可以看到所有的告警，但是還差最後一步：觸發告警時自動發送通知。這是由 Alertmanager 來完成的

## 實際應用

在開發環境，往往只需要部署一個 Prometheus 實例便可以滿足數十萬指標的收集。但在生產環境中，應用和服務實例數量眾多，只部署一個 Prometheus 實例通常是不夠的，比較好的做法是部署多個Prometheus實例，每個實例通過分區只拉取一部分指標。然後再使用聯邦集群（federation），即把 Prometheuse Server 按照樹狀結構進行分層，根節點方向的 Prometheus 將查詢葉子節點的 Prometheus 實例，再將指標聚合返回。

![prometheus-2](./images/prometheus-2.webp)

不過顯然易見的是，使用聯邦集群依然不能解決問題，首先單點問題依然存在，根節點掛了的話查詢將會變得不可用，如果配置多個父節點的話又會造成數據冗餘和抓取時機導致數據不一致等問題，而且葉子節點目標數量太多時，更加會容易使父節點壓力增大以至打滿宕機，除此之外規則配置管理也是個大麻煩。

還好社區出現了一個 Prometheus 的集群解決方案：Thanos，它提供了全局查詢視圖，可以從多台Prometheus查詢和聚合數據，因為所有這些數據均可以從單個端點獲取。

* Querier 收到一個請求時，它會向相關的 Sidecar 發送請求，並從他們的 Prometheus 服務器獲取時間序列數據。
* 它將這些響應的數據聚合在一起，並對它們執行 PromQL 查詢。它可以聚合不相交的數據也可以針對 Prometheus 的高可用組進行數據去

再來說到存儲，Prometheus 查詢的高可用可以通過水平擴展+統一查詢視圖的方式解決，那麼存儲的高可用要怎麼解決呢？在 Prometheus 的設計中，數據是以本地存儲的方式進行持久化的，雖然本地持久化方便，但也會帶來一些麻煩，比如節點掛了或者 Prometheus 被調度到其他節點上，就會意味著原節點上的監控數據在查詢接口中丟失，本地存儲導致了 Prometheus 無法彈性擴展，為此 Prometheus 提供了 Remote Read 和 Remote Write 功能，支持把 Prometheus 的時間序列遠程寫入到遠端存儲中，查詢時可以從遠端存儲中讀取數據。重。

再來說到存儲，Prometheus 查詢的高可用可以通過水平擴展+統一查詢視圖的方式解決，那麼存儲的高可用要怎麼解決呢？在 Prometheus 的設計中，數據是以本地存儲的方式進行持久化的，雖然本地持久化方便，但也會帶來一些麻煩，比如節點掛了或者 Prometheus 被調度到其他節點上，就會意味著原節點上的監控數據在查詢接口中丟失，本地存儲導致了 Prometheus 無法彈性擴展，為此 Prometheus 提供了 Remote Read 和 Remote Write 功能，支持把 Prometheus 的時間序列遠程寫入到遠端存儲中，查詢時可以從遠端存儲中讀取數據。

其中一個例子中就是M3DB，M3DB是一個分佈式的時間序列數據庫，它提供了Prometheus的遠程讀寫接口，當一個時間序列寫入到M3DB集群後會按照分片（Shard）和復制（Replication Factor）參數把數據復制到集群的其他節點上，實現存儲高可用。除了M3DB外，Prometheus目前還支持InfluxDB、OpenTSDB等作為遠程寫的端點。

## Pushgateway

假如有一種情況是一些任務節點還沒來得及被拉取就運行完退出了，這時候監控數據就會丟失，為了應對這種情況，Prometheus 提供了一個工具：Pushgateway，用來接收來自服務的主動上報。

它適用於那些短暫存活的批量任務來將指標推送並暫存到自身上，借著再由Prometheus 來拉取自身，以防止指標還沒來得及被 Prometheus 拉取便退出。

除此以外 Pushgateway 也適用於在 Prometheus 與應用節點運行在異構網絡或被防火牆隔絕時，無法主動拉取節點的問題，在這種情況下應用節點可以通過使用Pushgateway的域名將指標推送到Pushgateway實例上，Prometheus就可以拉取同網絡下的 Pushgateway 節點了。

Pushgateway可以替代拉模型來作為指標的收集方案，但在這種模式下會帶來許多負面影響：

Pushgateway 被設計為一個監控指標的緩存，這意味著它不會主動過期服務上報的指標，這種情況在服務一直運行的時候不會有問題，但當服務被重新調度或銷毀時，Pushgateway 依然會保留著之前節點上報的指標。而且，假如多個 Pushgateway 運行在 LB 下，會造成一個監控指標有可能出現在多個 Pushgateway 的實例上，造成數據重復多份，需要在代理層加入一致性哈希路由來解決。

在拉模式下，Prometheus可以更容易的查看監控目標實例的健康狀態，並且可以快速定位故障，但在推模式下，由於不會對客戶端進行主動探測，因此對目標實例的健康狀態也變得一無所知。

## 參考資料

* [號稱下一代監控系統，來看看它有多強！](https://mp.weixin.qq.com/s/hrZfFmbyn_4ZzJOpK_-0ZQ)
