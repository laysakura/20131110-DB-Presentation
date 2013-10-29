# Webエンジニアが知っておくべきデータベースの知識(妄想)

某勉強会の資料です．
http://laysakura.github.io/20131110-DB-Presentation
でスライドが見れます．

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
