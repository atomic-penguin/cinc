name "cinc-foundation"
license "Apache-2.0"
license_file "LICENSE"

# Grab accompanying notice file.
# So that Open4/deep_merge/diff-lcs disclaimers are present in Omnibus LICENSES tree.
license_file "NOTICE"

skip_transitive_dependency_licensing true

if windows?
  source path: "c:/cinc-project/cinc"
else
  source path: "/opt/cinc"
end

relative_path "cinc-foundation"

build do
  sync "#{project_dir}", "#{install_dir}"
end
