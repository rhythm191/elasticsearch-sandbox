
# $B<B9T<:GT(B (ES$B$N%P!<%8%g%s0MB8(B)
# config/elasticsearch.yml $B$K0J2<$rDI5-$9$kI,MW$"$j(B:
#   script.disable_dynamic: false 
curl -XPOST http://localhost:9200/blog/article/1/_update -d @json/1.9_data.json
