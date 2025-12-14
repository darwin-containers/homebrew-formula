class Containerd < Formula
  version "0.0.12"
  url "https://github.com/darwin-containers/containerd/archive/refs/tags/#{version}.zip"
  sha256 "e833836d114d559acfbbf9135f3c64fb60324d7061e0cf5e0b2f9ba99a12a90a"

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
