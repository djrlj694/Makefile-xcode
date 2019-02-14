Pod::Spec.new do |spec|
  spec.name = "<PROJECT>"
  spec.version = "1.0.0"
  spec.summary = "Sample framework from blog post, not for real world use."
  spec.homepage = "https://github.com/<GITHUB_USER>/<PROJECT>"
  spec.license = { type: '<LICENSE>', file: 'LICENSE' }
  spec.authors = { "<AUTHOR>" => '<EMAIL>' }
  spec.social_media_url = "http://twitter.com/<TWITTER_USER>"

  spec.platform = :<OS>, "<OS_VERSION>"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/<GITHUB_USER>/<PROJECT>.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "<PROJECT>/**/*.{h,swift}"

  spec.dependency "<DEPENDENCY>", "~> <DEPENDENCY_VERSION>"
end
