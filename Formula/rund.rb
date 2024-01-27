class Rund < Formula
  version "0.0.7"
  url "https://github.com/macOScontainers/rund/archive/refs/tags/#{version}.zip"
  sha256 "a728d26f444042b8a70c8c6891ba68cfa90ebf289f8e9942e927ee04e76de793"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
