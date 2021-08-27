# MySQL 學習筆記

## 資料庫基礎

相關概念

* DB：資料庫，保存有組織的資料的容器
* DBMS：資料庫管理系統，用於管理資料庫的資料
* SQL：結構化查詢語言，用於和 DBMS 通訊的語言

資料庫的規範化

* 數據庫正常化是有效地組織數據庫中的數據的過程。歸一化處理的兩個原因：
    * 消除冗餘數據，例如，存儲了一個以上的相同的數據在同一個表。
    * 確保數據的相關性意義。
* 這兩者都是值得追求的目標，因為它們減少的空間的數據庫消耗的量，並確保數據在邏輯上存儲。規範化由一係列指導方針，幫助指導您創建一個良好的數據庫結構。
* 標準化準則分為正常形態;認為形式的格式或數據庫結構的布局方式。 正常形態的目的是組織數據庫結構，使其符合第一範式，然後第二範式，最後第三範式的規則。
* 這是你的選擇，把它進一步去第四範式，第五範式等，但總體來講，滿足第三範式就夠了。
    * 第一範式(1NF)
    * 第二範式(2NF)
    * 第三範式 (3NF)

## MySQL 基礎

### 語法規範

* 不區分大小寫，但建議關鍵字大寫、table 名、column 名小寫。
* 最要用分號結尾，根據需要，可以縮排或換行
* 註解
    * 註解部分文字用 # 內容
    * 單行註解用 -- 內容
    * 多行註解用 `/*` 內容 `*/`

### MySQL 特殊語法

* 查看當前所有資料庫
     ```sql
    SHOW DATABASES;
    ```
* 查看指定資料庫的所有 table
     ```sql
    SHOW TABLES FROM database_name;
    ```
* 查看當前庫的
     ```sql
    SHOW TABLES;
    ```
* 使用指定的資料庫
     ```sql
    USE database_name;
    ```
* 查看 table 結構
     ```sql
    DESC table_name;
    ```
* 查看 MySQL 的版本
     ```sql
    SELECT version();
    ```

### 基本 SQL 語法

#### 數據定義語言 (DDL, Data Define Language）

* 資料庫管理
    * 創建資料庫
         ```sql
        CREATE DATABASE database_name;
        ```
    * 刪除資料庫
         ```sql
        DROP DATABASE database_name;
        ```

* 資料表管理
    * 創建 table
        * 語法
            ```
            CREATE TABLE table_name (
                column_name1 data_type,
                column_name2 data_type,
                column_name3 data_type,
                ···
            );
            ```
        * 例子
             ```sql
            CREATE TABLE IF NOT EXISTS stuinfo(
                stuId INT,
                stuName VARCHAR(20),
                gender CHAR,
                bornDate DATETIME
            );
            DESC studentinfo;
            ```

        * 限制條件
            * NOT NULL 非空值限制
                * 在預設的情況下，一個欄位是允許接受空值的，NOT NULL 用來限制該欄位不能接受空值。
                * 例子
                     ```sql
                    CREATE TABLE customer (
                        C_Id INT NOT NULL,
                        Name VARCHAR(50) NOT NULL,
                        Address VARCHAR(255),
                        Phone VARCHAR(20)
                    );
                    ```
            * UNIQUE 唯一限制
            * PRIMARY KEY 主鍵限制
            * FOREIGN KEY 外鍵限制
            * CHECK 檢查限制
            * DEFAULT 預設值限制
    * 修改 table
        * 增加欄位
            * 語法
                ```
                ALTER TABLE table_name ADD column_name datatype;
                ```
            * 例子
                 ```sql
                ALTER TABLE customers ADD Discount VARCHAR(10);
                ```
        * 修改 table 名
            * 例子
                 ```sql
                ALTER TABLE stuinfo RENAME [TO] studentinfo;
                ```
        * 修改欄位名稱
            * 例子
                 ```sql
                ALTER TABLE customers CHANGE COLUMN sex gender CHAR;
                ```
        * 修改欄位型別
            * 語法
                ```
                ALTER TABLE table_name ALTER COLUMN column_name datatype;
                ```
            * 例子
                ```sql
                ALTER TABLE customers ALTER COLUMN Discount DECIMAL(18, 2);
                ```
        * 刪除欄位
            * 例子
                 ```sql
                ALTER TABLE studentinfo DROP COLUMN email;
                ```
    * 刪除 table
        ```
        DROP TABLE [IF EXISTS] studentinfo;
        ```

#### 數據操作語言 (DML, Data Manipulate Language)

* 插入
    * INSERT INTO 是用來新增資料至某資料表 (table)。
    * 語法
        * 例子
            ```sql
            INSERT INTO table_name (column1, column2, column3...)
            VALUES (value1, value2, value3...);
            ```
        * 簡寫
            ```sql
            INSERT INTO table_name
            VALUES (value1, value2, value3...);
            ```
            * 使用簡寫的語法每個欄位的值都必需要依序輸入。
* 修改
    * 如果我們要修改資料表中的資料我們就會需要用到 UPDATE。
    * 語法
        * 修改單表
            ``````sql
            UPDATE 表名 set 字段=新值,字段=新值
            【WHERE 条件】
            ```
        * 修改多表
            ``````sql
            UPDATE 表1 别名1, 表2 别名2
            SET 字段=新值，字段=新值
            WHERE 连接条件
            AND 筛选条件
            ```

