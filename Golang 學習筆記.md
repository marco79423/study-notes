# Golang 學習筆記

## 介紹

* 網絡搜索相關資料時，請使用約定的 golang作為關鍵字(因為 go 關鍵字的干擾太多)。
* 起源
    * developed at Google by Robert Griesemer, Rob Pike, and Ken Thompson.
    * 因為討厭 C++
    * Design begin in late 2007
    * derived from C language.
* 特色
    * Open Source (BSD)
    * UTF-8
    * produces native binaries without external dependencies.
        * 這個我覺得很讚
    * Strong and Static types
    * Garbage collected
    * Statically typed, but with a dynamic feel
    * 像 npm、pip 那樣的套件管理 (go get)
    * 物件導向，但沒有繼承，使用 Interface，但可以不用定義 (duck typing)
        * 解決了 Java 的類別繼承的效率問題，還帶來了 dynamic language 的優點，要做 duck typing 很容易
        * 非常特別
            * 沒有繼承
            * 使用介面，但可以不用定義 (像 duck typing 一樣)
    * Functions and Method with receivers
    * 沒有異常 (Exceptions)
        * 這點也很特別
    * Language-level concurrency features
        * 多執行序方面，內建的 goroutine 解決了concurrency 問題，要做多執行序的程序相當簡易，程序溝通只要寫個箭頭符號即可解決
    * For python developer
        * Go is zenlike
        * only 25 keywords (C: 32 keywords)
        * readability counts
            * Go was designed for teams of thousands of programmers. Readability is of paramount importance.
            * The gofmt tool enforces "one true style."
                * No more stupid arguments!!
        * use tab <- fuck
* 用途
    * Server daemons
    * Command-lin tools
    * Web applications
    * Games
    * Scientific computing
    * High frequency trading
    * ...
    
## 語法

* 宣告
    * 變數宣告 var a int
        * Zero-valie initialization
            * 自動初始化，若是數字型態就給 0，布林型就是 false，字串則是 ""
            * 例子
                ```golang
                var (
                    a int    // 0
                    b bool   // false
                    c string // ""
                )
                ```
        * 變數定義可以包含初始值，每個變數對應一個
            * var i, j int = 1, 2
        * 如果初始化是使用表達式，則可以省略類型；變數從初始值中獲得類型。
            * var c, python, java = true, false, "no!"
        * 可使用 := 替代 var 定義
            * c, python, java := true, false, "no!"
            * := 不能使用在函式外(var 可以)
        * 多行宣告
            ```golang
            var (
                ToBe   bool       = false
                MaxInt uint64     = 1<<64 - 1
                z      complex128 = cmplx.Sqrt(-5 + 12i)
            )
            ```
    * 常數宣告 const Pi = 3.14
        * 使用 const，不能用 := 語法
        * 只能是數字、字串或布林值
        * 數字是高精度的
            ```golang
            const (
                Big   = 1 << 100
                Small = Big >> 99
            )
            ```
        * created at compile time
        * 可使用 iota
            ```golang
            const (
                CategoryBooks = iota // 0
                CategoryHealth       // 1
                CategoryClothing     // 2
            )
            ```
