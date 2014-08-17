curl -XPUT 'http://localhost:9200/library'
curl -XPUT 'http://localhost:9200/library/book/_mapping' -d @json/2.2_mapping.json
