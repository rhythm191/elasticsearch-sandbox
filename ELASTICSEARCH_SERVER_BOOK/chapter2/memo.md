
## Queryのエンドポイントは5種類

1. Index + Type
curl -XGET 'localhost:9200/library/book/_search' -d @query.json 

2. Index Only
curl -XGET 'localhost:9200/library/_search' -d @query.json 

3. All indexes
curl -XGET 'localhost:9200/_search' -d @query.json 

4. Multi indexes
curl -XGET 'localhost:9200/library,bookstore/_search' -d @query.json 

5. Multi indexes and Multi types
curl -XGET 'localhost:9200/library,bookstore/book,recipe/_search' -d @query.json 

## ページング

from, sizeプロパティを定義する必要あり
  from: 検索結果の開始位置を指定 (default: 0)
  size: 1回のクエリの結果リターン最大数(default: 10)

## バージョン

queryにversion: trueを付与する必要あり

## スコアによる制限

min_score: 属性を定義して絞り込める.
? scoreの信ぴょう性がきになる.

## 取得するフィールドの指定

fields 属性で配列で定義.指定したFieldのみ表示する.

## script フィールドの使用

```
"script_field": {
 "customField": {
   "script": "_fields['year'].value - 1800"
 }
}
```

といった形で、クエリ結果に対して加工することができる.
別の書き方も可能.パラメータの使用

```
"script_field": {
 "customField": {
   "script": "_source.year - paramYear"
 }
 "params": { "paramsYear": 1800 }
}
```

----
基本的なクエリ

* 2.4.1　termクエリ
  * 指定フィールドにその語句をもっているすべてのドキュメントにマッチ.
  * 部分一致検索 (like *word*)

```
{
  "query": {
    "term" { "title": "crime" }
  }
}
```


* 2.4.2　termsクエリ
  * 複数キーワードを含むか検索できる(含むキーワードの最低数を指定可能)
```
{
  "query": {
    "terms": {
         "tags" : ["novel", "book"],
         "minimum_match": 1
         }
  }
}
```


* 2.4.3　matchクエリ
  * terms/minimum_match=1とほぼ同じ.crimeかandかpunishmentを持っているすべてのドキュメントにマッチする
```
{
  "query": {
    "match": {
      "title": "crime and punishment" 
    }
  }
}
```

boolean match  
and検索も可能.defaultはor検索
```
{
  "query": {
    "match": {
      "title": {
        "query": "crime and punishment",
        "operator": "and"
      }
    }
  }
}
```

phrase match  ??
slop: フレーズとして指定されたテキストにある語句と語句の間の未知の単語を何単語とするか

```
{
  "query": {
    "match": {
      "title": {
        "query": "crime and punishment",
        "slop": 1
        "max_expansions": 20
      }
    }
  }
}
```



match phrase prefix  ??
max_expansions: 最後の語句を前方一致させていくつの語句を書き換えるかという制御ができます

* 2.4.4　multi matchクエリ
  * matchクエリとほぼ同じだが、複数フィールドを対象に検索することができる.
```
{
  "query": {
    "multi_match": {
      "query": "crime and punishment",
      "fields" : ["title", "otitle"]
    }
  }
}
```

* 2.4.5　query stringクエリ
  * Apache Luceneのクエリシンタックスをすべてサポート
  * Luceneを勉強すればわかる？？
```
{
  "query": {
    "query_string": {
      "query": "title:crime^10 +title:punishment -otitle:cat +author:(+Fyodor +dostoevsky)",
      "default_fields" : "title"
    }
  }
}
```


* 2.4.6　fieldクエリ
  * query stringの簡易版
```
{
  "query": {
    "field": {
      "title": "+crime nothing -let"
    }
  }
}
```
上記クエリは、titleフィールドに対して、crimeは必ず含み、nothingは任意、letという語句を含むドキュメントを除いた結果を返す

query string クエリに適用できるすべてのプロパティが利用できる
(じゃあなぜ？query stringがあるのか？もっと複雑なクエリが発行できるのが強み？)


