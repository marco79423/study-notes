# Elasticsearch 學習筆記

* 是一個基於 Apache Lucene(TM) 的開源搜索引擎，目的是通過簡單的 RESTful API 來隱藏 Lucene 的複雜性，從而讓全文搜索變得簡單。
* 是面向文檔(document oriented)的，這意味著它可以存儲整個對象或文檔(document)。然而它不僅僅是存儲，還會索引(index)每個文檔的內容使之可以被搜索。
* 使用 json 作為文檔序列化格式

## 基本概念

### 索引(indexing)

在 Elasticsearch 中存儲數據的行為就叫做索引(indexing)

Elasticsearch 集群可以包含多個索引(indices)（數據庫），每一個索引可以包含多個類型(types)（表），每一個類型包含多個文檔(documents)（行），然後每個文檔包含多個字段(Fields)（列）。

    # 與 Relational DB 對比圖
    Relational DB -> Databases -> Tables -> Rows -> Columns
    Elasticsearch -> Indices   -> Types  -> Documents -> Fields

* 索引（名詞）就像是傳統關係數據庫中的數據庫，它是相關文檔存儲的地方
* 索引（動詞） 「索引一個文檔」表示把一個文檔存儲到索引（名詞）裡，以便它可以被檢索或者查詢。這很像SQL中的INSERT關鍵字，差別是，如果文檔已經存在，新的文檔將覆蓋舊的文檔。

### 倒排索引

傳統數據庫為特定列增加一個索引，例如 B-Tree 索引來加速檢索。Elasticsearch 使用一種叫做倒排索引(inverted index)的數據結構來達到相同目的。

### 集群 Cluster

* 節點 (Node)
    * 一個 node 將是一個 ES 實例 ( 一個 Java 進程)
    * 一台機器上可以運行多個 ES 進程
    * 每個節點都有名字，通過配置文件配置，或者啟動 -E node.name=lsk 指定
    * 每個節點啟動之後，會分配一個 UID，保存在 data 目錄下
    * 不同節點承擔不同角色。每個節點啟動之後，默認就是 Master eligible 節點。Mater-eligible 節點可參加選主流程，成為 Master 節點。當第一個節點啟動時候，它會將自己選舉城 Mater 節點。
        * 每個節點都保存了集群的狀態，只有 Master 節點才能修改集群的狀態信息
            * 集群狀態 (Cluster State) ，維護了一個集群中必要的信息
                * 所有節點信息
                * 所有的索引和其相關的 Mapping 與 Setting 信息
                * 分片的路由信息
                * 如果任意節點都能修改信息導致數據不一致
