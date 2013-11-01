# Webエンジニアが知っておくべきデータベースの知識(妄想)

某勉強会の資料です．
http://laysakura.github.io/20131110-DB-Presentation
でスライドが見れます．

## 話す内容

### 導入

- DB -> RDBMS

- RDBMSの嬉しさ
  - でかい，楽，速い，安心
  - diskに置けるサイズ
  - SQL
  - 検索がlog n
  - トランザクショナル

### SQL

- 5つの基本操作
  - selection, projection, sort, aggregation, join
- 組み合わせると何ができる?
  - TPC-Hのでも見せる
- できるようになろう -> SQLZOO
- クソクエリを書いた末路
  - ...
  - 良クエリ: 速い!!!!
  - 速さのための第一歩 -> インデックス

### インデックス

- レンジクエリでフルスキャンやって遅いよって話
  - index使うと，確かに速いよねってのをDDLも見せつつ実感してもらう
  - なんで速い?
- テーブルのデータ構造: B-tree
  -

- B-tree vs B+tree
  - B-tree: 中間ノードにもレコード持てる -> 容量削減
  - B+tree: ????

- なんで線形リストじゃだめなの? (この話はしないかも)
  - [ (index key, RID), ... ] って構造でも，論理的にはいける
  - でも，ディスクブロックごとに格納するってなると，結局は木構造になる(?)
    - 線形リストの場合，本当に気の深さ分くらいに抑えられるのか

- selectionだけじゃなく，sort, aggr, joinもインデックスを使う

- インデックス貼ろう!
  - ただし，貼り過ぎに注意
  - 貼り過ぎの弊害
    - insert速度劣化
    - サイズ肥大化

### トランザクション

- トランザクショナルな処理とは?
  - 銀行口座の話
    - 実際に銀行口座テーブルを作って，moneyカラムのロックが必要なことを示す

- トランザクションを実感
  - 片方シェルでreadトランザクションを出している時に，insertが実行できないことを見せる

- いつもは自動でトランザクションが掛かってる
  - でも，行ごとなので遅い (TIPSとしてinsert大量なときはまとめたほうが速いことを見せる)

- RDBMSでは勝手にトランザクション掛けてくれるから安心
  - でも，トランザクション毎回だと遅いことがあるから，意識的に大きなトランザクションにすることも大事

### 分散環境触りの触り

- レプリケーション

- パーティション(シャーディング?)
  - 予めノードを分けとく，インデクシングの一種



## reveal.jsを使ったスライドの作り方(備忘録)

### ディレクトリ構成

```bash
$ git ls-files
.gitignore
Gruntfile.js    # reloadのために独自編集済み
README.md
css/reveal.min.css
css/theme/default.css
index.html
js/reveal.min.js
lib/css/zenburn.css
lib/js/classList.js
lib/js/head.min.js
lib/js/html5shiv.js
package.json
plugin/highlight/highlight.js
plugin/markdown/markdown.js
plugin/markdown/marked.js
plugin/notes/notes.js
plugin/zoom-js/zoom.js
slides.md
```

### 弄るファイル

<dl>
  <dt>index.html</dt>
  <dd>header, CSS, JSの指定</dd>

  <dt>slides.md</dt>
  <dd>スライドの中身</dd>

  <dt>README.md</dt>
  <dd>何のスライドか説明</dd>
</dl>

### WYSIWYGでslides.mdを弄る

```bash
$ npm install
$ grunt serve
$ browser localhost:8000  # Chrome拡張のLiveReloadを有効にすると，ファイル編集毎に勝手にreloadされて便利
```

### Githubにスライドをうpして見れるように

```bash
$ hub create -d '説明'
$ git checkout -b gh-pages
$ git push origin gh-pages
$ browser http://laysakura.github.io/github_project_name/  # ただし初回は反映に10分程度
```
