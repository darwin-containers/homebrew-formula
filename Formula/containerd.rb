class Containerd < Formula
  version "0.0.3"
  url "https://github.com/darwin-containers/containerd/archive/refs/tags/#{version}.zip"
  sha256 "4583f5c68b146d00c0b9e8373cadc49b0dfacf3df4cd8315fb0d54e708d1187d"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd..."
    bin.install "bin/containerd" => "containerd"
    bin.install "bin/ctr" => "ctr"
  end

  service do
    run [bin/"containerd"]
    require_root true
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/containerd.log"
    error_log_path var/"log/containerd.log"
  end

  def caveats
    <<~EOS
      Start containerd service with:
      sudo brew services start containerd
    EOS
  end
end
