class Buildkitd < Formula
  version "0.0.2"
  url "https://github.com/macOScontainers/buildkit/archive/refs/tags/#{version}.zip"
  sha256 "30bca0971c406a4b189e24b12c760e71e497949fc209b04d7a4427fa147b5a12"

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
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/buildkitd.log"
    error_log_path var/"log/buildkitd.log"
  end

  def caveats
    <<~EOS
      Start BuildKit service with:
      sudo brew services start buildkitd
    EOS
  end
end
