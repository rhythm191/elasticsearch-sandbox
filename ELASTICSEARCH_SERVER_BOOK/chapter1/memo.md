## フィールド (field)
  propertiesで定義

## 基本型 (Core types)

* String
* Number
* Date
* BOolean
* Binary

### 共通の属性

* index_name: indexに格納されるフィールド名, properties:{} 内で定義するkeyに該当
* index: 検索対象とするか否かの設定.String型はnot_analyzedを設定可能. (analyzed: 検索可能, no: 検索不可能, not_analyzed: 完全一致のみ検索可能)
* store: 元の値を保存するか否かの設定. yes/noの設定ができる.(default: no), noの場合検索結果にfieldの値が含まれない.ただし、以下の2パターンに該当すれば検索結果に含まれる.
  * index対象のフィールドになっている
  * sourceフィールドを利用している
* boost: フィールドがドキュメントの中の重要度 (default: 1), 値が大きいほど重要という意味.
* null_value: ドキュメント登録時にこのフィールドを持っていない場合に格納して欲しい値を定義(デフォルトは無視する)
* include_in_all: _allフィールドに含まれるかの設定.(_allフィールドを使う場合defaultでは全てのフィールドが含まれる.)


