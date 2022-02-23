# WebAssembly 學習筆記

WebAssembly 是一種二進制指令格式，簡稱為 Wasm，它可以運行在適用於堆棧的虛擬機上。

WebAssembly 存在的意義就是成為編程語言的可移植編譯目標，讓在 Web 上部署客戶端和服務端應用成為可能。

Wasm 具有緊湊的二進制格式，可為我們提供近乎原生的網絡性能。隨著它變得越來越流行，許多語言都編寫了編譯成 Web 程序集的綁定工具。

![wasm-1.webp](./images/wasm-1.webp)

## 好處

### 可移植性

如果你的網站現在想用一個能力，但是這個能力還沒有被任何的 JavaScript 庫實現，但是在其他編程領域裡已經有瞭解決方案。

這時就可以借助 WebAssembly 將所需要的庫編譯為可以在 Web 上運行的二進制格式，在某些情況下甚至你還可以編譯整個應用。一旦編譯到 WebAssembly ，代碼就可以在任何裝有網絡瀏覽器的設備上運行了，例如 PC、手機、平板電腦等等。

### 安全性

WebAssembly  需要在沙盒中運行，在沙盒中，除了初始化時程序主動提供給它的內容，它無法訪問其他主機的內存和函數。

這意味著， WebAssembly ，在你沒有給它下發命令的情況下，永遠不會損壞你的主機進程內存，也無法隨意訪問文件系統或與其他設備通信。這就讓它與運行在虛擬機和容器中的應用有相同的優勢

### 高效

與 JavaScript 等人類可讀的語言相比， WebAssembly 的字節碼可以用更少的字節表示相同的指令，並且在  WebAssembly  模塊依然處於下載期間就可以被編譯。

因為編譯器已經事先完成了優化工作，在 WebAssembly 中可以更輕松的獲取到可預測的性能

## 進展

WebAssembly 現在已經處於穩定階段了，幾年前就被所有主流瀏覽器所支持，但是它仍在不斷發展，探索新的能力。

可查看： https://webassembly.org/roadmap/

## 有趣應用

* [Wasm 玩出花？在浏览器中运行虚拟机！](https://mp.weixin.qq.com/s/RQq8K7GmLysAx55Vuk-K5A)

## 參考文章

* [Wasm 為 Web 開發帶來無限可能](https://mp.weixin.qq.com/s/6dHxBZcZk8905nvSsjz67A)
