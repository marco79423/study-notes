# Python 學習筆記

## Python 的屬性

已整理為文章： https://marco79423.net/articles/%E6%B7%BA%E8%AB%87-python-%E7%9A%84%E5%B1%AC%E6%80%A7/

## Python 的排序

已整理為文章： https://marco79423.net/articles/%E6%B7%BA%E8%AB%87-python-%E7%9A%84%E6%8E%92%E5%BA%8F/

## 工具庫

* [Textual](https://github.com/willmcgugan/textual)
    * Textual 是 Python 知名終端美化項目 Rich 的作者開發的終端框架，它由 async 提供支持，並從 Web 開發中借用了許多技術。
* [absurd-sql](https://github.com/jlongster/absurd-sql)
    * 一個 sql.js 的後端實現（sql.js 是 sqlite 的 Webassembly 版）將 IndexedDB 當作磁盤，並以塊存儲形式將數據存儲在 IndexDB 中
* [rembg](https://github.com/danielgatis/rembg)
    * 簡單實用的刪除圖像背景/摳圖工具

## 本地下載套件

### 在指定資料夾下載

```shell
# 1. 首先將所需的套件下載到指定資料夾 (假設透過 requirements.txt)
pip install -r requirements.txt -d 指定資料夾

# 2. 指定資料夾安裝套件 (--find-links -f 指定 local 的資料夾)
pip install 套件 -find-links -f 指定 local 的資料夾
```

加上 --no-index 會直接採用 --find-links 指定的資料夾

### 自己架自己的 pypi server

```shell
# 使用 pypiservercd
pip install pypiserver

# 下載套件的方式
 pip install -d 指定資料夾 套件
 
# 設定進入點

```python
import pypiserver
application = pypiserver.app('指定資料夾')
```

## Django

### 壓縮 JS 和 CSS

assets

Django compressor

[http://django-compressor.readthedocs.org/en/latest/](http://django-compressor.readthedocs.org/en/latest/)

安裝

```shell
pip install django_compressor
```

設定

```python
INSTALLED_APPS = (
    "compressor",

    # other apps    
)


STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder', 
    'compressor.finders.CompressorFinder',

    # other finders..
)
    
```

如果沒有設定 STATIC_ROOT 時，就要指定 COMPRESS_ROOT

與 settings 的 DEBUG 連動，當 DEBUG=False 就會開啟壓縮，也可以直接指定 COMPRESS_ENABLED = True

使用範例

```html
{% load compress %}

{% compress css %}
<link rel="stylesheet" href="/static/css/one.css" type="text/css" charset="utf-8">
<style type="text/css">
    p { border:5px solid green;}
</style>
<link rel="stylesheet" href="/static/css/two.css" type="text/css" charset="utf-8">
{% endcompress %}

{% load compress %}
{% compress js %}
<script src="/static/js/one.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">obj.value = "value";</script>
{% endcompress %}
```
