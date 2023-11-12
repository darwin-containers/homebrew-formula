class Containerd < Formula
  version "0.0.2"
  url "https://github.com/macOScontainers/containerd/archive/refs/tags/#{version}.zip"
  sha256 "1bc5ac84972d06bc1b309bee31701a4f8785331a97583573862dcb8bc1c32280"

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
