
# 実行失敗 (ESのバージョン依存)
# config/elasticsearch.yml に以下を追記する必要あり:
#   script.disable_dynamic: false 
curl -XPOST http://localhost:9200/blog/article/1/_update -d @json/1.9_data.json
