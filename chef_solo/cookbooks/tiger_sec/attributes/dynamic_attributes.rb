
# generating attributes from tags
node['tags'].each do |k,v|
  node.default['tiger_sec'][k]=v
end
