# http://dev.mikamai.com/post/77171462056/easy-full-text-search-with-postgresql-and-rails
PgSearch.multisearch_options = {
  using: {
    tsearch:    {dictionary: 'english'},
    trigram:    {threshold:  0.1},
    dmetaphone: {}
  }
}