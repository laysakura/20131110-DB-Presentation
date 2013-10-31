# Webエンジニアが知っておくべきデータベースの知識(妄想)

2013/11/10 @ 内定者勉強会

---

## 前置き

- Webエンジニアじゃないけど，Webエンジニアが知っておいたほうが良さそうな知識を妄想してまとめました
- 「これだけ分かってれば大丈夫」**ではないです**
  - 自分のPCの上でコリコリ動くDBの気持ちは分かるようになると思います
  - 本当はネットワーク越しにガリガリ動くDBの気持ちが分からなくちゃいけません
  - 最後の方に今後の勉強の指針なども書きました

---

## 自己紹介

- 中谷 翔 (laysakura)
- 東大情報理工M2: (分散DB,ストリーム処理)
- [Twitter](https://twitter.com/laysakura)
- [Github](https://github.com/laysakura)
- [blog: 俺とお前とlaysakura](http://laysakura.hateblo.jp)
- 日本地ビール協会公認 **ビアテイスター**

---

## 最近の活動

- IPA未踏: High Performance SQLite の開発
- 長期インターン: [MySQLite](https://github.com/laysakura/MySQLite-Storage-Engine) (MySQLストレージエンジン) 開発
  - MySQLからSQLiteのDBファイルを，SQLiteよりも高速にアクセス(開発継続中)
- PyPIモジュール: [nextversion](https://pypi.python.org/pypi/nextversion)
  - 次のバージョン番号を出す (1.0.2 -> 1.0.3)
- CPANモジュール: [Search::Fulltext](http://search.cpan.org/~laysakura/Search-Fulltext/lib/Search/Fulltext.pm), [Search::Fulltext::Tokenizer::MeCab](http://search.cpan.org/~laysakura/Search-Fulltext-Tokenizer-MeCab/lib/Search/Fulltext/Tokenizer/MeCab.pm)
  - らくちん日本語全文検索
  - [ブログ記事](http://laysakura.hateblo.jp/entry/20131011/1381477266)が177ブクマ(2013/10/30), はてなブログ人気エントリー入り(嬉しい)

---

## 今日やること

- SQL
- インデックス
- トランザクション
- 分散環境でのDB活用(触り)

---

# 導入

---

## DB(子供)からRDBMS(大人)へ

- よくDBって言われるものの正式名称: RDBMS (**Relational** Database Management Systems)
  - テーブル = リレーション
  - SQL = 関係代数演算の記述法のひとつ
  - 関係代数 = リレーションを扱う理論
- とにかく: SQL使って表を書くやつはRDBMSって呼びます!

---

## RDBMSの嬉しさ

- でかい，楽，速い，安心
  - メモリはみ出すサイズのデータ扱える
  - SQLでらくちんデータ検索
  - インデックスで高速データアクセス
  - トランザクションで大事なデータを保護
- 今日は主にこの4拍子を，割と硬派に紹介します

---

## 今日やらなかった(けど大事な)こと

今後の勉強の指針にしてください(優先度順)

- DBD, JDBC, (他の言語も大体同じ)
  - プレースホルダ
- 発展的なインデックス
  - マルチカラム
  - クラスタインデックス
  - ハッシュインデックス
- クエリ実行計画, クエリ最適化器
- テーブル設計
  - 正規化，非正規化
- OR-mapper(プラグインは?)
- column-oriented
- KVS (NoSQL)
  - redis, mongo
- 分散
  - 分散ネイティブなRDBMS
    - MySQL Cluster
    - Oracle, DB2, ... などの商用DB

---

## お勉強

### SQL
- [SQLZOO](http://sqlzoo.net/wiki/Main_Page)
  - 実際に動しつつ，クイズ形式でSQLの練習ができる．超おすすめ．


### 書籍

読んだことがある者だけ紹介

- Database Management Systems 3rd ed.
- Webエンジニアのためのデータベース技術[実践]入門
- SQLアンチパターン
