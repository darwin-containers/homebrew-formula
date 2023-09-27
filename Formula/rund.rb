class Rund < Formula
  version "0.0.3"
  url "https://github.com/macOScontainers/rund/archive/refs/tags/#{version}.zip"
  sha256 "8e21ba3bc071442e09fc56a6bcc5ed9d10b8f139590fd8866033950cc39fbeed"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
