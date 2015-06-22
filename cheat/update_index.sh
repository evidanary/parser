ruby run.rb --filein ./files/subset.raw --fileout ./files/subset.json
curl 'http://localhost:8983/solr/csv/update?stream.body=<delete><query>*:*</query></delete>'
curl 'http://localhost:8983/solr/csv/update?stream.body=<commit/>'
curl 'http://localhost:8983/solr/csv/update/json?commit=true' --data-binary @files/subset.json -H 'Content-type:application/json'
