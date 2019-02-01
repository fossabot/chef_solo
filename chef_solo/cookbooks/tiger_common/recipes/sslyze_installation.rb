[
  "pip install --upgrade pip",
  "pip install --upgrade setuptools",
  "pip install sslyze==#{node['tiger_common']['sslyze_version']}"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd # nassl"
    retries 3
  end
end

