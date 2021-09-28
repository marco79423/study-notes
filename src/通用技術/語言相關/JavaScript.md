# JavaScript 學習筆記

## Promise

已整理為文章： https://marco79423.net/articles/%E6%B7%BA%E8%AB%87-javascript-%E7%9A%84-promise/

## Node 使用 ESM 的方式

* Node 13.2.0 起開始正式支援 ES Modules 特性。
    * 注：雖然移除了 --experimental-modules 啟動引數，但是由於 ESM loader 還是實驗性的，所以執行 ES Modules 程式碼依然會有警告
* Node 使用 ESM 有兩種方式
    * 在 package.json 中，增加 type: "module" 配置；
    * 在 .mjs 檔案可以直接使用 import 和 export
    * 若不新增上述兩項中任一項，直接在 Node 中使用 ES Modules，則會丟擲警告

## 函式庫要包成 CommonJS 還是 ES Module？

如果接入方以SSR的形式在服務端接入組件，可能使用CJS規范。

CSR的情況通常使用ESM。

所以SDK組件在打包編譯時需要輸出ESM、CJS兩種規范的文件。
