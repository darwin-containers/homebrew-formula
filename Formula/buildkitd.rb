class Buildkitd < Formula
  version "0.0.1"
  url "https://github.com/macOScontainers/buildkit/archive/refs/tags/#{version}.zip"
  sha256 "f455b9a5da5a192e10f64362cb4569c4a986d775443cd013ae2f479d69c641db"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd..."
    bin.install "bin/buildkitd" => "buildkitd"
    bin.install "bin/buildctl" => "buildctl"
  end

  service do
    run [bin/"buildkitd"]
    require_root true
    keep_alive always: true
    working_dir HOMEBREW_PREFIX
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Enable macOS containers support by creating /etc/buildkit/buildkitd.toml:

      [worker.containerd]
      runtime = "io.containerd.rund.v1"

      Then, start BuildKit daemon with:

      sudo brew services start buildkitd
    EOS
  end
end
