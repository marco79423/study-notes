# Git 學習筆記

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