* 類型
    * 基本類型
        * 布林
            * bool
        * 字串
            * string
        * 數值
            * 整數
                * int  int8  int16  int32  int64
                * uint uint8 uint16 uint32 uint64 uintptr
                * byte // uint8 的別名
                * rune // int32 的別名，代表一個Unicode碼
            * 浮點數
                * float32 float64
            * 複數
                * complex64 complex128
        * 參考
            * ![golang-1](images/golang-1.png)
    * 類型轉換
        * 與 C 不同的是 Go 的在不同類型之間的項目賦值時需要顯式轉換
        * T(v) 將值 v 轉為類型 T
            ```golang
            var i int = 42
            var j float64 = float64(i)
            var u uint = uint(f)
            ```
    * 複合類型
        * 根據原來的類型組合成新的類型
        * type
            * 透過 type 定義一個新的類型
                ```golang
                type MyInt1 int
                var i int = 0
                var i1 MyInt1 = i // error 因為 int 和 MyInt1 是不同型別
                ```
            * 透過 type 定義類型別名
                ```golang
                type MyInt2 = int
                var i1 MyInt2 = i // ok 因為 MyInt1 是 int 的別名
                ```
                * 注意類型循環，假如 `type T2 = T1` ,那麼 T1 絕對不能直接、或者間接的引用到 T2，一旦發生，編譯就會出錯
                * 可以
        * 陣列 (Array)
            * 宣告
                * [n]T 是一個有 n 個類型為 T 的值的陣列
                    ```golang
                    var a [3]int

                    c:= [3]int{1, 2, 3}

                    d:= [...]int{1, 2, 3}  // 直接讓 compiler 計算長度

                    e:=[5]int{1:1,3:4} // 等同 array:=[5]int{0,1,0,4,0}
                    ```
            * 陣列的長度是其類型的一部分，因此陣列不能改變大小
                * 所以 [4]int 和 [5]int 是不同類型，因為大小不同。
            * 陣列即代表整個陣列，並不是指向第一個元素的指標，這也代表傳值或，會複製整個陣列裡的內容，所以同類型的陣列可以互相直接賦值
                ```golang
                var a [3]int{1, 2, 3}
                var b = a       // 是複製整個陣列 (和 Python, C++ 等的行為皆不同)
                a[0] = 4
                fmt.PrintLn(a)  // [4, 2, 3]
                fmt.PrintLn(b)  // [1, 2, 3]
                ```
            * 可以使用 len 檢查陣列大小
                ```golang
                array := []int{1, 2, 3, 4, 5}
                fmt.Println("First Length:", len(array))
                ```
        * 切片 (Slice)
            * 代表一個動態、可變長度對於陣列的 view，有點像指向陣列的指標，但是加上長度訊息的東西，其用法和陣列很像，但可以改變長度大小
            * 創建 slice
                * 直接建立
                    ```golang
                    s2 := []int{2, 3, 5, 7, 11, 13}
                    ```
                * 使用 make
                    ```golang
                    s1 := make([]byte, 5)  // s1 == []byte{0, 0, 0, 0, 0}，len(s1) == 5, cap(s1) == 5

                    s2 := make([]byte, 0, 5)  // s1 == []byte{}，len(s2) == 0, cap(s2) == 5
                    ```
            * 可以重新切片，創建一個新的 slice 值指向相同的陣列。
                ```golang
                s1 := a[lo:hi]  // 表示從 lo 到 hi-1 的 slice 元素，與 Python 相同
                s2 := a[lo:lo]  // 代表空的 slice
                ```
                * 重新切片並不會建一個新的陣列拷貝，而是直接引用原來的，該陣列會一直在記憶體中，直到沒有任何引用為止。
                    * ![golang-slice-1](images/golang-slice-1.png)
            * slice 的零值是 nil
                * 一個 nil 的 slice 的長度和容量是 0。
            * append
                * append 函數可以為一個 slice 新增元素，至於如何增加、返回的是原切片還是一個新切片、長度和容量如何改變等細節，append 函數都會自動處理
                    ```golang
                    s1 := []int{1, 2, 3}
                    s2 := append(s1, 4)
                    fmt.Println(s1, s2)  // [1 2 3] [1 2 3 4]
                    ```
                * append 函式會自動增長底層 Array 的容量，目前的算法是：容量小於 1000 時，會成倍成長，一旦超過 1000 就會變成增加 25% (1.25) 的容量
            * 由於 slice 佔用空間小，在函式傳遞時，其底層 Array 不會複製，傳遞成本低，非常高效。
        * Map
            * 創建
                * 使用 make
                    ```golang
                    m := make(map[string]int)
                    m["one"] = 1
                    m["two"] = 2
                    ```
                * 直接創建
                    ```golang
                    m := map[string]int{
                        "one": 1,
                        "two": 2
                    }
                    ```
            * 取值
                ```golang
                m := make(map[string]int)

                // 取值
                m["one"] = 1

                // 取不存在的值 (該類型元素的零值)
                m["three"]  // 0

                // 測試值是否存在
                value, ok := value["two"]
                ```
            * 刪除值
                ```golang
                delete(m, key)
                ```
            * 空值為 nil，不能賦值。
        * 指標 (Pointer)
            ```golang
            v := 1
            var p *int = &v

            v  // 1
            &i // 0x11444138
            p  // 0x11444138
            ```
        * 結構 (Struct)
            * 定義
                ```golang
                type Vertex struct {
                    X int
                    Y int
                }
                ```
            * 創建
                * 直接創建
                    ```golang

                    v1 := Vertex{1, 2}

                    // 省略部分欄位
                    v2 := Vertex{X: 1}  // 省略 Y，代表 Y: 0 的意思
                    v3 := Vertex{}  // 省略 XY，代表 X:0 和 Y: 0 的意思
                    ```
                * 使用 new
                    ```golang
                    v4 := new(Vertex)  // 但要注意回傳的是指標
                    ```
                    * new 函式
            * 取值
                ```golang
                v := Vertex{1, 2}
                v.X  // 1

                // 也可以用指標取值，而且使用上沒有分別
                p := &v
                p.X  // 1
                ```
            * 可以透過組合，達到快速復用的效果
                ```golang
                type user struct {
                    name string
                    email string
                }

                type admin struct {  // 外部類型
                    user         // 內部類型
                    level string
                }

                ad:=admin{user{"張三","zhangsan@flysnow.org"}, "管理員"}
                fmt.Println(ad.name)  // 可以直接調用
                fmt.Println(ad.user.name)  // 也可以通過內部類型調用
                ```
                * 也可以覆蓋重名的方法
                    ```golang
                    func (u user) sayHello(){
                        fmt.Println("Hello，i am a user")
                    }

                    func (a admin) sayHello(){
                        fmt.Println("Hello，i am a admin")
                    }

                    ```
        * 函式
            * 變數類型定義在變數之後，如果是同樣的類型可以省略
                ```golang
                func add(x int, y int) int {
                    return x + y
                }

                func add(x, y int) int {
                    return x + y
                }
                ```
            * 函式可以有任意數量的返回值
                ```golang
                func swap(x, y string) (string, string) {
                    return y, x
                }
                ```
            * 可以直接定義返回值 (這個時候 return 不用回傳值，但還是要用 return)
                ```golang
                func split(sum int) (x, y int) {
                    x = sum * 4 / 9
                    y = sum - x
                    return
                }
                ```
            * Variadic Functions
                ```golang
                func sum(args ...int)(total int){
                    for _, value := range args {
                        total += value
                    }
                }
                ```
            * 支援匿名函式
                ```golang
                plus := func(a, b int) int {
                    return a + b
                }
                ```
        * 方法 (Method)
            * Go 沒有類別，但可在 Struct 上定義方法，但不限於 struct，任何類型皆可，但不能對其他 package 或基礎型別定義方法。
                ```golang
                type Vertex struct {
                    X, Y float64
                }

                func (v *Vertex) Abs() float64 {  // 有 receiver 的函式就是 method
                    return math.Sqrt(v.X * v.X + v.Y * v.Y)
                }

                type MyFloat float64

                func (f MyFloat) Abs() float64 {
                    if f < 0 {
                        return float64(-f)
                    }
                    return float64(f)
                }
                ```
            * 有兩種類型的接收者：
                * value reciver
                    * 呼叫時，接收到的是其值的副本，所以對該值的操作都不會影響原來的值
                        ```golang
                        type person struct {
                            name string
                        }

                        func (p person) modify(){
                            p.name = "李四"
                        }

                        p := person{name:"張三"}
                        p.modify() // p.name 值不變
                        ```
                * pointer receiver
                    ```golang
                    type person struct {
                        name string
                    }

                    func (p *person) modify(){
                        p.name = "李四"
                    }

                    p := person{name:"張三"}
                    p.modify() // p.name 值變了，修改有效
                    ```
                * Go 會自動幫我們取指標，也會自動解引用，但也可以主動自己做
                    ```golang
                    p = person{name:"張三"}
                    (&p).modify()
                    ```
                * 通常推薦使用 pointer receiver，而非 value reciver
            * 即使指標指向 nil，一樣可以呼叫其方法，不會出錯，因此可以針對性處理
                ```golang
                func (t *T) M() {
                    if t == nil {  // 可以特別針對 nil 處理
                        fmt.Println("<nil>")
                        return
                    }
                    fmt.Println(t.S)
                }

                // 但介面不行
                type I interface {
                    M()
                }

                var i I
                i.M()  // 會出錯
                ```
        * 介面 (Interface)
            * 介面類型是由一組方法定義的集合。
                ```golang
                type Animal interface {
                    says() string
                }

                struct Dog struct {}
                func (dog Dog) says () string {
                    return "Woof"
                }

                var a Animal
                a = Dog{}  // 因為 Dog 定義了 says，所以符合 Animal 的要求 (只要定義同樣的方法即可，不用明確表示實作了 Animal)
                ```
            * 要實現一個介面，必須實作介面所有方法，可以用 value reciver 定義，也可以用 pointer reciver
            * empty interface
                * 沒有定義任何方法的介面，可以用來代表任何類型，可以用來接未知類型的值 (如： Println 函式)
                    ```golang
                    interface {}
                    i = 42
                    i = "hello"
                    ```
                * 可以用 t := i.(T) 的方式判斷具體的類型和其值
                    ```golang
                    var i interface{} = "hello"

                    s := i.(string)       // s="hello"
                    s, ok := i.(string)   // s="hello", ok=true
                    f, ok := i.(float64)  // f=0, ok=false
                    f = i.(float64)       // error，string 不能轉 float64
                    ```
            * 嵌套類型
                ```golang
                type Reader interface {
                    Read(p []byte) (n int, err error)
                }

                type Writer interface {
                    Write(p []byte) (n int, err error)
                }

                type ReadWriter interface {  // 組合 Reader 和 Writer 的介面
                    Reader
                    Writer
                }
                ```
