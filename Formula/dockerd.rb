class Dockerd < Formula
  version "0.0.1"
  url "https://github.com/macOScontainers/moby/archive/refs/tags/#{version}.zip"
  sha256 "59ff5408607122f43b040851e65e131e4ad48a4f3228531b6d0f2163707ed7fd"

  depends_on "go" => :build

  def install
    system "cp", "vendor.mod", "go.mod"
    system "cp", "vendor.sum", "go.sum"
    system "go", "build", "-o", "bin/", "./cmd/dockerd"
    bin.install "bin/dockerd" => "dockerd"
  end

  service do
    run [bin/"dockerd"]
    require_root true
    keep_alive always: true
    working_dir HOMEBREW_PREFIX
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Enable macOS containers support by creating /etc/docker/daemon.json with the following contents:
  
      {
        "data-root": "/private/d/",
        "default-runtime": "io.containerd.rund.v1",
        "runtimes": {
          "io.containerd.rund.v1": {
            "runtimeType": "io.containerd.rund.v1"
          }
        }
      }

      Then, start docker daemon with:
      sudo brew services start dockerd

      Enable BuildKit support with:
      mkdir -p ~/.docker/cli-plugins; ln -sfn /opt/homebrew/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end
end
