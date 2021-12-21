# Docker 相關

## 基礎概念

Docker技術的三大核心概念，分別是：

* 鏡像（Image）
* 容器（Container）
* 倉庫（Repository）

## 基本操作


## 實用命令
    * 刪除所有 docker container 和 images
        * 法一
            ```bash
            docker stop $(docker ps -a -q)  # 關閉所有 Docker Container
            docker rm $(docker ps -a -q)    # 刪除所有 Docker Container
            docker rmi $(docker images -q)  # 刪除所有 Docker Image
            ```
        * 法二
            ```bash
            docker system prune -a --volumes
            ```
