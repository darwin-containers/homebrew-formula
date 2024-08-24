class Rund < Formula
  version "0.0.9"
  url "https://github.com/darwin-containers/rund/archive/refs/tags/#{version}.zip"
  sha256 "151e6d459241dd4a9301eaa202dab8a115fdbaea61868e9cf78e11056f2e79d3"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
