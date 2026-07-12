class Containerd < Formula
  version "0.0.13"
  url "https://github.com/darwin-containers/containerd/archive/refs/tags/#{version}.zip"
  sha256 "d403581d1a4dda907a565f1a09019984fbd4292b286d2986740c516e44f1d0c9"

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