* 流程控制
    * C 和 Go 的比較
        | C/C++                            | Go              |
        |----------------------------------|-----------------|
        | if/else, if/else if/else, switch | if/else, switch |
        | for,  while, do/while            | for             |
        | goto                             | goto            |
    * if/else
        * if 語句除了沒有 ( ) 之外（甚至強制不能使用它們），看起來跟 C 或者 Java 中的一樣，但要注意大括號 { } 是必須的。
        * if 可以在條件中初始化變數
            ```golang
            if err := clicked(); err != nil {
                fmt.Println(err)
                return err
            }
            ```
    * switch
        * 不像 C 那樣只能用常數和數字，可以使用字串，也可以用來判斷，可以用來代替 if/else if 的用途。
            ```golang

            // 字串
            switch os := runtime.GOOS; os {
            case "darwin":
                fmt.Println("OS X.")
            case "linux":
                fmt.Println("Linux.")
            default:
                fmt.Printf("%s.", os)
            }

            // 沒有條件的 switch 同 switch true 一樣，代替 if-then-else 鏈。
            switch {
            case t.Hour() < 12:
                fmt.Println("Good morning!")
            case t.Hour() < 17:
                fmt.Println("Good afternoon.")
            default:
                fmt.Println("Good evening.")
            }

            switch {
            case '0' <= char && char <= '9':
                fmt.Println("number")
            case 'a' <= char && char <= 'z':
                fmt.Println("alphabet")
            default:
                fmt.Println("woof")
            }

            // 用來判斷型態
            switch v := i.(type) {
            case T:
                // here v has type T
            case S:
                // here v has type S
            default:
                // no match; here v has the same type as i
            }
            ```
        * 從上到下執行判斷，直到匹配成功為止，最特別的地方是 fallthrough 語句結束，否則分支會自動終止
            ```golang
            switch num {
                case 0:
                    fallthrough
                case 1:
                    fmt.Println(num)
            }

            switch num {
                case 0, 1:
                    fmt.Println(num)
            }

            // 容易出錯的地方
            switch num {
                case 0:  // 0 不會印
                case 1:
                    fmt.Println(num)
            }
            ```
    * for
        * Go只有一種循環結構： for 循環
        * 有四種型式
            * for init; condition; post {}
                * 對應 C 的 for 迴圈
                    ```golang
                    sum:= 0
                    for i := 0; i <= 10; i++ {
                        sum += 1
                    }
                    ```
                * 不能用 var，直接用 :=
            * condition {}
                * 對應 C 的 while
                    ```golang
                    for i < 10 {
                        println("meow")
                        i += 1
                    }
                    ```
            * for {}
                * 對應 Endless loop 的用法
                    ```golang
                    for {
                        println("meow")
                    }
                    ```
            * for v range list {}
                * 對應 foreach 的用法
                    ```golang
                    for v := range list {
                        println(v)
                    }
                    ```
                * range 感覺就是 enumerate
                * 可以用 _ 來忽略序號或值。
                    ```golang
                    for _ := range list {
                        println("haha")
                    }
                    ```
    * defer
        * 執行的時間點是離開函式的時候，並依照後進先出的 (LIFO) 順序。
            ```golang
            func f() {
                for i := 0; i < 5 ; i++ {
                    defer fmt.Println(i)    // 顯示 4 3 2 1 0
                }
            }
            ```
        * defer 會在參數呼叫時傳遞，並非單純移到函式後面而已
            ```golang
            func f() {
                var i int = 3
                defer fmt.Println(i)  // 同樣顯示 3，而非 4
                i += 1
            }
            ```
        * 通常用來清理，比如使用 fopen / fclose 時
            ```golang
            func CopyFile(dstName, srcName string) (written int64, err error) {
                src, err := os.Open(srcName)
                if err != nil {
                    return
                }
                defer src.Close()  // 避免中途 return 時沒關檔

                dst, err := os.Create(dstName)
                if err != nil {
                    return
                }
                defer dst.Close()  // 避免中途 return 時沒關檔

                return io.Copy(dst, src)
            }
            ```
    * goto
        * 必須在當前的函式跳
            ```golang
            func myFunc() {
                i := 0
            Here:
                println(i)
                i++
                goto Here
            }
            ```
