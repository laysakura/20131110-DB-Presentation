# Webエンジニアが知っておくべきデータベースの知識(妄想)

2013/11/10

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

- 超ざっくり: DBってどうやって使うの?
  - テーブル, SQL, DBI
- DBの使われどころ
  - 速く, 安全
- インデックス
- トランザクション
- 分散DB触りの触り
  - レプリカありのactive-active
  - failover
- お勉強の手引き

---

## 今日やらない(けど大事な)こと

- クエリ実行計画, クエリ最適化器
- OR-mapper
- KVS (NoSQL)

---

## お勉強

### SQL
- [SQLZOO](http://sqlzoo.net/wiki/Main_Page)
  - 実際に動しつつ，クイズ形式でSQLの練習ができる．超おすすめ．
