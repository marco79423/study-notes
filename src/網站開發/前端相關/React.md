# React 學習筆記

* 介紹
    * Facebook
    * 單純的 View
* 特色
    * 將 CSS, HTML 的內容全移至 JS 裡，html 變得很單純
    * Immediate-mode GUI
    * JSX
* Retained-mode GUI v.s. Immediate-mode GUI
    * 一般的 GUI 都是 retained mode，畫面上的 GUI 也會保存資料和狀態
    * Immediate-mode GUI 則是將資料和 GUI 獨立開來
    * 前者在元件數量越多時，互動的成本就會越高，但後者不會。
    * 後者的做法意味著任何小變動都得重新 render 整個畫面，會有效能問題
* React 是 Immediate-mode
    * React 會先將元件都 render 成 virtual DOM，它會自己找出有變動的部份，然後只重繪這些變動
    * 既享有immediate-mode的好處，也不用擔心 UI 效能問題 (至少是減少效能問題)
* JSX
    * Facebook
    * A JavaScript syntax extension that looks similar to XML
    * 就是為了偷懶，以上。
    * 一些小細節
        * 內建 tag 小寫，自定義 component 大寫
            ```jsx
                <div>
                    <HelloWorld />
                </div>
            ```
        * Built-in keyword 會改名 (如：class  是 JS 的 keyword，所以改為 className)
            ```jsx
            <div className="haha"></div>
            ```
    * JSX 不能直接上，Browser 看嘸！
        * 需要 tool 將 JSX 轉為普通的 JS
        * 聽到「轉為普通的 JS」，就會想到 Babel !!
* 用 React 會發生什麼事？
    * 會忍不住將 View 拆成一個個 Component
        * 各別的 Component 也會有衝動繼續拆成一個個 Component
        * 「在React的世界中，我們要做的事情只要將畫面切割成各種元件，將元件獨立完成後再組裝。」
    * 拆成多個 Component 後……
        * Component 本身很單純，容易除錯
        * 各別的 Component 容易複用
        * 容易了解應用程式的結構 (理論上大概吧？但……)
    * 也因為很容易重用……
        * 所以有一大堆現成的第三方 components 可以直接使用
            * material-ui

## React 工作流

React 是聲明式 UI 庫，負責將 State 轉換為頁面結構（虛擬 DOM 結構）後，再轉換成真實 DOM 結構，交給瀏覽器渲染。

當 State 發生改變時，React 會先進行調和（Reconciliation）階段，調和階段結束後立刻進入提交（Commit）階段，提交階段結束後，新 State 對應的頁面才被展示出來。

React 的調和階段需要做兩件事。

1. **計算出目標 State 對應的虛擬 DOM 結構。**
2. **尋找「將虛擬 DOM 結構修改為目標虛擬 DOM 結構」的最優更新方案。**

 React 按照深度優先遍歷虛擬 DOM 樹的方式，在一個虛擬 DOM 上完成兩件事的計算後，再計算下一個虛擬 DOM。

第一件事主要是調用類組件的 render 方法或函數組件自身。

第二件事為 React 內部實現的 Diff 算法，Diff 算法會記錄虛擬 DOM 的更新方式（如：Update、Mount、Unmount），為提交階段做准備。

React 的提交階段也需要做兩件事。

1. **將調和階段記錄的更新方案應用到 DOM 中。**
2. **調用暴露給開發者的鉤子方法，如：componentDidUpdate、useLayoutEffect 等。**

 提交階段中這兩件事的執行時機與調和階段不同，在提交階段 React 會先執行 1，等 1 完成後再執行 2。

因此在子組件的 componentDidMount 方法中，可以執行  `document.querySelector('.parentClass')` ，拿到父組件渲染的 `.parentClass` DOM 節點，盡管這時候父組件的 componentDidMount 方法還沒有被執行。useLayoutEffect 的執行時機與 componentDidMount 相同。

[參考來源](https://mp.weixin.qq.com/s/jaWzs2GpPjN6Et6rapMUzA)
