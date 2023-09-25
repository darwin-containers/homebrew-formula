class Buildkitd < Formula
  version "0.0.1"
  url "https://github.com/macOScontainers/buildkit/archive/refs/tags/#{version}.zip"
  sha256 "f455b9a5da5a192e10f64362cb4569c4a986d775443cd013ae2f479d69c641db"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd..."

    (buildpath/"buildkitd.toml").write <<~EOS
      [worker.containerd]
      runtime = "io.containerd.rund.v1"
    EOS

    bin.install "bin/buildkitd" => "buildkitd"
    bin.install "bin/buildctl" => "buildctl"
    (etc/"buildkit").mkpath
    etc.install buildpath/"buildkitd.toml" => "buildkit/buildkitd.toml"
  end

  service do
    run [bin/"buildkitd", "--config", etc/"buildkit/buildkitd.toml"]
    require_root true
    keep_alive always: true
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      Start BuildKit daemon with:
      sudo brew services start buildkitd
    EOS
  end
end
