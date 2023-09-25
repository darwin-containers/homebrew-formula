class Rund < Formula
  version "0.0.2"
  url "https://github.com/macOScontainers/rund/archive/refs/tags/#{version}.zip"
  sha256 "e2d2cc0ce4144dcf8112640651e02da09bf1a89e1ca62b1fc208642c219aa279"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
