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
  - **SQL**でらくちんデータ検索
  - **インデックス**で高速データアクセス
  - **トランザクション**で大事なデータを保護
- (個人的には) SQL, インデックス, トランザクションを使いこなせて初めて「DB触れます〜」って言える (と思う)

---

# SQL

要点: 基本の5操作覚えれば大体書けるようになる

---

## 目標: このくらいのクエリはさらっと(書き|読み)たい

```sql
-- TPC-H Query#10
select
	c_custkey, c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal, n_name, c_address, c_phone, c_comment
from
	customer, orders, lineitem, nation
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= date ':1'
	and o_orderdate < date ':1' + interval '3' month
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey, c_name, c_acctbal, c_phone, n_name, c_address, c_comment
order by
	revenue desc;
```

**関係代数基本の5操作**の組み合わせでしかない

---

## 関係代数基本の5操作

| 名前        | 意味       | SQL                               |
|-------------|------------|-----------------------------------|
| selection   | 行絞り込み | WHERE                             |
| projection  | 列絞り込み | (カラム名指定)                    |
| sort        | ソート     | ORDER BY                          |
| aggregation | 集約       | GROUP BY, count(\*), avg(\*), ... |
| join        | 結合       | JOIN, WHERE条件                   |

---

## selection - 行絞り込み

| id | name | age |
|----|------|-----|
|  1 | 仁志 |  25 |
|  2 | 清水 |  18 |
|  3 | 高橋 |  31 |
|  4 | 松井 |  33 |
|  5 | 清原 |  22 |
|  6 | 江藤 |  21 |
|  7 | 二岡 |  19 |
|  8 | 村田 |  63 |
|  9 | 上原 |  28 |

```sql
select * from Giants where id >= 3 and id <= 5;  -- 往年のクリーンナップ・・・
```


## selection - 行絞り込み

| id | name | age |
|----|------|-----|
|  3 | 高橋 |  31 |
|  4 | 松井 |  33 |
|  5 | 清原 |  22 |

```sql
select * from Giants where id >= 3 and id <= 5;  -- 往年のクリーンナップ・・・
```

---

## projection - 列絞り込み

| id | name | age |
|----|------|-----|
|  1 | 仁志 |  25 |
|  2 | 清水 |  18 |
|  3 | 高橋 |  31 |
|  4 | 松井 |  33 |
|  5 | 清原 |  22 |
|  6 | 江藤 |  21 |
|  7 | 二岡 |  19 |
|  8 | 村田 |  63 |
|  9 | 上原 |  28 |

```sql
select name from Giants;  -- 名前だけとる
```


## projection - 列絞り込み

| name |
|------|
| 仁志 |
| 清水 |
| 高橋 |
| 松井 |
| 清原 |
| 江藤 |
| 二岡 |
| 村田 |
| 上原 |

```sql
select name from Giants;  -- 名前だけとる
```

---

## sort - ソート

| id | name | age |
|----|------|-----|
|  1 | 仁志 |  25 |
|  2 | 清水 |  18 |
|  3 | 高橋 |  31 |
|  4 | 松井 |  33 |
|  5 | 清原 |  22 |
|  6 | 江藤 |  21 |
|  7 | 二岡 |  19 |
|  8 | 村田 |  63 |
|  9 | 上原 |  28 |

```sql
select * from Giants order by age;  -- 年齢でソート
```


## sort - ソート

| id | name | age |
|----|------|-----|
|  2 | 清水 |  18 |
|  7 | 二岡 |  19 |
|  6 | 江藤 |  21 |
|  5 | 清原 |  22 |
|  1 | 仁志 |  25 |
|  9 | 上原 |  28 |
|  3 | 高橋 |  31 |
|  4 | 松井 |  33 |
|  8 | 村田 |  63 |

```sql
select * from Giants order by age;  -- 年齢でソート
```

---

## aggregation - 集約関数

| id | name | age |
|----|------|-----|
|  1 | 仁志 |  25 |
|  2 | 清水 |  18 |
|  3 | 高橋 |  31 |
|  4 | 松井 |  33 |
|  5 | 清原 |  22 |
|  6 | 江藤 |  21 |
|  7 | 二岡 |  19 |
|  8 | 村田 |  63 |
|  9 | 上原 |  28 |

```sql
select avg(age) from Giants;  -- 平均年齢
```


## aggregation - 集約関数

```sql
select avg(age) from Giants;  -- 平均年齢
```

| avg(age)    |
|-------------|
|       28.88 |

---

## aggregation - グループ集約

```sql
select unit, avg(age) from Member group by unit;  -- ユニットごとの平均年齢
```

| id | name   | unit | age |
|----|--------|------|-----|
|  1 | まゆゆ | AKB  |  23 |
|  2 | 松井   | SKE  |  18 |
|  3 | 前田   | AKB  |  27 |


## aggregation - グループ集約

```sql
select unit, avg(age) from Member group by unit;  -- ユニットごとの平均年齢
```

| unit | age |
|------|-----|
| AKB  |  25 |
| SKE  |  18 |

---

## join - 結合

```sql
select Member.name, Fan.name, Fan.age from Member, Fan
where Fan.oshimen = Member.name; -- 各メンバーは誰に愛されているか
```

*Member*

