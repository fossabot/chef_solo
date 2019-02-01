
# generating attributes from tags
node['tags'].each do |k,v|
  node.default['tiger_perf'][k]=v
end


# Repo with performance settings
case node['tiger_perf']['project_id']

end


