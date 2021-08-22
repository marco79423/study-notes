# TypeScript 學習筆記

## TSConfig 設定檔的用法

可以參考： https://www.typescriptlang.org/zh/tsconfig

參考設定：

```json=
// tsconfig.json 支援加註解 (https://github.com/microsoft/TypeScript/issues/4987)
{
  "compilerOptions": {
    // 編譯目標
    "target": "es6",           // 當前瀏覽器應該都支援到 ES6 (以後可能會變)
    "module": "commonjs",      // 輸出的模組形式

    // 輸入輸出
    "rootDir": "src",          // TS 所有要編譯的原始碼都必須要在 rootDir 目錄內
    "outDir": "dist",          // TS 只會在 outDir 目錄內輸出檔案

    // .d.ts 相關
    "declaration": true,       // 是否產生 .d.ts
    "declarationDir": "dist",  // 生成的 .d.ts 的目標目錄

    // source map 相關
    "sourceMap": true,
    "declarationMap": true,    // 產生 sourcemap 可以直接導到原始的 TS 原始碼而不是 .d.ts

    // JS 支援相關
    "allowJs": true,  // 允許使用 JavaScript，而不僅是 .ts 或 .tsx
    // "checkJs": true,  // 一樣對 js 使用 @ts-check 檢查

    // jsx 相關 (針對 .tsx)
    "jsx": "react-jsx",            // 針對 jsx 語法做的處理

    // CommonJS / AMD / UMD 交互相關
    "esModuleInterop": true,               // 處理 CommonJS / AMD / UMD 之間的交互 (比如說將後者當成 true 處理)
    "allowSyntheticDefaultImports": true,  // 允許合成默認導入，可以用 import React from 'react'，而非 import * as React from 'react

    // 其他
    "importHelpers": true                  // 透過引入 tslib 的 helper 函式減少產生的程式碼
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "src/**/*.stories.js",
    "src/**/*.test.js",
  ]
}

```