* 錯誤處理
    * 習慣風格
        ```golang
        i, err := strconv.Atoi("42")
        if err != nil {
            fmt.Printf("couldn't convert number: %v\n", err)
            return
        }
        ```
    * Go 採用 Panic and Recover 的機制取代 Exception，要記得這是最後的手段 (感覺和 Python 的看法不同)
        * 和一般的 Exception 不同，go 多了 deferred 這個概念，當 panic 發生時，會正常執行已經 deffer 的函式後才會退出程式
        * 也因為發生錯誤時同樣會執行 deferred 的函式，所以可以在裡面使用 recover，達到 try ... catch 的效果
            * deferred function 執行順序為 LIFO
            * defer 遇上 os.Exit 時失效
                * Basically panic is for you, a bad exit code is for your user.
                * 只在最外層 function return 前執行
                * os.Exit 會立即離開，不會 return，致使無法觸發 deferred function
        * 除了在執行期出現錯誤時觸發 panic 外，也可能由程式碼中主動觸發。
            ```golang
            panic(err)
            ```
        * recover 正常的時候只會回傳 nil，而且不會有任何副作用，但出現異常時，就能接住 panic 時的值處理，並回復正常的執行
             ```golang
            func Compile(str string) (regexp *Regexp, err error) {
                regexp = new(Regexp)
                // doParse will panic if there is a parse error.
                defer func() {
                    if e := recover(); e != nil {
                        regexp = nil    // Clear return value.
                        err = e.(Error) // Will re-panic if not a parse error.
                    }
                }()
                return regexp.doParse(str), nil
            }
            ```
