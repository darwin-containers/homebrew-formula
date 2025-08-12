class Rund < Formula
  version "0.0.11"
  url "https://github.com/darwin-containers/rund/archive/refs/tags/#{version}.zip"
  sha256 "5f8e42c17e1c5061a5b13377ca9542bdc1a2da08934521ad54ce3e28222524fa"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
