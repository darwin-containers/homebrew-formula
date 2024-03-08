class Rund < Formula
  version "0.0.8"
  url "https://github.com/macOScontainers/rund/archive/refs/tags/#{version}.zip"
  sha256 "05c5d7d7e5627c34b0344704c8a8695c8a728667a047f96f157482d8844c1131"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