* 反射
    * TypeOf 可以查詢實例的類型
        ```golang
        u := User{"張三",20}
        t := reflect.TypeOf(u)  // 回傳 reflect.Type
        fmt.Println(t) // main.User
        ```
    * ValueOf
        ```golang
        u := User{"張三",20}
        v := reflect.ValueOf(u)  // 回傳 reflect.Value
        fmt.Println(v) // {張三 20}

        fmt.Println(v.Interface().(User)) // 再轉回 User
        ```
* Goroutine
    * goroutine 是由 Go 運行時環境管理的輕量級線程
        * 非常輕量，同時跑上百個執行緒不是問題
        * 不是 Thread，有可能跑了上千個 groutine，但只有一個 thread，但也不是 Event loop，因為確實可以跑多個 thread
        * 沒有 Global Interpreter Lock (GIL)
    * 使用 go 啟動新的 goroutine
        ```golang
        go f(x, y, z)
        ```
    * 用 atomic 解決競爭問題，可用來處理較簡單的情況
        ```golang
        value := atomic.LoadInt32(&count)
        runtime.Gosched()
        value++
        atomic.StoreInt32(&count,value)
        ```
    * Mutex
        ```golang
        mutex.Lock()
        value := count
        runtime.Gosched()
        value++
        count = value
        mutex.Unlock()
        ```
    * channel
        * channel使用前必須創建
            * 無緩衝的 channel，在另一端準備好之前，發送和接收都會阻塞
                ```golang
                ch := make(chan int)
                ```
            * 帶緩衝的 channel
                ```golang
                ch := make(chan int, 2)  // 可以指定 buffer 大小 (Buffer Channel)，這樣只會在緩衝區滿時才會阻塞
                ch <- 1
                ch <- 2
                fmt.Println(<-c)
                fmt.Println(<-c)
                ```
                * 實例－抓取最先回來的當結果
                    ```golang
                    func query() string {
                        responses := make(chan string, 3)
                        go func() { responses <- request("asia.gopl.io") }()
                        go func() { responses <- request("europe.gopl.io") }()
                        go func() { responses <- request("americas.gopl.io") }()
                        return <-responses // 回傳第一個回傳的結果
                    }
                    ```
            * 單向 channel (可以防止誤操作)
                ```golang
                var send chan<- int //只能發送
                var receive <-chan int //只能接收
                ```
        * 可透過 `<-` 發送或接收值。 (「箭頭」就是數據流的方向)
            ```golang
            ch <- v    // 將 v 送入 channel ch。

            v := <-ch     // 從 ch 接收，並且賦值給 v。
            v, ok := <-ch // 通過第二參數來測試 channel 是否被關閉
            ```
        * 可以用 `cap(ch)` 和 `len(ch)` 檢查 channel 的空間
        * 發送者可以用 `close(chan)` 關閉 channel。
        * 不斷從 channel 接收值，直到它被關閉.
            ```golang
            for i := range c {

            }
            ```
        * 只有發送者才能關閉channel，而不是接收者。
        * 向一個已經關閉的channel發送數據會引起 panic
        * 通常情況下無需關閉 channel。只有在需要告訴接收者沒有更多的數據的時候才有必要進行關閉，例如中斷一個 range
        * 透過 select 執行符合條件的分支，如果多個都符合則會隨機選擇一個，在此之前會阻塞 (但若有 default，便會執行 default 分支)。
            ```golang
            select {
            case c <- x:
                x, y = y, x+y
            case <-quit:
                fmt.Println("quit")
                return
            }

            select {
            case <-tick:
                fmt.Println("tick.")
            case <-boom:
                fmt.Println("BOOM!")
                return
            default:
                fmt.Println("    .")
                time.Sleep(50 * time.Millisecond)
            }
            ```
    * Context
        * 建立初始的 Context
            ```golang
            context.Background()  // 空 Context，沒有值、不能被取消、也沒有 deadline
            ```
            * 另外還有特殊的 `context.TODO()`
        * Context 是一層一層，每個 Context 都可以都過 WithXXXX 產生新的子 Context 和能取消該子 Context 的函式。通過這些函式建立一顆 Context Tree，其每個節點都可以有任意數量個子節點。
            * context.WithCancel
                ```golang

                // 子 Context 和取消函式
                ctx, cancel := context.WithCancel(context.Background())

                // 開始監控
                go func(ctx context.Context) {
                    for {
                        select {
                        case <-ctx.Done():
                            return
                        default:
                            fmt.Println("監控中...")
                            time.Sleep(2 * time.Second)
                        }
                    }
                }(ctx)

                time.Sleep(10 * time.Second)
                fmt.Println("任務完成，通知監控停止")
                cancel()
                ```
            * context.WithDeadline
                * 建立一個有 deadline 的 Context，會多傳遞一個截止時間，意味到了這個時間點，會自動取消 Context，當然我們也可以不等到這個時候，可以提前通過取消函數進行取消。
                    ```golang
                    d := time.Now().Add(50 * time.Millisecond)
                    ctx, cancel := context.WithDeadline(context.Background(), d)

                    defer cancel()  // 即使 Context 會過期，實務上建議還是要呼叫其 cancel 函式

                    select {
                    case <-time.After(1 * time.Second):
                        fmt.Println("overslept")
                    case <-ctx.Done():
                        fmt.Println(ctx.Err())
                    }
                    ```
                * 要注意的是子 Context 的 Deadline 時間一定不會超過父 Context 的 Deadline
                    * 如果 Deadline 超過父 Context 的 Deadline，會直接回傳父 Context 的拷貝。
            * context.WithTimeout
                * 和 WithDeadline 和接近，只是 WithDeadline 是直接指定取消的時間，而 WithTimeout 是多少時間後取消
            * context.WithValue
                * 生成一個綁定了一個鍵值對數據的 Context，但沒有沒有取消函式，這個綁定的數據可以通過Context.Value方法訪問到
                    ```golang
                    ctx, cancel := context.WithCancel(context.Background())
                    valueCtx := context.WithValue(ctx, key, value)
                    go func(ctx context.Context) {
                        for {
                            select {
                            case <-ctx.Done():
                                return
                            default:
                                fmt.Println(ctx.Value(key)) //取出值
                                time.Sleep(2 * time.Second)
                            }
                        }
                    }(valueCtx)
                    time.Sleep(10 * time.Second)
                    fmt.Println("任務完成，通知監控停止")
                    cancel()
                    ```
        * 當父 Context 被取消時，其派生的所有 Context 都將取消。
        * 使用原則
            * 不要把 Context 放在 struct 裡，要以參數的方式傳遞
            * 以 Context 作為參數的函數，應該把 Context 當作第一個參數。
            * 傳遞 Context 給一個函數時，不能傳遞 nil，若不知傳遞什麼，就用 context.TODO
            * 只傳必要的值給 Context，不要什麼數據都使用這個傳遞
            * Context 是線程安全的，可以放心的在多個 goroutine 中傳遞
    * WaitGroup
        * 一種控制並發的方式，可以控制多個 goroutine 同時完成。只有三個方法：Add()、Done() 和 Wait()
            ```golang
            var wg sync.WaitGroup

            wg.Add(2)  // 設定需要等待幾個 goroutines
            go func() {
                time.Sleep(2*time.Second)
                fmt.Println("1號完成")
                wg.Done()  // 其實就是 Add(-1) 的別名
            }()
            go func() {
                time.Sleep(2*time.Second)
                fmt.Println("2號完成")
                wg.Done()
            }()
            wg.Wait()  // 持續等待直到計數為 0
            fmt.Println("好了，大家都幹完了，收工")
            ```
        * 適用於適用於多個 goroutine 協同做一件事情的時候，因為每個 goroutine 做的都是這件事情的一部分，只有全部的goroutine都完成，這件事情才算是完成。
