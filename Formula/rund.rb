class Rund < Formula
  version "0.0.13"
  url "https://github.com/darwin-containers/rund/archive/refs/tags/#{version}.zip"
  sha256 "470cd94a45a07bae2d4d3afb89a4b671759c08b739676c7dd7c7b268f1ef5823"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
