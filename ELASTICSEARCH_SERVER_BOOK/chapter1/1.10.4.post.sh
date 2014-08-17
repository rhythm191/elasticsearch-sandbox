
# {"error":"MapperParsingException[mapping [post]]; nested: IllegalArgumentException[precisionStep must be >= 1 (got 0)]; ","status":400}
# changed precision_step: 0 -> 1
curl -XPOST 'http://localhost:9200/posts' -d @json/1.10.4.posts.json