* Package
    * 每個 Go 程式都是由 Package 組成的
    * 命名
        * 命令以簡潔、小寫和在目錄同名為原則。
        * 按照慣例，Package 的名稱要和導入路徑的最後一個目錄一致。
            ```golang
            // 引入路徑為 math/rand
            package rand
            ```
        * 程式運行的入口的 Package 為 main，裡頭一定有 main() 函式，可以編譯成一個二進位的執行檔，執行檔的名稱會是該目錄的名稱
        * package 中的變數和函式命名開頭字元大小寫是有差異的
            ```golang
            Test()  // 大寫開頭：在 package 之外可見，稱作 exported
            test() // 小寫開頭：僅限於 package 內使用，稱作 unexported
            ```
    * 引入
        * 引入方式
            ```golang
            // 方式一
            import "fmt"
            import "math"

            // 方式二
            import (
                "fmt"
                "math"
            )
            ```
        * 如果有重覆的名稱可以重新命名引入的 Package
            ```golang
            import (
                "fmt"
                myfmt "mylib/fmt"  // 重新命名為 myfmt
            )
            ```
        * 由於 Go 要求引入後必須使用，所以若碰到需要引入，但又不使用的時候，就可以使用 `_` (只想執行其 Package 的 init 函式時的狀況)
            ```golang
            import (
                _ "mylib/fmt"  // 不想使用 fmt
            )
            ```
        * 如果引入時包含網域並且 workspace 裡沒有，那麼 `go get` 時會自動 fetch、build 和 install
            ```bash
            go get github.com/golang/example/hello
            ```
    * init 函式
        * 每個 Package 都可以 **有任意多個 init 函式** ，它們會在 package 引入時執行。可以用來初始化全域的設定和變數等。
            ```golang
            ackage mysql

            import (
                "database/sql"
            )

            func init() {
                sql.Register("mysql", &MySQLDriver{})
            }
            ```
        * 最好不要使用
