class Dockerd < Formula
  version "0.0.3"
  url "https://github.com/macOScontainers/moby/archive/refs/tags/#{version}.zip"
  sha256 "0ad0ff54e6e7cda55e6d381f44f62f94fc8357c45647b25166cb34e1b498d937"

  depends_on "go" => :build

  depends_on "macOScontainers/formula/bindfs"
  depends_on "macOScontainers/formula/containerd"
  depends_on "macOScontainers/formula/rund"

  def install
    system "cp", "vendor.mod", "go.mod"
    system "cp", "vendor.sum", "go.sum"
    system "go", "build", "-o", "bin/", "./cmd/dockerd"

    (buildpath/"daemon.json").write <<~EOS
      {
        "data-root": "/private/d/",
        "default-runtime": "io.containerd.rund.v1",
        "group": "staff",
        "runtimes": {
          "io.containerd.rund.v1": {
            "runtimeType": "io.containerd.rund.v1"
          }
        }
      }
    EOS

    (etc/"docker").mkpath
    etc.install buildpath/"daemon.json" => "docker/daemon.json"
    bin.install "bin/dockerd" => "dockerd"
  end

  service do
    run [bin/"dockerd", "--config-file", etc/"docker/daemon.json"]
    require_root true
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/dockerd.log"
    error_log_path var/"log/dockerd.log"
  end

  def caveats
    <<~EOS
      Start Docker service with:
      sudo brew services start dockerd
    EOS
  end
end