* 2.4.7　IDsクエリ
指定した識別子を対象に検索. 内部の_uidフィールドをみる.
```
{
  "query": {
    "ids": {
      "values": "["10", "11", "12", "13"]"
    }
  }
}
```
hash値もあるので、文字列になっている.
typeも指定できる.(idまで絞れているのに、typeを指定する必要があるか？利用ケースは少なそう)
```
{
  "query": {
    "ids": {
      "type": "book",
      "values": "["10", "11", "12", "13"]"
    }
  }
}
```

* 2.4.8　prefixクエリ
  * 接頭辞で始まる持つドキュメントを探せる.
```
{
  "query": {
    "prefix": {
      "title": "cri"
    }
  }
}
```

先頭にcriがついた単語が含まれるものを返す.
boost値が指定できる？(効果が不明)

* 2.4.9　fuzzy like thisクエリ
  * 似ているドキュメントをさがせる

```
{
  "query": {
    "fuzzy_like_this": {
      "fields": ["title", "otitle"],
      "like_text": "crime punishment"
    }
  }
}
```
crime punishment に似ているテキストを含むドキュメントを探してくれる

パラメータ:  
* fields: 指定しないと_all
* like_text: 必須
* ignore_tf : term frequenciesを無視するかどうか (default: false)
* maxquery_terms: 生成されたクエリに含まれるクエリ語句の最大数を指定(default: 25)
* min_similarity: 最小の類似度 (default: 0.5)
* ?prefix_length: 異なる語句の共通接頭辞の長さを指定 (default: 0)
* ?boost: クエリをブーストする時に指定 (default: 1)
* analyzer: 利用するアナライザを指定

* 2.4.10　fuzzy like this fieldクエリ

fieldを指定したfuzzy like thisクエリ
```
{
  "query": {
    "fuzzy_like_this_field": {
      "title": {
        "like_text": "crime punishment"
      }
  }
}
```



* 2.4.11　fuzzyクエリ
  * 与えた語句に基づいて計算された編集距離を元にマッチしたドキュメントをさがす
  * cpu負荷が高い
```
{
  "query": {
    "fuzzy": {
      "title": "crime"
    }
  }
}
```

パラメーター:  
value
boost
min_similarity? 説明に矛盾箇所あり.
prefix_length
max_expansions

* 2.4.12　match allクエリ
  * 全ドキュメントにマッチするクエリ

```
{
  "query": {
    "match_all": {}
  }
}
```
? あるフィールドに対してブーストを利用できる


* 2.4.13　wildcardクエリ
  * wildcard , "*" , "?" を利用できる
  * 性能が非常に悪いらしい
```
{
  "query": {
    "wildcard": {
     "title": "cr?me"
    }
  }
}
```

* \*: 任意の文字(0文字以上)
* ?: 任意の1文字


* 2.4.14　more like thisクエリ
  * 似ているドキュメントを取得する
  * fuzzy like thisクエリと何が違うか?
    * fuzzy like thisクエリは提示された単語と最も異なる単語を選択する

```
{
  "query": {
    "more_like_this": {
      "fields": ["title", "otitle"],
      "like_text": "crime punishment",
      "min_term_freq": 1,
      "min_doc_freq": 1
  }
}
```


* 2.4.15　more like this fieldクエリ
  * more like thisクエリを単一フィールドに適用する時に用いる
```
{
  "query": {
    "more_like_this_field": {
      "title": {
        "like_text": "crime punishment",
        "min_term_freq": 1,
        "min_doc_freq": 1
      }
  }
}
```

* 2.4.16　rangeクエリ
  * 範囲検索, 数値フィールドだけじゃなく、文字列ベースのフィールドにも可能

from: 下限値 (default: 最初の値)
to: 上限値 (default: ∞)
include_lower: 下限を含むかどうか (default: true, 含む)
include_upper: 上限を含むかどうか (default: true, 含む)

```
{
  "query": {
    "range": {
      "year": {
        "from": 1700,
        "to": 1900
      }
  }
}
```
yearフィールドに対して1700<=year<=1900のドキュメントを返す
?文字列の場合は辞書順なのか？

2013年11月現在では推奨パラメータが変更になった
```
{
  "query": {
    "range": {
      "year": {
        "gte": 1700,
        "lte": 1900
      }
  }
}
```
使用可能パラメーター:  
gte(greater than equal), gt, lte, lt, boost




* 2.4.17　クエリの書き換え