* 專案架構
    * Workspace
        * Go 相關的程式碼全都統一放在 workspace 中
            ```bash
            bin/ # 可執行的檔案，go 會把編譯完的結果放置在此
                hello
                outyet
            src/ # Go 的源碼 (可以包含多個 repo，此例為 example 和 image 兩個)
                github.com/golang/example/     # 包含兩個 command (hello, outyet) 和一個 package (stringutil)
                    .git/
                    hello/
                        hello.go
                    outyet/
                        main.go
                        main_test.go
                    stringutil/
                        reverse.go
                        reverse_test.go
                golang.org/x/image/
                    .git/
                    bmp/
                        reader.go
                        writer.go
                ... (many more repositories and packages omitted) ...
            ```
        * 每一個 workspace 可能會包含多個 repository，每個 repository 也可能會包含多個 packages，而每個 package (一個資料夾)可能會包含多個 go 程式碼檔案
        * golang 會自動偵測 vendor 資料夾，當作 dependencies 的來源
            * vendor 可以是 nested
    * 重要環境變數
        * GOROOT
            * 系統 Go package 的位置
        * GOPATH
            * 代表 Workspace 的位置
* 測試 (Test)
    * 寫有單元測試的檔案必須以 `_test.go` 結尾，裡頭必須包含測試函式，測試函式會以 `Test` 當作前綴，並接收一個 `*testing.T` 類型的參數。
        ```golang
        // main.go
        func Add(a, b int) int {
            return a + b
        }

        // main_test.go
        func TestAdd(t *testing.T) {
            sum := Add(1, 2)
            if sum == 3 {
                t.Log("the result is ok")
            } else {
                t.Fatal("the result is wrong")
            }
        }
        ```
    * 基準測試的函式則以 `Benchmark` 開頭，並接受一個 `*testing.B` 類型的參數。
        ```golang
        num:=10
        b.ResetTimer()
        for i:=0 ;i < b.N ; i++ {  // b.N 代表循環的次數
            fmt.Sprintf("%d",num)
        }
        ```
