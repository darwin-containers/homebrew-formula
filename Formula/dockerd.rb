class Dockerd < Formula
  version "0.0.2"
  url "https://github.com/macOScontainers/moby/archive/refs/tags/#{version}.zip"
  sha256 "cdd9858d98528f98d3081bb6c534d3c5bf50aec1c45cb2b09373503f357ed437"

  depends_on "go" => :build

  def install
    system "cp", "vendor.mod", "go.mod"
    system "cp", "vendor.sum", "go.sum"
    system "go", "build", "-o", "bin/", "./cmd/dockerd"

    (buildpath/"daemon.json").write <<~EOS
      {
        "data-root": "/private/d/",
        "default-runtime": "io.containerd.rund.v1",
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
    keep_alive always: true
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Start Docker service with:
      sudo brew services start dockerd
    EOS
  end
end
