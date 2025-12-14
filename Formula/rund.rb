class Rund < Formula
  version "0.0.12"
  url "https://github.com/darwin-containers/rund/archive/refs/tags/#{version}.zip"
  sha256 "a7d331cfc001b2f7e7e914a376b985c5a25b2a7aeedeb4d76d1789e4051ff937"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