* Cluster
    * 一個 Cluster 由多個 node 組成。它們具有相同的 [cluster.name](http://cluster.name/)，當加入新的節點或者刪除一個節點時，集群就會感知到並平衡數據。
    * 集群中一個節點會被選舉為主節點(master),它將臨時管理集群級別的一些變更，例如新建或刪除索引、增加或移除節點等。主節點不參與文檔級別的變更或搜索，這意味著在流量增長的時候，該主節點不會成為集群的瓶頸。任何節點都可以成為主節點。
    * 我們能夠與集群中的任何節點通信，包括主節點。每一個節點都知道文檔存在於哪個節點上，它們可以轉發請求到相應的節點上。我們訪問的節點負責收集各節點返回的數據，最後一起返回給客戶端。這一切都由 Elasticsearch 處理。
    * 集群健康(cluster health)
        * 集群健康有三種狀態：green、yellow 或 red。green 代表所有主要分片和複製分片都可用；yellow 代表所有主要分片可用，但不是所有複製分片都可用；red 不是所有的主要分片都可用

            ```json
            // GET /_cluster/health
            {
                "cluster_name":          "elasticsearch",
                "status":                "green",   // 集群健康(cluster health)
                "timed_out":             false,
                "number_of_nodes":       1,         // 節點總數
                "number_of_data_nodes":  1,
                "active_primary_shards": 3,         // 主分片數量
                "active_shards":         3,
                "relocating_shards":     0,
                "initializing_shards":   0,
                "unassigned_shards":     3          // 有三個複製分片還沒分配 (如果只有一個節點，就沒必要分配複製節點)
            }
            ```

* 分片
    * 我們的文檔存儲在分片中，並且在分片中被索引，但是我們的應用程序不會直接與它們通信，而是直接與索引通信。索引只是一個用來指向一個或多個分片(shards)的“邏輯命名空間(logical namespace)”
    * 分片可以是主分片(primary shard)或者是複製分片(replica shard)。你索引中的每個文檔都會屬於一個單獨的主分片，所以主分片的數量決定了索引最多能存儲多少數據。
        * 主分片
            * 用來解決數據水平擴展問題。可以將數據分佈到集群內的所有節點之上
            * 一個分片是一個運行的 Lucene 的實例 (所以本身就是一個完整的搜索引擎)
            * 主分片數在索引創建時指定，後期不允許修改，除非 Reindex
            * 默認情況下，一個索引被分配 1 個主分片 (7.0 之前是 5)
        * 副本
            * 解決數據高可用問題，是主分片的拷貝
                * 它可以防止硬件故障導致的數據丟失，同時可以提供讀請求，比如搜索或者從別的 shard 取回文檔。
            * 副本分片數，可以動態的調整
            * 增加副本數，可以在一個程度上提高服務的可用性（讀取的吞吐）
                * 在同樣數量的節點上增加更多的複製分片並不能提高性能，因為這樣做的話平均每個分片的所佔有的硬件資源就減少了
    * 分片的設定
        * 分片數設置過小
            * 導致後續無效增加節點實現水平擴展
            * 單個分片的數據量太大，導致數據重新分配耗時
        * 分片數設置過大
            * 影響搜素結果的相關性打分，影響統計結果的準確性
            * 單個節點上過多的分片，會導致資源的浪費，同時也會影響性能
        * 本身有一些指標限制：
            * Elastic索引數據量有大小限制；
            * 單個分片數據容量官方建議不超過50GB，合理範圍是20GB～40GB之間；
            * 單個分片數據條數不超過約21億條（2的32次方），此值一般很難達到，基本可以忽略，背後原理可以參考源碼或者其它；
            * 索引分片過多，分佈式資源消耗越大，查詢響應越慢。
* Index
    * 名稱必須全部小寫，不能以 `_` 開頭，也不能包含 `,`
* Document
    * 通常可以把 Document 直接類比為 object，或是 root object，以唯一 ID 存在 ES 中
    * 每個文檔都有一個版本號，對文檔修改時(包含刪除)， `_version` 值會遞增
    * 文檔是不可改變的，不能修改它們。相反，如果想要更新現有的文檔，需要重建索引或者進行替換
        * 刪除文檔不會立即將文檔從磁盤中刪除，只是將文檔標記為已刪除狀態。儘管你不能再對舊版本的文檔進行訪問，但它並不會立即消失。隨著你不斷的索引更多的數據，Elasticsearch 將會在後台清理標記為已刪除的文檔。
        * 即使文檔不存在（ Found 是 false ）， _version 值仍然會增加。這是 Elasticsearch 內部記錄本的一部分，用來確保這些改變在跨多節點時以正確的順序執行。
    * Document 除了資料外，還會包含 metadata (關於文檔的訊息)
        * _index 文檔儲存的地方
        * _type 文檔代表的類別，同一個類別代表同一種事物，他們的資料結構也是相同的
        * _id 文檔唯一的標識，和_index、_type 組合時，就可以在 ES 唯一標識一個 Document

### Analysis 和 Analyzer

術語

* Analysis
    * 文本分析是吧全文本轉換成一系列的單詞（term /token）的過程，也叫分詞
* Analyzer
    * Analysis 是通過 Analyzer 來實現的
    * 除了在數據寫入時轉換詞條，匹配 Query 語句時候也需要用相同的分析器會查詢語句進行分析
    * Analyzer 由三部分組成
        * Character Filters （針對原始文本處理，例如去除 html）
        * Tokenizer（按照規則切分為單詞）
        * Token Filter （將切分的單詞進行加工，小寫，刪除 stopwords，增加同義語）

內建的分詞器

* Standard Analyzer
    * 默認分詞器
    * 按詞切分
    * 小寫處理
* Simple Analyzer
    * 按照非字母切分（符號被過濾）
    * 小寫處理
* Stop Analyzer
    * 小寫處理
    * 停用詞過濾（the ，a，is）
* Whitespace Analyzer
    * 按照空格切分
    * 不轉小寫
* Keyword Analyzer
    * 不分詞
    * 直接將輸入當做輸出
* Pattern Analyzer
    * 正則表達式，默認 \W+
* Language
    * 提供了 30 多種常見語言的分詞器
* Customer Analyzer
    * 自定義分詞器

## 操作

### CRUD 操作

* Index
    * PUT my_index/_doc/1

        ```json
        // PUT /paragraphs/_doc/1
        {
            "article_title": "文章標題",
            "content": "這是文章內容"
        }
        ```

        * ID 不存在會創建新的，否則會替換現有文檔，版本增加
* Create
    * PUT my_index/_create/1

        ```json
        // POST /paragraphs/_create/1
        {
            "article_title": "文章標題",
            "content": "這是文章內容"
        }
        ```

        * 如果 ID 已存在會失敗
            * 成功會回傳 201 Created，失敗會回傳 409 Conflict
    * POST my_index/_doc (不指定 ID，自動生成)

        ```json
        // POST /paragraphs/_doc/
        {
            "article_title": "文章標題",
            "content": "這是文章內容"
        }
        ```

* Read
    * GET my_index/_doc/1
* Update
    * POST my_index/_update/1

        ```json
        // PUT /paragraphs/_doc/1 
        {
          "doc": {
            "article_title": "文章標題",
                "content": "這是文章內容"  
          }
        }
        ```

        * 文檔必須存在，更新只會對相應字段做增量修改
            * 文檔是不可變的，只能被替換不能被更改。update API 也遵循相同的規則
            * 舊版本不會立即消失，ES 會自動在索引更新數據時自動清理
        * 局部更新
            * 使用 Groovy 局部更新  (舊版，現在不確定可不可以用)

                ```json
                // POST /website/blog/1/_update
                {
                    "script" : "ctx._source.views+=1"
                }
                ```

                * 更新可能不存在的文檔

                    ```json
                    // POST /website/pageviews/1/_update
                    {
                        "script" : "ctx._source.views+=1",  // 第二次後會以 script 代替，改為增加 views 數量
                        "upsert": {   // 第一次會初始化為 1
                            "views": 1
                        }
                    }
                    ```

            * 當用戶不關心順序(比如說是增加頁面訪客數)，可以使用 retry_on_conflict 參數設置重試次數來自動完成，這樣 update 操作將會在發生錯誤前重試，適用於像增加計數這種順序無關的操作。

                ```json
                // POST /website/pageviews/1/_update?retry_on_conflict=5 // 這個值默認為0
                {
                    "script" : "ctx._source.views+=1",
                    "upsert": {
                        "views": 0
                    }
                }
                ```

* Delete
    * DELETE my_index/_doc/1
    * 刪除版號依然會增加

### 衝突處理

* 兩種通用的方法確保在並發更新時修改不丟失
    * 悲觀並發控制（Pessimistic concurrency control）
        * 這在關係型數據庫中被廣泛的使用，假設衝突的更改經常發生，為瞭解決衝突我們把訪問區塊化。典型的例子是在讀一行數據前鎖定這行，然後確保只有加鎖的那個線程可以修改這行數據。
    * 樂觀並發控制（Optimistic concurrency control）
        * 被 ES 使用，假設衝突不經常發生，也不區塊化訪問，然而，如果在讀寫過程中數據發生了變化，更新操作將失敗。這時候由程序決定在失敗後如何解決衝突。實際情況中，可以重新嘗試更新，刷新數據（重新讀取）或者直接反饋給用戶。
* 樂觀並發控制
    * 當文檔被修改時，新版本會覆制到集群的其它節點。這些請求都是平行發送的，無序(out of sequence)的到達目的地。
    * ES 使用這個`_version`保證所有修改都被正確排序。當一個舊版本出現在新版本之後，它會被簡單的忽略。
    * 我們可以指定文檔的`version`來做想要的更改。如果那個版本號不是現在的，我們的請求就失敗了。所有更新和刪除文檔的請求都接受`version`參數，它可以允許在你的代碼中增加樂觀鎖控制。

        ```json
        // PUT /website/blog/1?version=1  // 代表我們只希望文檔為 1 才能更新，如果成功就會變為 2
        {
            "title": "My first blog entry",
            "text":  "Starting to get the hang of this..."
        }

        // 失敗時
        409 Conflict
        {
            "error" : "VersionConflictEngineException[[website][2] [blog][1]: version conflict, current [2], provided [1]]",
            "status" : 409
        }
        ```

* 使用外部版本控制系統
    * 一種常見的結構是使用一些其他的數據庫做為主數據庫，然後使用Elasticsearch搜索數據，這意味著所有主數據庫發生變化，就要將其拷貝到Elasticsearch中。如果有多個進程負責這些數據的同步，就會遇到上面提到的並發問題。
    * 如果主數據庫有版本字段——或一些類似於timestamp等可以用於版本控制的字段——是你就可以在Elasticsearch的查詢字符串後面添加version_type=external來使用這些版本號。版本號必須是整數，大於零小於9.2e+18——Java中的正的long。
    * 外部版本號與之前說的內部版本號在處理的時候有些不同。它不再檢查_version是否與請求中指定的一致，而是檢查是否小於指定的版本。如果請求成功，外部版本號就會被存儲到_version中。

        ```json
        // PUT /website/blog/2?version=5&version_type=external
        {
            "title": "My first external blog entry",
            "text":  "Starting to get the hang of this..."
        }
        
        // 回傳
        {
            "_index":   "website",
            "_type":    "blog",
            "_id":      "2",
            "_version": 5,     // 一樣是 5
            "created":  true
        }
        ```

### 批次處理

* 批量操作，可以減少網絡連接所產生的開銷，提高性能
* mget 批量讀取

    ```json
    // GET /_mget
    {
      "docs": [
        {
          "_index": "paragraphs",
          "_id": "ITc1CHIB93t89nKaNzYA"
        },
        {
          "_index": "paragraphs",
          "_id": "Ijc1CHIB93t89nKaPDZT"
        }
      ]
    }
    ```

### 查詢

lasticsearch不只會存儲(store)文檔，也會索引(indexes)文檔內容來使之可以被搜索。每個文檔裡的字段都會被索引並被查詢。而且不僅如此。在簡單查詢時，Elasticsearch可以使用所有的索引，以非常快的速度返回結果。

ES 的資料分為兩種類型：

* Exact Values (確切值)
    * 確切值是確定的，如 date、ID，2014 和 2014-09-15 就不相同
    * 確切值是很容易查詢的，要麼匹配，要麼不匹配
* Full Text (全文文本)
    * 如推文和郵件正文，常被稱為非結構化數據
    * 查的是匹配程度如何
    * ES 用「倒排索引(inverted index) 的結構來做快速全文搜尋

#### 用 id 搜尋

```json
// GET /megacorp/employee/1
{
    "_index" :   "megacorp",
    "_type" :    "employee",
    "_id" :      "1",
    "_version" : 1,
    "found" :    true,
    "_source" :  {
        "first_name" :  "John",
        "last_name" :   "Smith",
        "age" :         25,
        "about" :       "I love to go rock climbing",
        "interests":  [ "sports", "music" ]
    }
}
```

* 如果沒找到會回傳 404，內容可能為：

```json
{
    "_index" :   "megacorp",
    "_type" :    "employee",
    "_id" :      "1",
    "found" :  false
}
```

* 如果只想拿資料

```json
// GET /megacorp/employee/1/_source  // 可以用 _source
{
    "first_name" :  "John",
    "last_name" :   "Smith",
    "age" :         25,
    "about" :       "I love to go rock climbing",
    "interests":  [ "sports", "music" ]
}
```

* 如果只想確認檔案是否存在

    HEAD /megacorp/employee/1

    * 成功回傳 200 OK，失敗回傳 404 Not Found

#### _search

可以使用 `_search` 搜尋，，默認會回傳前十個結果

```json
// GET /megacorp/employee/_search
{
    "took":      6,
    "timed_out": false,
    "_shards": { /*...*/ },
    "hits": {
        "total":      3,
        "max_score":  1,
        "hits": [
            { /*...*/ },
            { /*...*/ },
            { /*...*/ }
        ]
    }
}
```

* 可用 query string 加條件

```json
{
    //...
    "hits": {
        "total":      2,
        "max_score":  0.30685282,
        "hits": [
            {
                //...
                "_source": {
                    //...
                    "first_name":  "John",
                    "last_name":   "Smith"
                }
            },
            {
                //...
                "_source": {
                    //...
                    "first_name":  "Jane",
                    "last_name":   "Smith"
                }
            }
        ]
    }
}
```

    * `+` 代表必須被滿足，而 `-` 代表必須不被滿足，如 `+name:john +tweet:mary`
    * ES 會把所有字串連結起來，即為 `_all`，`q=blabla`，其實就是搜尋 `_all` 這個特殊欄位

#### 使用 Query DSL 查詢

透過 GET 的 body 輸入 Query，但因為許多服務不允許在 GET 的 body 放資料，所以也可以使用 POST 代替

```json
// GET /_search
{
    "query": {  // 搜尋

        // QUERY_NAME: {
        //     ARGUMENT: VALUE,
        //     ARGUMENT: VALUE,...
        // }
        "match_all": {}  // 匹配所有的文檔
    }
}
```

```json
// GET /_search
{
    "query": {  // 搜尋
        // {
        //     QUERY_NAME: {
        //         FIELD_NAME: {   <- 指定欄位
        //             ARGUMENT: VALUE,
        //             ARGUMENT: VALUE,...
        //         }
        //     }
        // }
        "match": {
            "tweet": "elasticsearch"  // 找尋在tweet字段中找尋包含elasticsearch的成員
        }
    }
}
```

* 搜尋時會用 `_score` 代表相關性評分，相關性(relevance)的概念在Elasticsearch中非常重要，而這個概念在傳統關係型數據庫中是不可想像的，因為傳統數據庫對記錄的查詢只有匹配或者不匹配。
* 很多應用喜歡從每個搜索結果中高亮(highlight)匹配到的關鍵字，這樣用戶可以知道為什麼這些文檔和查詢相匹配。在Elasticsearch中高亮片段是非常容易的。

    ```json
    // GET /megacorp/employee/_search
    {
        "query" : {
            "match_phrase" : {
                "about" : "rock climbing"
            }
        },
        "highlight": {
            "fields" : {
                "about" : {}
            }
        }
    }
    ```

* 不同的搜尋方式
    * match

        查詢匹配會進行分詞，比如"寶馬多少馬力"會被分詞為"寶馬 多少 馬力", 所有有關"寶馬 多少 馬力", 那麼所有包含這三個詞中的一個或多個的文檔就會被搜索出來。並且根據lucene的評分機制(TF/IDF)來進行評分。

        ```json
        {
        "query": {
            "match": {
                "content" : {
                    "query" : "我的宝马多少马力"
                }
            }
        }
        }
        ```

    * match_phrase

        如果要同時精確匹配「寶馬」、「多少」、「 馬力」時就用 match_phrase

        ```json
        {
        "query": {
            "match_phrase": {
                "content" : {
                    "query" : "我的寶馬多少馬力"
                }
            }
        }
        }
        ```

        * 不過完全匹配可能比較嚴，我們會希望有個可調節因子，少匹配一個也滿足，那就需要使用到slop。

                ```json
                {
                "query": {
                    "match_phrase": {
                        "content" : {
                            "query" : "我的寶馬多少馬力",
                            "slop" : 1
                        }
                    }
                }
                }
                ```

    * multi_match

        如果我們希望兩個字段進行匹配，其中一個字段有這個文檔就滿足的話，使用multi_match

        ```json
        {
        "query": {
            "multi_match": {
                "query" : "我的寶馬多少馬力",
                "fields" : ["title", "content"]
            }
        }
        }
        
        ```

        * 我們希望完全匹配的文檔佔的評分比較高，則需要使用best_fields

            ```json
            {
            "query": {
                "multi_match": {
                "query": "我的寶馬發動機多少",
                "type": "best_fields",
                "fields": [
                    "tag",
                    "content"
                ],
                "tie_breaker": 0.3
                }
            }
            }
            ```

            意思就是完全匹配"寶馬 發動機"的文檔評分會比較靠前，如果只匹配寶馬的文檔評分乘以0.3的係數

        * 我們希望越多字段匹配的文檔評分越高，就要使用most_fields

            ```json
            {
            "query": {
                "multi_match": {
                "query": "我的寶馬發動機多少",
                "type": "most_fields",
                "fields": [
                    "tag",
                    "content"
                ]
                }
            }
            }
            ```

        * 我們會希望這個詞條的分詞詞彙是分配到不同字段中的，那麼就使用cross_fields

            ```json
            {
            "query": {
                "multi_match": {
                "query": "我的寶馬發動機多少",
                "type": "cross_fields",
                "fields": [
                    "tag",
                    "content"
                ]
                }
            }
            }
            ```

    * term

        term是代表完全匹配，即不進行分詞器分析，文檔中必須包含整個搜索的詞彙

        ```json
        {
        "query": {
            "term": {
            "content": "汽車保養"
            }
        }
        }
        ```

* 增加 filter

    ```json
    // GET /megacorp/employee/_search
    {
    "query" : {
            "filtered" : {
                "filter" : {
                    "range" : {
                        "age" : { "gt" : 30 } <1>
                    }
                },
                "query" : {
                    "match" : {
                        "last_name" : "smith" <2>
                    }
                }
            }
        }
    }
    ```

* 同時檢索多個文檔

    ```json
    // POST /_mget
    {
        "docs" : [
            {
                "_index" : "website",
                "_type" :  "blog",
                "_id" :    2
            },
            {
                "_index" : "website",
                "_type" :  "pageviews",
                "_id" :    1,
                "_source": "views"
            }
        ]
    }
    
    // 200 OK
    {
        "docs" : [
            {
                "_index" :   "website",
                "_id" :      "2",
                "_type" :    "blog",
                "found" :    true,
                "_source" : {
                    "text" :  "This is a piece of cake...",
                    "title" : "My first external blog entry"
                },
                "_version" : 10
            },
            {
                "_index" :   "website",
                "_id" :      "1",
                "_type" :    "pageviews",
                "found" :    true,
                "_version" : 2,
                "_source" : {
                    "views" : 2
                }
            }
        ]
    }
    ```

    * 如果是在同一個 index 甚至在同一個 type 中，可以直接在 URL 上定義默認值 (但也還是可以單獨設定)

        ```json
        // POST /website/blog/_mget
        {
            "docs" : [
                { "_id" : 2 },
                { "_type" : "pageviews", "_id" :   1 }
            ]
        }
        ```

        ```json
        // POST /website/blog/_mget
        {
            "ids" : [ "2", "1" ]
        }
        ```

    * 如果有不存在的值會長下面這樣，也就是說每一個文檔的搜尋都是獨立的。

        ```json
        {
            "docs" : [
                {
                    "_index" :   "website",
                    "_type" :    "blog",
                    "_id" :      "2",
                    "_version" : 10,
                    "found" :    true,
                    "_source" : {
                        "title":   "My first external blog entry",
                        "text":    "This is a piece of cake..."
                    }
                },
                {
                    "_index" :   "website",
                    "_type" :    "blog",
                    "_id" :      "1",
                    "found" :    false
                }
            ]
        }
        ```

        * 一樣會回傳 200 OK，因為請求本身是成功了
* 空搜索
    * 沒有指定任何的查詢條件，只返回集群索引中的所有文檔

        ```json
        // GET /_search
        
        // 響應內容（為了編輯簡潔）類似於這樣：
        {
            "hits" : {
                "total" :       14, // 表示匹配到的文檔總數
                "hits" : [  // 包含了匹配到的前10條數據。默認依關聯性排序，最大的排首位
                    {
                        "_index":   "us",
                        "_type":    "tweet",
                        "_id":      "7",
                        "_score":   1,  // 相關性得分，衡量文檔與查詢的匹配程度。
                        "_source": {  // 文檔內容
                            "date":    "2014-09-17",
                            "name":    "John Smith",
                            "tweet":   "The Query DSL is really powerful and flexible",
                            "user_id": 2
                        }
                    },
                    // ... 9 RESULTS REMOVED ...
                ],
                "max_score" :   1  // 指的是所有文檔匹配查詢中_score的最大值
            },
            "took" :           4,  // 查詢所花費的毫秒數
            "_shards" : {  // 參與查詢的分片數
                "failed" :      0,
                "successful" :  10,
                "total" :       10
            },
            "timed_out" :      false  // 超時與否
        }
        ```

        * 一般搜索請求不會超時，但可以自行限制時間，如 GET /_search?timeout=10ms，會回傳超時前收集到的結果，需要注意的是timeout不會停止執行查詢，它僅僅告訴你目前順利返回結果的節點然後關閉連接。在後台，其他分片可能依舊執行查詢，儘管結果已經被發送。
* 多索引、類別搜尋

    // 對所有索引的所有類型搜尋
    /_search

    // 搜尋 gb 索引
    /gb/_search

    // 同時搜尋 gb 和 us 索引
    /gb,us/_search

    // 在 g 或 u 開頭的索引中搜尋
    /g*,u*/_search

    // 搜尋索引 gb 中的 user 類型
    /gb/user/_search

    // 在索引 gb 和 us 中搜尋 user 和 tweet 類型
    /gb,us/user,tweet/_search

    // 在所有索引搜尋 user 和 tweet 類型
    /_all/user,tweet/_search

* from 和 size 參數

    GET /_search?size=5 // size 代表結果數，默認為 10
    GET /_search?size=5&from=5  // from 代表從哪裡開始，默認為 0
    GET /_search?size=5&from=10

### 聚合(aggregations)

聚合 是由桶和指標組成的。 聚合可能只有一個桶，可能只有一個指標，或者可能兩個都有

* 桶（Buckets）- 滿足特定條件的文檔的集合
    * 當聚合開始執行，每個文檔通過計算來決定符合哪個桶的條件。如果匹配到，文檔將放入相應的桶。
    * 桶也可以被嵌套在其他桶裡面，提供層次化的或者有條件的劃分方案。例如，辛辛那提會被放入俄亥俄州這個桶，而整個俄亥俄州桶會被放入美國這個桶。
* 指標（Metrics）- 對桶內的文檔進行統計計算
    * 分桶是一種達到目的的手段，但是最終我們需要的是對這些桶內的文檔進行一些指標的計算。
    * 大多數 *指標* 是簡單的數學運算（例如最小值、平均值、最大值，還有彙總），這些是通過文檔的值來計算。在實踐中，指標能讓你計算像平均薪資、最高出售價格、95%的查詢延遲這樣的數據。

```sql
SELECT COUNT(color) # COUNT(color) 代表 metrics
FROM table
GROUP BY color  # GROUP BY color 代表 Buckets
```

Elasticsearch 有一個功能叫做聚合(aggregations)，它允許你在數據上生成複雜的分析統計。

```json
// GET /car/transactions/_search
{
    "size" : 0,
    "aggs" : { 
        "popular_colors" : { // 為聚合指定一個想要名稱，本例中是 popular_colors
            "terms" : {   // 定義單個桶的類型 terms
            "field" : "color"
            }
        }
    }
}
```

結果

```json
{
    // ...
    "hits": {
        "hits": [] 
    },
    "aggregations": {
        "popular_colors": { 
            "buckets": [
                {
                "key": "red", 
                "doc_count": 4   // 代表該詞項的文檔數量
                },
                {
                "key": "blue",
                "doc_count": 2
                },
                {
                "key": "green",
                "doc_count": 2
                }
            ]
        }
    }
}
```

添加度量指標

```json
// GET /cars/transactions/_search
{
"size" : 0,
"aggs": {
    "colors": {
        "terms": {
            "field": "color"
        },
        "aggs": {  // 為度量新增 aggs 層。
            "avg_price": { // 度量指定名字： avg_price
            "avg": {
                "field": "price" 
            }
            }
        }
    }
}
}
```

回傳

```json
{
// ...
"aggregations": {
    "colors": {
        "buckets": [
            {
            "key": "red",
            "doc_count": 4,
            "avg_price": { 
                "value": 32500
            }
            },
            {
            "key": "blue",
            "doc_count": 2,
            "avg_price": {
                "value": 20000
            }
            },
            {
            "key": "green",
            "doc_count": 2,
            "avg_price": {
                "value": 21000
            }
            }
        ]
    }
}
// ...
}
```

### 別名

* 新增別名

        PUT /my_index_v1                  # 創建一個別名
        PUT /my_index_v1/_alias/my_index  # 設置別名 my_index 指向 my_index_v1

* 查看有些別名指向這個索引

        GET /my_index_v1/_alias/*

### 查看設定

    GET /my_index/_settings

可以加上 `include_defaults` 包含預設的設定
