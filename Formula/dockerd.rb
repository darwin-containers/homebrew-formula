class Dockerd < Formula
  version "0.0.11"
  url "https://github.com/darwin-containers/moby/archive/refs/tags/#{version}.zip"
  sha256 "12c077cf0a74c51f2b9cce0924206a80464bdc5040193ed87c38600f77b7498e"

  depends_on "go" => :build

  depends_on "darwin-containers/formula/bindfs"
  depends_on "darwin-containers/formula/containerd"
  depends_on "darwin-containers/formula/rund"

  def install
    system "go", "build", "-o", "bin/", "./cmd/dockerd"

    (buildpath/"daemon.json").write <<~EOS
      {
        "data-root": "/private/d/",
        "features": {
          "containerd-snapshotter": false
        },
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