* 刪除
    * DELETE FROM 是用來刪除資料表中的資料。
    * 語法
        * 刪除單表
            ``````sql
            DELETE FROM 表名 【WHERE 筛选条件】
            ```

        * 刪除多表
            ``````sql
            DELETE FROM 表1 别名1，表2 别名2
            WHERE 连接条件
            AND 筛选条件;
            ```

        * 一次刪除所有資料
            * 方法 1
                ``````sql
                DELETE FROM table_name;
                ```
            * 方法 2
                ``````sql
                DELETE * FROM table_name;
                ```

            * 方法 3
                ``````sql
                TRUNCATE TABLE "表格名";
                ```

                1. truncate不能加where条件，而delete可以加where条件
                2. truncate的效率高一丢丢
                3. truncate 删除带自增长的列的表后，如果再插入数据，数据从1开始
                    * delete 删除带自增长列的表后，如果再插入数据，数据从上一次的断点处开始
                4. truncate删除不能回滚，delete删除可以回滚

#### 數據查詢語言 (DQL, Data Query Language)

* SELECT
    * SELECT 很可能是最常用到的 SQL 語句，它是用來從資料庫取得資料，這個動作我們通常稱之為查詢 (query)，資料庫依 SELECT 查詢的要求會返回一個結果資料表 (result table)，我們通常稱之為資料集 (
      result-set)。
    * 用法
        * 基礎查詢
            * 語法
                ``````sql
                SELECT table_column1, table_column2, table_column3...
                FROM table_name;
                ```

            * 注意事項
                * 盡量避免使用 `SELECT *`，因為一次取得整張資料表會比較耗費系統資源，記住一個原則，取得需要的資料就好，不多拿也不少拿
                * 查詢完的結果是一個虛擬的表格，不是真實存在
                * 查詢的內容可以是欄位、表達式、常數、函數等
        * 條件查詢
            * 根據條件過濾結果，取出符合條件的數據
            * 語法
                ```sql
                SELECT table_column1, table_column2...
                FROM table_name
                WHERE column_name operator value;
                ```

        * 排序查詢
            * 將取得的資料集依某欄位排序
            * 語法
                ``````sql
                SELECT table_column1, table_column2...
                FROM table_name
                ORDER BY column_name1 ASC|DESC, column_name2 ASC|DESC..
                ```
            * 排序分別可以由小至大 (ascending; 預設)，或由大至小 (descending)。
        * 分組查詢
            * GROUP BY 敘述句搭配聚合函數 (aggregation function) 使用，是用來將查詢結果中特定欄位值相同的資料分為若干個群組，而每一個群組都會傳回一個資料列。若沒有使用 GROUP
              BY，聚合函數針對一個 SELECT 查詢，只會返回一個彙總值。
                ```sql
                SELECT column_name(s), aggregate_function(column_name)
                FROM table_name
                WHERE column_name operator value
                GROUP BY column_name1, column_name2...;
                ```

            * 範例
                ```sql
                SELECT customer, SUM(price) FROM orders
                GROUP BY customer;
                ```
            * HAVING
                * HAVING 子句是用來取代 WHERE 搭配聚合函數 (aggregate function) 進行條件查詢，因為 WHERE 不能與聚合函數一起使用。
                * 聚合函數指的也就是 AVG()、COUNT()、MAX()、MIN()、SUM() 等這些內建函數。
                * 語法
                    ```sql
                    SELECT column_name(s), aggregate_function(column_name)
                    FROM table_name
                    WHERE column_name operator value
                    GROUP BY column_name1, column_name2...
                    HAVING aggregate_function(column_name) operator value;
                    ```
                * 範例
                    ```sql
                    SELECT customer, SUM(price) FROM orders
                    GROUP BY customer
                    HAVING SUM(price)<1000;
                    ```
                    * 只會留下總 price 小於 1000 的結果
        * 多表連接查詢
            * SQL JOIN (連接) 是利用不同資料表之間欄位的關連性來結合多資料表之檢索。
            * 類型
                * INNER JOIN 內部連接
                    * INNER JOIN (內部連接) 為等值連接，必需指定等值連接的條件，而查詢結果只會返回符合連接條件的資料。
                    * 語法
                        * 寫法 1
                            ```sql
                            SELECT table_column1, table_column2...
                            FROM table_name1
                            INNER JOIN table_name2
                            ON table_name1.column_name=table_name2.column_name;
                            ```

                        * 寫法 2
                            ```sql
                            SELECT table_column1, table_column2...
                            FROM table_name1
                            INNER JOIN table_name2
                            USING (column_name);
                            ```

                * LEFT (OUTER) JOIN 左外部連接
                    * LEFT JOIN 可以用來建立左外部連接，查詢的 SQL 敘述句 LEFT JOIN 左側資料表 (table_name1) 的所有記錄都會加入到查詢結果中，即使右側資料表 (
                      table_name2) 中的連接欄位沒有符合的值也一樣。
                    * 語法
                        ```sql
                        SELECT table_column1, table_column2...
                        FROM table_name1
                        LEFT OUTER JOIN table_name2
                        ON table_name1.column_name=table_name2.column_name;
                        ```

                        * OUTER 可省略，變成 `LEFT JOIN`
                * RIGHT (OUTER) JOIN 左外部連接
                    * 相對於 LEFT JOIN，RIGHT JOIN 可以用來建立右外部連接，查詢的 SQL 敘述句 RIGHT JOIN 右側資料表 (table_name2)
                      的所有記錄都會加入到查詢結果中，即使左側資料表 (table_name2) 中的連接欄位沒有符合的值也一樣。
                    * 語法
                    * 語法
                        ```sql
                        SELECT table_column1, table_column2...
                        FROM table_name1
                        RIGHT OUTER JOIN table_name2
                        ON table_name1.column_name=table_name2.column_name;
                        ```
                        * OUTER 可省略，變成 `RIGHT JOIN`
                        * 看起來 sqlite 不支援 `RIGHT JOIN`

                * FULL (OUTER) JOIN 全部外部連接
                    * `FULL JOIN` 即為 `LEFT JOIN` 與 `RIGHT JOIN` 的聯集，它會返回左右資料表中所有的紀錄，不論是否符合連接條件。
                    * 語法
                        ```sql
                        SELECT table_column1, table_column2...
                        FROM table_name1
                        FULL JOIN table_name2
                        ON table_name1.column_name=table_name2.column_name;
                        ```
                * CROSS JOIN 交叉連接
                    * 交叉連接為兩個資料表間的笛卡兒乘積 (Cartesian product)，兩個資料表在結合時，不指定任何條件，即將兩個資料表中所有的可能排列組合出來，以下例而言 CROSS JOIN
                      出來的結果資料列數為 3×5=15 筆，因此，當有 WHERE、ON、USING 條件時不建議使用。
                    * 語法
                        * 寫法 1
                            ```sql
                            SELECT table_column1, table_column2...
                            FROM table_name1
                            CROSS JOIN table_name2;
                            ```
                        * 寫法 2
                            ```sql
                            SELECT table_column1, table_column2...
                            FROM table_name1, table_name2;
                            ```

                        * 寫法 3
                            ```sql
                            SELECT table_column1, table_column2...
                            FROM table_name1
                            JOIN table_name2;
                            ```

                * NATURAL JOIN 自然連接
                    * 自然連接有 NATURAL JOIN、NATURAL LEFT JOIN、NATURAL RIGHT JOIN，兩個表格在進行 JOIN 時，加上 NATURAL
                      這個關鍵字之後，兩資料表之間同名的欄位會被自動結合在一起。
                    * 語法
                        ```sql
                        SELECT table_column1, table_column2...
                        FROM table_name1
                        NATURAL JOIN table_name2;
                        ```

            * 用法
                * 自連接
                    ```sql
                    SELECT e.id,
                           e.name,
                           f.name AS manager
                    FROM employees e
                             JOIN employees f ON e.manager_id = f.id;
                    ```

        * 子查詢
            * 一條查詢語句中又嵌套了另一條完整的 SELECT 語句，其中被嵌套的 SELECT 語句，称为子查询或内查询；在外面的查询语句，称为主查询或外查询
            * 語法
                ```sql
                SELECT ...
                FROM ...
                WHERE 查詢條件  <- 這兩個地方都可以用子查詢
                HAVING 分組條件 <-
                ```

                * 子查詢根據查詢結果的筆數不同可以分為兩類：
                    * 單行子查詢
                        * 子查詢不可以指定超過一個欄位的回傳值，也不可回傳超過一筆紀錄 (或為空)
                        * 一般搭配单行操作符使用：> < = <> >= <=
                        * 例子：
                            ```sql
                            SELECT Name, GNP
                            FROM country
                            WHERE GNP = (SELECT MAX(GNP) FROM country)
                            ```

                            * 子查詢都放在小括號內
                            * 此例中子查詢不可以指定超過一個欄位的回傳值，也不可回傳超過一筆紀錄
                    * 多行子查詢
                        * 結果有多筆，一般搭配 ANY, ALL, IN, NOT IN使用 (ANY, ALL 往往可以用其他查詢代替)
                        * 例子
                            ```sql
                            SELECT Name
                            FROM country
                            WHERE Code IN (SELECT CountryCode FROM city WHERE Population > 9999)
                            ```
                            * 只用 `IN` 可以回傳多筆資料，用 `NOT IN` 也成
        * 分頁查詢 (使用 LIMIT)
            * TOP (SQL Server), LIMIT (MySQL), ROWNUM (Oracle) 這些語法其實都是同樣的功能，都是用來限制您的 SQL
              查詢語句最多只影響幾筆資料，而不同的語法則只因不同的資料庫實作時採用不同的名稱。
            * 語法
                ```
                SELECT table_column1, table_column2...
                FROM table_name LIMIT 【起始的条目索引，】条目数;
                ```
                * 起始条目索引从0开始
                * limit子句放在查询语句的最后
            * 常用公式
                ```
                SELECT * FROM table LIMIT （要顯示的頁數-1）* 每頁條目數, 每頁條目數
                ```

        * 聯合查詢 UNION
            * UNION 運算子用來將兩個(以上) SQL 查詢的結果合併起來，而由 UNION 查詢中各別 SQL 語句所產生的欄位需要是相同的資料型別及順序。
            * UNION 查詢只會返回不同值的資料列，有如 `SELECT DISTINCT`。
            * UNION 就是像是 OR (聯集)，如果紀錄存在於第一個查詢結果集或第二個查詢結果集中，就會被取出。
            * UNION 與 JOIN 不同的地方在於，JOIN 是作橫向結合 (合併多個資料表的各欄位)；而 UNION 則是作垂直結合 (合併多個資料表中的紀錄)。
            * 要求
                1. 多条查询语句的查询的列数必须是一致的
                2. 多条查询语句的查询的列的类型几乎相同
            * 語法
                * UNION
                    ```sql
                    SELECT column_name(s) FROM table_name1
                    UNION
                    SELECT column_name(s) FROM table_name2;
                    ```

                * UNION ALL
                    ```sql
                    SELECT column_name(s) FROM table_name1
                    UNION ALL
                    SELECT column_name(s) FROM table_name2;
                    ```
                    * UNION 會去掉重覆的，UNION ALL 則不會
        * 分支查詢
            * CASE
                * CASE 類似於程式語言裡的 if/then/else 語句，用來作邏輯判斷。
                * 語法
                    * 類似 switch 的用法
                        ```
                        CASE expression
                            WHEN value THEN result
                            [WHEN···]
                            [ELSE result]
                        END;
                        ```

                        * 如果是放在 begin end 中需要加上 case，如果放在 select 后面不需要
                        * 例子
                            ```sql
                            SELECT Name,
                                CASE Answer
                                    WHEN 1 THEN '喜歡'
                                    WHEN 2 THEN '不喜歡'
                                    WHEN 3 THEN '還OK'
                                END
                            FROM questionnaire;
                            ```

                    * 類似 if/else 的用法
                        ```
                        CASE
                            WHEN condition THEN result
                            [WHEN···]
                            [ELSE result]
                        END;
                        ```

                        * 如果是放在 begin end 中需要加上 case，如果放在 select 后面不需要
                        * 例子
                            ```sql
                            SELECT Name,
                                CASE
                                    WHEN Answer=1 THEN '喜歡'
                                    WHEN Answer=2 THEN '不喜歡'
                                    WHEN Answer=3 THEN '還OK'
                                END
                            FROM questionnaire;
                            ```

* 函式
    * 字串函數 (SQL String Functions)
        * concat 拼接
        * substr 截取子串
        * upper 转换成大写
        * lower 转换成小写
        * trim 去前后指定的空格和字符
        * ltrim 去左边空格
        * rtrim 去右边空格
        * replace 替换
        * lpad 左填充
        * rpad 右填充
        * instr 返回子串第一次出现的索引
        * length 获取字节个数
    * 數值函數 (SQL Mathematical Functions)
        * round 四舍五入
        * rand 随机数
        * floor 向下取整
        * ceil 向上取整
        * mod 取余
        * truncate 截断
    * 聚合函數 (SQL Aggregate Functions) (會合併欄位)
        * sum 求和
        * max 最大值
        * min 最小值
        * avg 平均值
        * count 计数
            * `COUNT(expr)` ，返回 SELECT 語句檢索的行中 expr 的值不為NULL的數量。結果是一個BIGINT值。如果查詢結果沒有命中任何記錄，則返回0
            * 執行效果上：
                * `count(*)`
                    * 包含所有列，相當於行數，會包含值為NULL
                    * `COUNT(*)` 是SQL92定義的標準統計行數的語法，因為他是標準語法，所以MySQL數據庫對他進行過很多優化。
                        * 使用 MyISAM 的狀況
                            * MyISAM 不支持事務，MyISAM中的鎖是表級鎖，同一張表上面的操作需要串行進行，所以 MyISAM
                              做了一個簡單的優化，那就是它可以把表的總行數單獨記錄下來，如果從一張表中使用 `COUNT(*)`
                              進行查詢的時候，可以直接返回這個記錄下來的數值就可以了，當然前提是不能有where條件。
                        * 使用 InnoDB 的狀況
                            * 而InnoDB支持事務，並且支持行級鎖，所以可能表的行數可能會被併發修改，那麼緩存記錄下來的總行數就不準確了。但是 InnoDB 還是針對 `COUNT(*)`
                              語句做了些優化的。從MySQL 8.0.13開始，針對InnoDB的SELECT COUNT(*) FROM
                              tbl_name語句，確實在掃表的過程中做了一些優化。前提是查詢語句中不包含WHERE或GROUP BY等條件。
                    * `COUNT(*)` 的目的只是為了統計總行數，根本不關心自己查到的具體值，所以如果能夠在掃表的過程中，選擇一個成本較低的索引進行的話，那就可以大大節省時間。
                        * 我們知道，InnoDB中索引分為聚簇索引（主鍵索引）和非聚簇索引（非主鍵索引），聚簇索引的葉子節點中保存的是整行記錄，而非聚簇索引的葉子節點中保存的是該行記錄的主鍵的值。
                        * 所以，相比之下，非聚簇索引要比聚簇索引小很多，所以MySQL會優先選擇最小的非聚簇索引來掃表。所以，當我們建表的時候，除了主鍵索引以外，創建一個非主鍵索引還是有必要的。
                * `count(1)`
                    * 包含所有列，相當於行數，會包含值為NULL
                    * 在 InnoDB 中 `COUNT(*)` 和 `COUNT(1)` 實現上沒有區別，而且效率一樣，因為COUNT(*)
                      是SQL92定義的標準統計行數的語法，並且效率高，所以請直接使用COUNT(*)查詢表的行數。
                        * MySQL官方文檔："InnoDB handles SELECT COUNT(*) and SELECT COUNT(1) operations in the same way.
                          There is no performance difference."
                * `count(列名)`
                    * 只包括列名那一列，在統計結果的時候，會忽略列值為 NULL
                    * 他的查詢就比較簡單粗暴了，就是進行全表掃瞄，然後判斷指定字段的值是不是為NULL，不為NULL則累加。
                    * 相比COUNT(*)，COUNT(字段)多了一個步驟就是判斷所查詢的字段是否為NULL，所以他的性能要比COUNT(*)慢。
    * 時間相關
        * now 当前系统日期+时间
        * curdate 当前系统日期
        * curtime 当前系统时间
        * str_to_date 将字符转换成日期
        * date_format 将日期转换成字符
    * 其他
        * version 版本
        * database 当前库
        * user 当前连接用户

#### 資料控制語言 (DCL)

* 新增使用者
    * MySQL
        ```sql
        CREATE USER 'username'@'hostname' IDENTIFIED BY '密碼';
        ```
        * `hostname` 表示允許這個帳號由什麼地方連線登入 (localhost 表示只允許從本地端登入；% 是萬用字元，表示允許從任何地方登入。)
        * 建立新帳號後，這帳號預設沒有權限可以對資料庫做任何事，接著你必須授與資料庫使用權限給這帳號
* 刪除使用者
    * MySQL
        ```sql
        DROP USER 'username'@'hostname';
        ```

* 授與資料庫使用權限
    * 建立一個新帳號後，你要授與資料庫使用權限給這位使用者，這帳號才能開始連線進去資料庫操作。
    * MySQL
        ```sql
        GRANT type_of_permission ON database_name.table_name TO 'username'@'hostname';
        ```

        * 例子：
            * 授與 mike 所有資料庫和所有資料表的所有操作權限：

                ```
                GRANT ALL PRIVILEGES ON *.* TO 'mike'@'%';

                -* 要記得下這個指令讓權限開始生效
                FLUSH PRIVILEGES;
                ```

            * 同時授與多個權限

                ```
                GRANT SELECT,INSERT ON customers.* TO 'mike'@'%';
                ```

        * 常見的權限類型
            * ALL PRIVILEGES - 所有的權限
            * CREATE - 可以建立資料表或資料庫的權限
            * DROP - 可以刪除資料表或資料庫的權限
            * DELETE - 可以在資料表中刪除資料的權限
            * INSERT - 可以新增資料到資料表的權限
            * SELECT - 可以查詢資料表的權限
            * UPDATE - 可以更新資料表中的資料的權限
            * GRANT OPTION - 可以授權使用權限給其他使用者的權限
* 撤銷資料庫使用權限
    * MySQL
        ```sql
        REVOKE type_of_permission ON database_name.table_name FROM 'username'@'hostname';
        ```

        * 例子
            ```sql
            REVOKE ALL PRIVILEGES FROM 'mike'@'%';

            -- 要記得下這個指令讓權限開始生效
            FLUSH PRIVILEGES;
            ```

#### SQL 學習資源

* Select Star SQL
  * https://selectstarsql.com (待看)

#### 事務控制語言 (TCL, Transaction Control Language)

事務控制語言(如：commit、rollback)

* 事務
    * 交易是單一工作單元。如果交易成功，便會確定交易期間所修改的所有資料，且會成為資料庫中永久的內容。如果交易發現錯誤，必須取消或回復，便會清除所有的資料修改。通俗易懂的說就是一組原子性的 SQL 查詢
    * Mysql 中事務的支持在存儲引擎層，MyISAM 存儲引擎不支持事務，而 InnoDB 支持，這是 Mysql 5.5.5 以後默認引擎由 MyISAM 換成 InnoDB 的最根本原因。
* 事務的 ACID 屬性
    * 原子性（Atomicity）
        * 作為邏輯工作單元，一個事務裡的所有操作的執行，要麼全部成功，要麼全部失敗。
    * 一致性（Consistency）
        * 數據庫從一個一致性狀態變換到另外一個一致性狀態，數據庫的完整性不會受到破壞。
    * 隔離性（Isolation）
        * 多个事务同时操作相同数据库的同一个数据时，一个事务的执行不受另外一个事务的干扰
    * 持久性（Durability）
        * 一旦事務提交，則其所做的修改就會永久保存到數據庫中，即使系統故障，修改的數據也不會丟失。
* 事務的隔離級別
    * 高併發可能的問題
        * 髒讀 (Dirty Read)
            * 如果一個 transaction 還沒有 commit，但是你卻讀得到已經更新的結果，這個情形叫做 Dirty Read。 (一個事務讀取到另外一個事務未提交的結果) 。
                * 例子
                    * Transaction A 在交易中連續讀取了兩次 Alice’s balance，但是第一次讀的時候是 1000，但是在交易還沒完成前，另外一個 Transaction B 正好也在執行中，並且更改了
                  Alice’s balance 變成 700，但是這個交易還沒有 commit 時，Transaction A 再次讀取 Alice’s balance，數值卻讀取出尚未 commit 的數據
                  700，這個現象我們就稱為 Dirty Read
                        ![](./images/mysql-1.png)
            * 心得：一個事務讀到別的還沒 commit 的結果
        * 不可重覆讀 (Non-repeatable reads)
            * 如果你在同一個 transaction 裡面連續使用相同的 Query 讀取了多次資料，但是相同的 Query 卻回傳了不同的結果，這個現象稱為 Non-repeatable reads。
            * Dirty Read 也是一種 Non-repeatable reads
            * 例子
                * Transaction A 第一次取得 Alice’s balance 時是 1000，當它還在執行時，Transaction B 修改了 Alice’s balance 成 700 並且 commit
              transaction。此時 Transaction A 再次讀取相同的數值時，卻變成 700，這就是 Non-repeatable reads。
                    ![](./images/mysql-2.png)
            * 心得：一個事務讀到別人已經 commit 的結果
        * 幻讀 (Phantom reads)
            * 當在同一個 transaction 連續兩次讀取時，讀取出來的筆數跟上次不同，這個情況稱為 Phantom reads。
            * 一个事务读取数据时，另外一个事务进行更新，导致第一个事务读取到了没有更新的数据
            * 例子：
                * 第一次讀取了帳戶裡面餘額介於 900–1000 這個範圍的帳戶，結果總共有兩筆：Alice 跟 Bob。在 Transaction A 還沒結束的同時，Transaction B 更新了 Alice’s
                balance 為 700，這時如果 Transaction A 再次查詢相同條件時，筆數從原本的 2 筆變成 1 筆，這個情況就是 Phantom reads。
                    ![](./images/mysql-3.png)
            * 心得：一個事務讀到別人還沒 commit 的結果 (但後來又讀到 commit 的結果，所以 gg)
    * 為了儘可能的高並發，事務的隔離性被分為四個級別：
        * 未提交讀（READ UNCOMMITTED）
            * 一個事務還未提交，它的變更就能被別的事務看到。
            * 例：事務 A 可以讀到事務 B 修改的但還未提交的數據，會導致髒讀（可能事務 B 在提交後失敗了，事務 A 讀到的數據是髒的）。
            * 前面說的三個問題都沒解決
        * 提交讀（READ COMMITTED）
            * 一個事務提交後，它的變更才能被其他事務看到。
            * 可以避免脏读，但後兩者不行
            * 大多數據庫系統的默認級別，但 Mysql 不是。
        * 可重複讀（REPEATABLE READ）
            * 未提交的事務的變更不能被其他事務看到，同時一次事務過程中多次讀取同樣記錄的結果是一致的。
            * 可以避免脏读、不可重复读和一部分幻读
            * Mysql 的默認級別，InnoDB 通過 MVVC 解決了幻讀的問題
        * 可串行化（SERIALIZABLE）
            * 當兩個事務間存在讀寫衝突時，數據庫通過加鎖強制事務串行執行，解決了前面所說的所有問題（髒讀、不可重複讀、幻讀）。是最高隔離的隔離級別。
            * 可以避免脏读、不可重复读和幻读
                ![](./images/mysql-4.png)
    * 查詢 MySQL 當前的隔離級別
        ```sql
        SELECT @@global.tx_isolation,@@tx_isolation;
        ```

    * 設定 MYSQL 的隔離級別
        ```
        set [ global | session ] transaction isolation level [Read uncommitted | Read committed | Repeatable | Serializable];
        ```
        * 例子
            ```sql
            set session transaction isolation level Serializable;
            ```

* 兩種類型的事務
    * 隐式事务
        * 没有明显的开启和结束事务的标志
        * 比如insert、update、delete语句本身就是一个事务
    * 显式事务
        * 具有明显的开启和结束事务的标志 1、开启事务 取消自动提交事务的功能 2、编写事务的一组逻辑操作单元（多条sql语句） insert update delete 3、提交事务或回滚事务
* 事務的自動提交
    * Mysql 默認採用自動提交（AUTOCOMMIT)模式，也就是說，如果不顯示地開始一個事務，則每個查詢都被當做一個事務執行提交操作。
        * 查看 mysql 是否打開自動提交
            ```sql
            show variables like 'AUTOCOMMIT'; -- ON 代表啟用，OFF 代表禁用
            ```
        * 打開或關閉自動提交
              ```sql
              SET AUTOCOMMIT = 0; -- 0 關閉、1 開啟
              ```
              * 關閉後所有 DML 語句都會在同一個事務中，直到 COMMIT 或 ROLLBACK 為止。

    * 可以通過 `START TRANSACTION` 或 `BEGIN` 開啟一個事務，開啟的事務會自動執行 `SET AUTOCOMMIT = 0;`，並在事務後變回 `SET AUTOCOMMIT = 1;`

* 語法
    * START TRANSACTION | BEGIN： 顯式地開啟一個事務；
    * COMMIT：也可以使用 COMMIT WORK，不過二者是等價的。COMMIT 會提交事務，並使已對數據庫進行的所有修改成為永久性的；
    * ROLLBACK：也可以使用 ROLLBACK WORK，不過二者是等價的。回滾會結束用戶的事務，並撤銷正在進行的所有未提交的修改；
    * SAVEPOINT identifier：SAVEPOINT 允許在事務中創建一個保存點，一個事務中可以有多個 SAVEPOINT；
    * RELEASE SAVEPOINT identifier：刪除一個事務的保存點，當沒有指定的保存點時，執行該語句會拋出一個異常；
    * ROLLBACK TO identifier：把事務回滾到標記點；
    * SET TRANSACTION：用來設置事務的隔離級別。
* 事務的 ACID 透過 redo/undo log 實現原子性、持久性和一致性，透過鎖或 MVCC 機制來完成隔離性
    * redo log (重做日誌) / undo log (撤銷日誌)
        * redo log
            * 重做日誌用來實現事務的原子性和持久性，由以下兩部分組成：
                * 重做日誌緩衝區（redo log buffer）
                    * 內存中，易丟失。
                * 重做日誌文件（redo log file）
                    * 磁盤中，持久的。
                    * redo log file 是順序寫入的，在數據庫運行時不需要進行讀取，只會在數據庫啟動的時候讀取來進行數據的恢復工作。
                    * redo log file 是物理日誌，所謂的物理日誌是指日誌中的內容都是直接操作物理頁的命令。重做時是對某個物理頁進行相應的操作。
            * 流程
                * 第一步：先將原始數據從磁盤中讀入內存中來，修改數據的內存拷貝。
                * 第二步：生成一條重做日誌並寫入redo log buffer，記錄的是數據被修改後的值。
                * 第三步：在「必要的時候」，採用追加寫的方式將 redo log buffer 中的內容刷新到 redo log file。
                    * 事務提交時（最常見的情景，在 commit 之前）
                    * 當 log buffer 中有一半的內存空間被使用時
                    * log checkpoint 時
                    * 實例 shutdown 時
                    * binlog切換時
                    * 後台線程
                * 第四步：定期將內存中修改的數據刷新到磁盤中。
            * 事務提交時將 redo log buffer 寫入 redo log file，為了保證數據一定能正確同步到磁盤（不僅僅只寫到文件緩衝區中）文件中，InndoDB 默認情況下調用了 fsync 進行寫操作。
            * InnoDB 提供了參數 innodb_flush_log_at_trx_commit 來配置 redo log 刷新到磁盤的策略，有以下三個值：
                * 0
                    * 事務提交不會觸發 redo 寫操作，而是留給後台線程每秒一次的刷盤操作，因此實例 crash 將最多丟失一秒鐘內的事務。
                    * 性能最好，可靠性最差
                * 1
                    * 每次事務提交都要做一次 fsync，這是最安全的配置，即使宕機也不會丟失事務
                    * 性能最差，可靠性最好
                    * 當 innodb_flush_log_at_trx_commit 設置為 0 或者 2 時喪失了事務的 ACID 特性，通常在日常環境時將其設置為 1，而在系統高峰時將其設置為 2 以應對大負載。
                * 2
                    * 則在事務提交時只做 write 操作，只保證寫到系統的緩衝區，因此實例crash不會丟失事務，但宕機則可能丟失事務
        * undo log (撤銷日誌)
            * 用來保證事務的一致性。
            * undo log 用來實現事務的一致性，InndoDB 可以通過 redo log 對頁進行重做操作。但是有時候事務需要進行回滾，這時就需要 undo log。
            * undo log 還可可以用來協助 InnoDB 引擎實現 MVCC 機制。
            * undo log 是邏輯日誌，恢復時並不是對物理頁直接進行恢復，而是邏輯地將數據庫恢復到原來的樣子。
            * undo log 的產生也會伴隨著 redo log 的產生。
            * 流程
            * 在 InnoDB 中 undo log 分為 insert undo log 和 update undo log
                * insert undo log
                    * insert 操作產生的日誌。根據隔離性，insert 插入的記錄只對本事務可見，所以事務提交後可以刪除因 insert 產生的日誌。
                * update undo log
                    * delete 和 update 操作產生的日誌。根據前面的 MVCC 機制可以知道此部分記錄還有可能要被其他事務所使用，所以即使事務提交也不能刪除相應的日誌。在事務提交時會被保存到 undo
                      log 鏈表，在 purge 線程中做最後的刪除。
        * 例子
            * 假設有A，B兩個數據，原值分別為 1, 2；現將A更新為10，B 更新為 20
                1. 事務開始
                2. 記錄 A = 1 到 undo log
                3. 更新 A = 10
                4. 記錄 A = 10 到 redo log
                5. 記錄 B = 2 到 undo log
                6. 更新 B = 20
                7. 記錄 B = 20 到 redo log
                8. redo log 信息寫入磁盤
                9. 提交事務
    * 事務的 MVCC 機制
        * Mysql 的事務型存儲引擎（InnoDB）使用 MVCC（Multi-Version Concurrency Control，多版本並發控制）代替行級鎖來提高並發讀寫的性能。InnoDB 的 MVCC
          原理比較簡單，它通過在在每行記錄後面保存三個隱藏列（事務 id，行的創建的版本號、行的過期版本號）來實現的，
        * InnoDB 在 REPEATABLE READ 隔離級別下 MVCC 的簡化工作原理：
            * INSERT: InnoDB 為新插入的每一行保存當前系統版本號作為行版本號。
            * UPDATE: InnoDB 為插入一行新記錄，保存當前系統版本號作為行版本號，同時保存當前系統版本號到原來的行作為行刪除標識。
            * DELETE: InnoDB 為刪除的每一行保存當前系統版本號作為行刪除標識。
            * SELECT: InnoDB 會根據以下兩個條件檢查每行記錄：
                * InnoDB只查找版本早於當前事務版本的數據行（也就是，行的系統版本號小於或等於事務的系統版本號），這樣可以確保事務讀取的行，要麼是在事務開始前已經存在的，要麼是事務自身插入或者修改過的。
                * 行的刪除版本要麼未定義，要麼大於當前事務版本號。這可以確保事務讀取到的行，在事務開始之前未被刪除。

## 重要功能

#### 索引 Index

* 概念
    * 索引是數據庫的搜索引擎使用，以加快數據檢索特定的查找表。簡單地說，索引是一個指向表中的數據。數據庫中的索引非常類似於在一本書的索引。
        * 例如，如果你想引用一本書的所有頁麵以討論某個話題，首先參考索引，其中列出了所有的主題字母順序，然後被轉介到一個或多個特定的頁碼。
    * 索引有助於加快 SELECT 和 WHERE 子句查詢，但它會降低數據寫入速度，使用 UPDATE 和 INSERT 語句。索引可創建或刪除，但對數據不會有影響。
    * 索引是唯一的，類似於 UNIQUE 約束，索引防止在列的列或組合在其上有一個索引重複條目。
    * 什麼時候避免使用索引？
        * 索引不應該用在小型表上。
        * 有頻繁的，大批量更新或插入操作的表。
        * 索引不應該用於對包含大量NULL值的列。
        * 列經常操縱不應該被索引。
    * 建議
        * 主鍵索引欄位最好是數字型態，千萬不要用其他的型態，以免傷了效能。
        * 經常與其他表進行連線的表，在連線欄位上應該建立索引
        * 經常出現在 Where子句中的欄位，特別是大表的欄位，應該建立索引；
        * 索引的欄位必須是經常作為查詢條件的欄位;
        * 索引應該建在小欄位上，對於大的文字欄位甚至超長欄位，不要建索引；
        * 頻繁進行資料操作的表，不要建立太多的索引；
        * 刪除無用的索引，避免對執行計劃造成負面影響；
        * 不要過度索引。不要以為 索引 “ 越多越好 ” ，什麼東西都用索引是錯的。每個額外的
          索引都要佔用額外的磁碟空間，並降低寫操作的效能。如果想給已索引的表增加索引，應該考慮所要增加的索引是否是現有多列索引的最左索引。如果是，則就不要費力去增加這個索引了，因為已經有了。
        * 考慮在列上進行的比較型別。索引可用於 “ < ” 、 “ < = ” 、 “ = ” 、 “ > = ” 、 “ >” 和 BETWEEN 運算。在模式具有一個直接量字首時，索引也用於 LIKE 運算。
        * 於值唯一不重複的列要新增唯一索引，可以更快速的通過該索引來確定某條記錄。唯一索引是最有效的。
        * 複合索引的建立需要進行仔細分析；儘量考慮用 單欄位索引代替：過多的複合索引，在有單欄位索引的情況下，一般都是沒有存在價值的；相反，還會降低資料增加刪除時的效能，特別是對頻繁更新的表來說，負面影響更大。
            * 正確選擇複合索引中的主列欄位，一般是選擇性較好的欄位；
            * 複合索引的幾個欄位是否經常同時以AND方式出現在Where子句中？單欄位查詢是否極少甚至沒有？如果是，則可以建立複合索引；否則考慮單欄位索引；
            * 如果複合索引中包含的欄位經常單獨出現在Where子句中，則分解為多個單欄位索引；
            * 如果複合索引所包含的欄位超過3個，那麼仔細考慮其必要性，考慮減少複合的欄位；
            * 如果既有單欄位索引，又有這幾個欄位上的複合索引，一般可以刪除複合索引；
            * 如果索引多個欄位，第一個欄位要是經常作為查詢條件的。如果只有第二個欄位作為查詢條件，這個索引不會起到作用;
    * 注意事項
        * 索引對於插入、刪除、更新操作也會增加處理上的開銷。
        * 不要對索引欄位進行運算，要想法辦做變換
            ```sql
            SELECT ID FROM T WHERE NUM/2=100  -- bad
            SELECT ID FROM T WHERE NUM = 100*2  -- good
            ```

* 類型
    * INDEX普通索引
        * 允許出現相同的索引內容
    * UNIQUE唯一索引
        * 不可以出現相同的值,可以有NULL值
    * PRIMARY KEY主鍵索引
        * 不允許出現相同的值,且不能為NULL值,一個表只能有一個primary_key索引
    * fulltext index 全文索引
        * 上述三種索引都是針對列的值發揮作用,但全文索引,可以針對值中的某個單詞,比如一篇文章中的某個詞,
          然而並沒有什麼卵用,因為只有myisam以及英文支援,並且效率讓人不敢恭維,但是可以用coreseek和xunsearch等第三方應用來完成這個需求
* 語法
    * 建立
        * 單列索引
            * 語法
                 ```sql
                CREATE INDEX index_name
                ON table_name (column_name);
                ```

        * 唯一索引
            * 唯一索引不僅用於性能，而且要求數據的完整性。唯一索引不允許有任何重複值插入到表中
            * 語法
                 ```sql
                CREATE UNIQUE INDEX index_name
                ON table_name (column_name);
                ```

        * 組合索引
            * 組合索引在表上的兩個或多個列的索引。
            * 是否要創建一個單列索引或複合索引，考慮到列，您可以使用非常頻繁的查詢的WHERE子句作為過濾條件。
            * 應該有隻有一個使用列，單列指數應的選擇。如果有頻繁使用WHERE子句作為過濾器中的兩個或多個列，組合索引將是最好的選擇。
            * 語法
                 ```sql
                CREATE INDEX index_name
                ON table_name (column1, column2);
                ```

        * 隱式索引
            * 隱式索引是自動由數據庫服務器創建對象時創建的索引。索引是主鍵約束和唯一性約束自動創建。
    * 刪除
        * 索引可以使用SQL DROP命令刪除。 應當謹慎刪除索引時導致的性能可能會減慢或改善。
        * 語法
             ```sql
            DROP INDEX index_name ON table_name;
            ```

### 視圖 View

* 簡介
    * 是一種處擬存在的 Table，本身不包含數據，數據來自定義 View 時所使用的 Table (base table)。
    * 使用方式和 table 幾乎完全相同，而且不占用物理空間 (僅保持使用的 sql 邏輯)
* 好處
    * 簡單：使用視圖的用戶完全不需要關心後面對應的表的結構、關聯條件和篩選條件，對用戶來說已經是過濾好的復合條件的結果集。
    * 安全：使用視圖的用戶只能訪問他們被允許查詢的結果集，對表的權限管理並不能限制到某個行某個列，但是通過視圖就可以簡單的實現。
    * 數據獨立： 一旦視圖的結構確定了，可以屏蔽表結構變化對用戶的影響，源表增加列對視圖沒有影響；源表修改列名，則可以通過修改視圖來解決，不會造成對訪問者的影響。
* 指令
    * 建立 View
        ```sql
        CREATE [OR REPLACE] [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
            VIEW view_name [(column_list)]
            AS select_statement
        [WITH [CASCADED | LOCAL] CHECK OPTION]
        ```

        * OR REPLACE：表示替換已有視圖
        * ALGORITHM
            * 選擇在處理定義視圖的select語句中使用的方法
                * UNDEFINED：MySQL將自動選擇所要使用的算法
                * MERGE：將視圖的語句與視圖定義合併起來，使得視圖定義的某一部分取代語句的對應部分
                * TEMPTABLE：將視圖的結果存入臨時表，然後使用臨時表執行語句
        * [WITH [CASCADED | LOCAL] CHECK OPTION]：表示視圖在更新時保證在視圖的權限範圍之內，其中
          cascade是默認值，表示更新視圖的時候，要滿足視圖和表的相關條件；local表示更新視圖的時候，要滿足該視圖定義的一個條件即可
    * 查詢資料 ★
        ```sql
        SELECT * FROM my_v4;
        SELECT * FROM my_v1 WHERE last_name='Partners';
        ```

    * 新增資料
        ```sql
        INSERT INTO my_v4(last_name, department_id) VALUES ('虚竹',90);
        ```

    * 修改資料
        ```sql
        UPDATE my_v4 SET last_name ='梦姑' WHERE last_name='虚竹';
        ```

    * 删除資料
        ```sql
        DELETE FROM my_v4;
        ```

    * 更新 View
        * 修改視圖是指修改數據庫中已存在的表的定義，當基表的某些字段發生改變時，可以通過修改視圖來保持視圖和基本表之間一致
        * 因為視圖本身沒有數據，因此對視圖進行的dml操作最終都體現在基表中
            ```sql
            -- 方式一：
            CREATE OR REPLACE VIEW test_v7ASSELECT last_name FROM employeesWHERE employee_id>100;

            -- 方式二:
            ALTER VIEW test_v7ASSELECT employee_id FROM employees;SELECT * FROM test_v7;
            ```

        * 有下列內容之一，視圖不能做DML操作
            * select子句中包含distinct
            * select子句中包含組函數
            * select語句中包含group by子句
            * select語句中包含order by子句
            * select語句中包含union 、union all等集合運算符
            * where子句中包含相關子查詢
            * from子句中包含多個表
            * 如果視圖中有計算列，則不能更新
            * 如果基表中有某個具有非空約束的列未出現在視圖定義中，則不能做insert操作
    * 刪除 View
        * 刪除視圖是指刪除數據庫中已存在的視圖，刪除視圖時，只能刪除視圖的定義，不會刪除數據，也就是說不動基表：
            ```sql
            DROP VIEW test_v1,test_v2,test_v3;
            ```

    * 查看 View
        ```sql
        DESC test_v7;SHOW CREATE VIEW test_v7;
        ```

### 存储过程 procedure

* 簡介
    * SQL Procedure 就是把 SQL Query 的邏輯寫在 DB 裡面，要使用時直接 call procedure 的名稱就好，視情況丟參數進去
* 好处
    1. 提高了sql语句的重用性，减少了开发程序员的压力
    2. 提高了效率
    3. 减少了传输次数
* 分类：
    1. 无返回无参
    2. 仅仅带 in 类型，无返回有参
    3. 仅仅带out类型，有返回无参
    4. 既带in又带out，有返回有参
    5. 带inout，有返回有参注意：in、out、inout都可以在一个存储过程中带多个
* 指令
    * 创建存储过程
        * 語法
            ```sql
            create procedure 存储过程名(in|out|inout 参数名  参数类型,...) # 類似函式定義
            begin
                存储过程体
            end
            ```

        * 注意
            1. 需要设置新的结束标记
                * delimiter 新的结束标记
                * 示例：delimiter $

                ```sql
                CREATE PROCEDURE 存储过程名(IN|OUT|INOUT 参数名  参数类型,...)
                BEGIN
                    sql语句1;
                    sql语句2;
                END $
                ```

            2. 存储过程体中可以有多条sql语句，如果仅仅一条sql语句，则可以省略begin end
            3. 参数前面的符号的意思
                * in: 该参数只能作为输入 （该参数不能做返回值）
                * out：该参数只能作为输出（该参数只能做返回值）
                * inout：既能做输入又能做输出
    * 调用存储过程
        * 語法
            ```sql
            call 存储过程名(实参列表)
            ```

### 函数 Function

* 创建函数
    * 語法
        ```sql
        CREATE FUNCTION 函数名(参数名 参数类型,...) RETURNS 返回类型
        BEGIN
        函数体
        END
        ```

* 調用函數

    ```
    SELECT 函数名（实参列表）
    ```

* 函数和存储过程的区别

关键字 调用语法 返回值 应用场景 函数 FUNCTION SELECT 函数() 只能是一个 一般用于查询结果为一个值并返回时，当有返回值而且仅仅一个 存储过程 PROCEDURE CALL 存储过程() 可以有0个或多个 一般用于更新

### 流程控制结构

* 系统变量
    * 全局变量
        * 作用域：针对于所有会话（连接）有效，但不能跨重启
        * 語法
            * 查看所有全局变量

                ```
                SHOW GLOBAL VARIABLES;
                ```

            * 查看满足条件的部分系统变量

                ```
                SHOW GLOBAL VARIABLES LIKE '%char%';
                ```

            * 查看指定的系统变量的值

                ```
                SELECT @@global.autocommit;
                ```

            * 为某个系统变量赋值

                ```
                SET @@global.autocommit=0;
                SET GLOBAL autocommit=0;
                ```

    * 会话变量
        * 作用域：针对于当前会话（连接）有效
        * 語法
            * 查看所有会话变量

                ```
                SHOW SESSION VARIABLES;
                ```

            * 查看满足条件的部分会话变量

                ```
                SHOW SESSION VARIABLES LIKE '%char%';
                ```

            * 查看指定的会话变量的值

                ```
                SELECT @@autocommit;
                SELECT @@session.tx_isolation;
                ```

            * 为某个会话变量赋值

                ```
                SET @@session.tx_isolation='read-uncommitted';
                SET SESSION tx_isolation='read-committed';
                ```

* 自定义变量
    * 用户变量
        * 声明并初始化：

            ```
            SET @变量名=值;
            SET @变量名:=值;
            SELECT @变量名:=值;
            ```

        * 赋值：
            * 方式一：一般用于赋简单的值

                ```
                SET 变量名=值;
                SET 变量名:=值;
                SELECT 变量名:=值;
                ```

            * 方式二：一般用于赋表中的字段值

                ```
                SELECT 字段名或表达式 INTO 变量 FROM 表;
                ```

        * 使用：

            ```
            select @变量名;
            ```

    * 局部变量
        * 声明：
            ```
            declare 变量名 类型 【default 值】;
            ```

        * 赋值：
            * 方式一：一般用于赋简单的值
                ```sql
                SET 变量名=值;
                SET 变量名:=值;
                SELECT 变量名:=值;
                ```

            * 方式二：一般用于赋表 中的字段值
                ```sql
                SELECT 字段名或表达式 INTO 变量 FROM 表;
                ```

        * 使用：
            ```sql
            select 变量名
            ```

    * 二者的区别： 作用域 定义位置 语法 用户变量 当前会话 会话的任何地方 加@符号，不用指定类型 局部变量 定义它的BEGIN END中 BEGIN END的第一句话 一般不用加@,需要指定类型
* 循环
    * 语法：
        ```
        【标签：】WHILE 循环条件  DO
            循环体
        END WHILE 【标签】;
        ```

    * 特点：
        * 只能放在BEGIN END里面
        * 如果要搭配leave跳转语句，需要使用标签，否则可以不用标签
        * leave类似于java中的break语句，跳出所在循环！！！

### 特殊議題

#### charset

* utf8mb4 和 utf8 比較
    * utf8 (utf8mb3)
        * A UTF-8 encoding of the Unicode character set using one to three bytes per character.
        * MySQL 的 utf-8 不是真正的 utf-8
    * utf8mb4
        * A UTF-8 encoding of the Unicode character set using one to four bytes per character.
        * mb4即 most bytes 4，使用4個字節來表示完整的UTF-8。而MySQL中的utf8是utfmb3，只有三個字節，節省空間但不能表達全部的UTF-8，只能支持“基本多文種平面”（Basic
          Multilingual Plane，BMP）。
        * 推薦使用 utf8mb4。
* utf8mb4_unicode_ci 和 utf8mb4_general_ci 比較
    * general_ci 更快，而 unicode_ci 更準確
    * in German and some other languages ß is equal to ss. 這種情況 unicode_ci 能準確判斷。
        * utf8mb4_general_ci P=p Q=q R=r=Ř=ř S=s=ß=Ś=ś=Ş=ş=Š=š sh ss sz
        * utf8mb4_unicode_ci P=p Q=q R=r=Ř=ř S=s=Ś=ś=Ş=ş=Š=š sh ss=ß sz
        * 使用utf8mb4_bin可以將上面的字符區分開來。
    * 貌似general_ci 也快不了多少，所以更推薦unicode_ci。
* 大小寫敏感
    * utf8mb4_bin： 將字串用二進位的方式存，區分大小寫
    * utf8mb4_general_cs： 區分大小寫
    * utf8mb4_unicode_ci： 是基於標準的Unicode來排序和比較，能夠在各種語言之間精確排序
    * utf8mb4_general_ci：是一個遺留的 校對規則，不支持擴展，它僅能夠在字符之間進行逐個比較。utf8_general_ci校對規則進行的比較速度很快，但是與使用
      utf8mb4_unicode_ci的校對規則相比，比較正確性較差。不區分大小寫
    * 但貌似不存在utf8_unicode_cs ，可能是算法決定的吧？

## MySQL 進階

### 評估效能

#### 使用 Explain

* Explain
    * id: 1
    * select_type
        * simple
            * 表示簡單 select (不使用union或子查詢)
        * primary
            * 表示最外層的 select
        * union
            * 表示這個許句是 union 中的第二個或後面的select語句
        * dependent
            * union union中的第二個或後面的select語句,取決於外面的查詢
        * union result
            * union的結果。
        * subquery
            * 子查詢中的第一個select
        * dependent subquery
            * 子查詢中的第一個select,取決於外面的查詢
        * derived
            * 匯出表的select(from子句的子查詢)
    * table
        * 顯示這一行的資料是關於哪張表的
    * type
        * 這是重要的列，顯示了使用那一種類型
        * 從最好到最差的連線型別為：
            * system
            * const (一次就命中，針對主鍵或唯一索引的等值查詢掃瞄, 最多只返回一行數據. const 查詢速度非常快, 因為它僅僅讀取一次即可.)
            * eq_ref (MySQL在連接查詢時，會從最前面的資料表，對每一個記錄的聯合，從資料表中讀取一個記錄，在查詢時會使用索引為主鍵或唯一鍵的全部。)
            * ref (通常最好到 ref，只有在查詢使用了非唯一鍵或主鍵時才會發生。)
            * fulltext
            * ref_or_null
            * index_merge
            * unique_subquery
            * index_subquery
            * range
                * 一般來說至少要達到 range
                * 用索引返回一個範圍的結果。例如：使用大於>或小於<查詢時發生
            * index (此為針對索引中的資料進行查詢)
            * ALL (掃描了全表才能確定結果)
    * possible_keys
        * 顯示可能使用到的索引，或是 Where 中最適合的欄位
    * key
        * 實際使用到的索引。如果為NULL,則沒有使用索引。如果為primary的話,表示使用了主鍵。
    * key_len: 4
        * 最長的索引寬度。如果鍵是NULL,長度就是NULL。在不損失精確性的情況下,長度越短越好
    * ref
        * const -* 顯示哪個欄位或常數與key一起被使用。
    * rows
        * 這個數表示mysql要遍歷多少資料才能找到
        * 在innodb上是不準確的。
    * Extra
        * Extra為MySQL用來解析額外的查詢訊息
        * 可能的欄位
            * Distinct：當MySQL找到相關連的資料時，就不再搜尋。
            * Not exists：MySQL優化 LEFT JOIN，一旦找到符合的LEFT JOIN資料後，就不再搜尋。
            * Range checked for each Record(index map:#)：無法找到理想的索引。此為最慢的使用索引。
            * Using filesort：當出現這個值時，表示此SELECT語法需要優化。因為MySQL必須進行額外的步驟來進行查詢。
            * Using index：返回的資料是從索引中資料，而不是從實際的資料中返回，當返回的資料都出現在索引中的資料時就會發生此情況。
            * Using temporary：同Using filesort，表示此SELECT語法需要進行優化。此為MySQL必須建立一個暫時的資料表(Table)來儲存結果，此情況會發生在針對不同的資料進行ORDER
              BY，而不是GROUP BY。
            * Using where：使用WHERE語法中的欄位來返回結果。
            * System：system資料表，此為const連接類型的特殊情況。
            * Const：資料表中的一個記錄的最大值能夠符合這個查詢。因為只有一行，這個值就是常數，因為MySQL會先讀這個值然後把它當做常數。

### 備份和還原

完全備份 差異備份 增量備份

Xtrabackup

### 內部實作

#### InnoDB 緩衝池(buffer pool)

* 用途
    * 緩存表數據與索引數據，把磁盤上的數據加載到緩衝池，避免每次訪問都進行磁盤IO，起到加速訪問的作用。
    * 對於讀請求，緩衝池能夠減少磁盤IO，提升性能
* 做法
    * InnoDB以變種LRU算法管理緩衝池，並能夠解決“預讀失效”與“緩衝池污染”的問題
        * 詳情參考：[https://juejin.im/post/5d11a79ee51d4555e372a624](https://juejin.im/post/5d11a79ee51d4555e372a624)

#### 寫緩沖(change buffer)

* 用途
    * 降低寫操作的磁盤IO，提升數據庫性能。
* 做法
    * 如果在緩衝池內
        * 直接修改緩衝池中的頁，一次內存操作；
        * 寫入redo log，一次磁盤順序寫操作
    * 如果不在緩衝池內
        * 未用 change buffer 優化
            * 先把需要為40的索引頁，從磁盤加載到緩衝池，一次磁盤隨機讀操作；
            * 修改緩衝池中的頁，一次內存操作；
            * 寫入redo log，一次磁盤順序寫操作；
        * 使用 change buffer 優化 (只能用在普通索引)
            * 在寫緩衝中記錄這個操作，一次內存操作；
            * 寫入redo log，一次磁盤順序寫操作
* 要點
    * 雖然叫 change buffer，但實際上它是可以持久化的數據，也會被寫到硬碟上
    * change buffer 用的是 buffer pool 里的内存，因此不能无限增大。change buffer 的大小，可以通过参数 `innodb_change_buffer_max_size` 来动态设置。这个参数设置为
      50 的时候，表示 change buffer 的大小最多只能占用 buffer pool 的 50%。
* 限制
    * 唯一索引和非唯一索引在查詢上效能幾乎是沒有差別的，主要考慮是對更新效能的影響，關鍵就是 change buffer
    * 不適合的場景
        * 數據庫都是唯一索引；
        * 或者，寫入一個數據後，會立刻讀取它；
    * 適合的場景 (如 log)
        * 數據庫大部分是非唯一索引；
        * 業務是寫多讀少，或者不是寫後立刻讀取；
* SQL Query 處理的順序
    * FROM / JOIN 和 ON
    * WHERE
    * GROUP BY
    * HAVING
    * SELECT
    * ORDER BY
    * LIMIT

* 但資料庫不真的用這個順序處理，因為他做了很多優化
* 這個順序可以用來理解 query 是否合理和其理由，但不能用來考慮效能相關或是 index 的問題
    * Can I do WHERE on something that came from a GROUP BY? (no! WHERE happens before GROUP BY!)
    * Can I filter based on the results of a window function? (no! window functions happen in SELECT, which happens
      after both WHERE and GROUP BY)
    * Can I ORDER BY based on something I did in GROUP BY? (yes! ORDER BY is basically the last thing, you can ORDER BY
      based on anything!)
    * When does LIMIT happen? (at the very end!)