* Go 指令
    * go env
        * 查看當前 go 環境的訊息
    * go build
        * 啟動編譯，將程式和相關依賴編譯成一個執行檔，並放置在當前的目錄。
            ```bash

            # 路徑 (相對於 GOROOT 和 GOPATH，)
            go build
            go build .
            go build hello.go
            go build flysnow.org/tools
            go build flysnow.org/tools/...  # ... 代表編譯匹配所有字串，斷以會編譯 tools 路徑下所有 package

            go build all  # 編譯全部
            ```
        * 跨平台編譯
            * 透過環境變數 GOOS 和 GOARCH
                ```bash
                GOOS=linux GOARCH=amd64 go build flysnow.org/hello
                ```
            * GOOS 指目標作業系統，目前支持的有：
                * darwin
                * freebsd
                * linux
                * windows
                * android
                * dragonfly
                * netbsd
                * openbsd
                * plan9
                * solaris
            * GOARCH 指目標處理器的架構，目前支持的有：
                * arm
                * arm64
                * 386
                * amd64
                * ppc64
                * ppc64le
                * mips64
                * mips64le
                * s390x
        * 檢查資源競爭
            ```bash
            go build -race
            ./hello
            ```
    * go run
        * 編譯完執行
    * go install
        * 編譯後產生執行檔於 $GOPATH/bin
        * 也可以用 go install all
        * 可以在任何地方執行這個指令
            * 當執行 `go install github.com/marco79423/gosulabug` Go 會自動根據 GOPATH 尋找對應的 package
            * 也可以直接到該目錄執行 `go install`
    * go clean
        * 將編譯生成的檔案包含執行檔都刪除 (install 的不會刪)
        * 可以在提交 commit 前使用
    * go get
        * 從網上下載更新指定的 package 和其依賴，並對它們進行編譯和安裝。
        * 若要更新 package 可加 -u
            ```bash
            go get -u github.com/spf13/cobra
            ```
    * go fmt
        * 自動格式化 go 原始碼並儲存，可以指定路徑，若不加則代表當前目錄
    * go vet
        * 幫助我們檢查我們代碼中常見的錯誤
    * go doc
        * 查看文檔
        * 在線查看文檔 `gdoc -http=:8080`
    * go test
        * `-coverprofile` 顯示測試覆蓋率，
            ```bash
            go test -v -coverprofile=coverage.out
            go tool cover -html=coverage.out -o=coverage.html
            ```
        * `-bench` 基準測試，
            ```bash
            go test -v -bench=. ./app/...                # -bench=. 表示運行所有基準測試
            go test -v -bench=. -benchtime=3s ./app/...  # 測試時間默認是 1 秒，但也可以透過 -benchtime 指定測試的時間
            go test -v -bench=. -benchmem ./app/...      # -benchmem 可以提供每次操作分配 memory 的次數
            ```
