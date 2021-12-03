# Git 學習筆記

## Commit message

    Header: <type>(<scope>): <subject>
    Body: 72-character wrapped. This should answer:
    Footer: 

* Header
    * type
        * 類別：feat, fix, docs, style, refactor, test, chore。
            * feat: 新增/修改功能 (feature)。
            * fix: 修補 bug (bug fix)。
            * docs: 文件 (documentation)。
            * style: 格式 (不影響程式碼運行的變動 white-space, formatting, missing semi colons, etc)。
            * refactor: 重構 (既不是新增功能，也不是修補 bug 的程式碼變動)。
            * perf: 改善效能 (A code change that improves performance)。
            * test: 增加測試 (when adding missing tests)。
            * chore: 建構程序或輔助工具的變動 (maintain)。
            * revert: 撤銷回覆先前的 commit 例如：revert: type(scope): subject (回覆版本：xxxx)。

    * scope (可選)
        * commit 影響的範圍，例如資料庫、控制層、模板層等等，視專案不同而不同。
    * subject
        * commit 的簡短描述，不要超過 50 個字元，結尾不要加句號。
* Body
    * 本次 Commit 的詳細描述，可以分成多行，每一行不要超過 72 個字元。
    * 說明程式碼變動的項目與原因，還有與先前行為的對比。
* Fooder
    * 填寫任務編號（如果有的話）.
    * BREAKING CHANGE（可忽略），記錄不兼容的變動，以 BREAKING CHANGE: 開頭，後面是對變動的描述、以及變動原因和遷移方法。

## 減少 git 佔用空間的方法

1. 透過 rebase 清理不必要的 branch
2. 先查找大文件：
    ```bash
    git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"
    ```
3. 例如刪除 nspatientList1.txt 文件：
    ```bash
    git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch bin/nspatientList1.txt' --prune-empty --tag-name-filter cat -- --s
    ```
4. 刪除之後會有大量輸出，顯示已經從各自歷史log中剔除掉關於這個大文件的信息，之後可以使用gc命令再次壓縮:
    ```bash
    git gc  --prune=now
    ```
5. 然後再進行提交即可。
