# JavaScript 學習筆記

## JS 加載位置

最好在 `</body>` 前加載 JS，這樣可確保該腳本不會阻礙其它內容的加載，同時在該腳本被下載和執行之前，頁面的內容已加載完畢，並可閱讀了。

## 模組化機制

* AMD (Asynchronous Module Definition)
    * 在瀏覽器中使用，並用 `define` 函式定義模組；
* CJS (CommonJS)
    * 在 NodeJS 中使用，用 `require` 和 `module.exports` 引入和匯出模組；
* ESM (ES Modules)
    * JavaScript 從 ES6(ES2015) 開始支援的原生模組機制，使用 `import` 和 `export` 引入和匯出模組；

## Node 使用 ESM 的方式

* Node 13.2.0 起開始正式支援 ES Modules 特性。
    * 注：雖然移除了 --experimental-modules 啟動引數，但是由於 ESM loader 還是實驗性的，所以執行 ES Modules 程式碼依然會有警告
* Node 使用 ESM 有兩種方式
    * 在 package.json 中，增加 type: "module" 配置；
    * 在 .mjs 檔案可以直接使用 import 和 export
    * 若不新增上述兩項中任一項，直接在 Node 中使用 ES Modules，則會丟擲警告

## Promise

已整理為文章： https://marco79423.net/articles/%E6%B7%BA%E8%AB%87-javascript-%E7%9A%84-promise/


## 函式庫要包成 CommonJS 還是 ES Module？

如果接入方以SSR的形式在服務端接入組件，可能使用CJS規范。

CSR的情況通常使用ESM。

所以SDK組件在打包編譯時需要輸出ESM、CJS兩種規范的文件。
