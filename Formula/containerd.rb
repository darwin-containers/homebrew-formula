class Containerd < Formula
  version "0.0.6"
  url "https://github.com/darwin-containers/containerd/archive/refs/tags/#{version}.zip"
  sha256 "c5f47ac6bccc17ddaa57bea9ecc3f6c0c5debb9be7e7bf3ea26e29024ebb5b5c"

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