| id | name   | unit | age |
|----|--------|------|-----|
|  1 | まゆゆ | AKB  |  23 |
|  2 | 松井   | SKE  |  18 |
|  3 | 前田   | AKB  |  27 |

*Fan*

| id | name      | oshimen |
|----|-----------|---------|
|  1 | ブヒブヒ1 | 松井    |
|  2 | ブヒブヒ2 | まゆゆ  |
|  3 | ブヒブヒ3 | 松井    |


## join - 結合

```sql
select Member.name, Fan.name, Fan.age from Member, Fan
where Fan.oshimen = Member.name; -- 各メンバーは誰に愛されているか
```

*結果*

| Member.name | Fan.name  | Fan.age |
|-------------|-----------|---------|
| 松井        | ブヒブヒ1 |      25 |
| 松井        | ブヒブヒ3 |      22 |
| まゆゆ      | ブヒブヒ2 |      38 |

---

## 再掲: TPC-Hクエリ

selection, projection, sort, aggregation, join はどこかな?

```sql
-- TPC-H Query#10
select
	c_custkey, c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal, n_name, c_address, c_phone, c_comment
from
	customer, orders, lineitem, nation
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= date ':1'
	and o_orderdate < date ':1' + interval '3' month
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey, c_name, c_acctbal, c_phone, n_name, c_address, c_comment
order by
	revenue desc;
```

---

## 自分でSQL書けるようになろう

- [SQLZOO](http://sqlzoo.net/wiki/Main_Page)
  - クイズ形式でSQLの練習ができる．超おすすめ
  - 「欲しい結果を得るためのクエリ」は書けるようになる
  - でも，**速いクエリ**を書けるようなるのは別の話

---

## 遅いクエリ=クソクエリ
- 結果が出れば良いってもんじゃない
  - クソクエリcommitする奴=サービス運用の敵=火炙り
- どうすれば速いクエリ書けるようになる??
  - (色々大事だけど)まずは**インデックス**を使いこなそう

---

# インデックス

要約: インデックスのデータ構造と使われどころを抑えよう

---

## インデックスの恩恵

```sql
-- ゲームユーザの情報テーブル作成
create table User (
  user_id INTEGER PRIMARY KEY AUTO_INCREMENT,
  name    VARCHAR(64),
  score   INTEGER
);

-- ユーザがどんどん追加される
insert into User values ('たかし', 300);
insert into User values ('みか',   500);
...
select count(*) from User;  -- => 100万行
```

やりたい処理: scoreが高いユーザを列挙する


## インデックスの恩恵

```sql
-- インデックスなし
select id from User where score > 10000;  -- => 10秒

-- インデックスあり
create index score_idx on User(score);
select id from User where score > 10000;  -- => 1秒
```

- インデックスの有無だけで，クエリ時間がオーダ単位で変わるのもザラ
- WHY??

---

## インデックスの考え方の '基本'

インデックスを貼る = ソート済みの 'リスト' を作る

```python
# インデックスなし:
# scoreが10000より大きい要素を探す => 全探索 O(n)
scores = [300, 500, 200, 15000, 15, ..., 20000, 10, ...]

# インデックスあり = ソート済みのリスト:
# scoreが10000より大きい要素を探す => 二分探索 O(log n)
scores = [10, 15, 200, 300, 500, ..., 15000, 20000, ...]
```


## 老婆心

- 万が一 *O(log n)* とかの話がわからない場合
  - 今すぐアルゴリズムとデータ構造を勉強しましょう
  - 最低限を知らないで「アプリ作れればいいや」だけでは・・・

---

## インデックスのデータ構造

- 「カラムXにインデックス貼ると，カラムXのソート済みリストができるんだ!!」
  - 惜しいけど違う
  - 'リスト' 構造はオンメモリなら十分高速
  - しかし，テーブルがメモリをはみ出すくらいでかいと，インデックスもオンメモリじゃ済まない

- ディスクに置く & 「ソート済み」なデータ構造 => **B+Tree**

---

## メモリとディスクで何が違う??

*(ディスク ≒ ハードディスクの話)*

なぜリスト構造はディスクに置かれるとそのまま使えないのか?

- リストの各要素は飛び飛びのメモリ番地に配置されている
  - リスト要素を読む => 飛び飛びアクセス = **ランダムアクセス**

- ディスクはランダムアクセスめっちゃ遅い(HDDの物理的構造の話)

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

## 今日のインプット -> アウトプット例

- (ある程度)複雑なSQLが書けるようになる
  - 例: `$dbh->do()` 3回で得ていた結果が1回で得られるように
  - DBにやれることはDBにやらせたほうが大抵速い

---

## 今日のインプット -> アウトプット例

- 適切にインデックスを貼れるようになる
  - 貼りすぎず，貼らなすぎず
  - ヒント: `EXPLAIN` コマンド
    - [漢(オトコ)のコンピュータ道: MySQLのEXPLAINを徹底解説!!](http://nippondanji.blogspot.jp/2009/03/mysqlexplain.html)

---

## 今日のインプット -> アウトプット例

- 使うべきところでトランザクションが使えるようになる
  - 例1: ユーザの登録を，`User` テーブルと `Service.num_users` カラムに同時に反映させる(整合性のためのトランザクション)
  - 例2: 大量の`insert`の前後で一つの大きなトランザクション(速さのためのトランザクション)
    - (この場合はbulk insertの方がよかったりするかも)

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
