class Rund < Formula
  version "0.0.5"
  url "https://github.com/macOScontainers/rund/archive/refs/tags/#{version}.zip"
  sha256 "1a60cc12eb56feae36a3d68fe9a6fa4b877b4577e68b93e88ba0ebfb643ddd4a"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd/containerd-shim-rund-v1.go"
    bin.install "bin/containerd-shim-rund-v1" => "containerd-shim-rund-v1"
  end
end
