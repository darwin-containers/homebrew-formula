class Dockerd < Formula
  version "0.0.8"
  url "https://github.com/darwin-containers/moby/archive/refs/tags/#{version}.zip"
  sha256 "34f84760f9854b53ebbba7c490ac6226b82072b4c03f4bd5c1fff293b9c7b0f2"

  depends_on "go" => :build

  depends_on "darwin-containers/formula/bindfs"
  depends_on "darwin-containers/formula/containerd"
  depends_on "darwin-containers/formula/rund"

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
