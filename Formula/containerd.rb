class Containerd < Formula
  version "0.0.1"
  url "https://github.com/macOScontainers/containerd/archive/refs/tags/#{version}.zip"
  sha256 "3e6139c3aad66f8b85d3f1fdd789ba1f8ba4ebe893da003a0131f20b1a7b7c79"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd..."
    bin.install "bin/containerd" => "containerd"
    bin.install "bin/ctr" => "ctr"
  end

  service do
    run [bin/"containerd"]
    require_root true
    keep_alive always: true
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Start containerd service with:
      sudo brew services start containerd
    EOS
  end
end
