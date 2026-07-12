class Buildkitd < Formula
  version "0.0.14"
  url "https://github.com/darwin-containers/buildkit/archive/refs/tags/#{version}.zip"
  sha256 "73dae717beaa375ea389973c60dd995cbfddcd2b112fe9125edc96af740f3af7"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/", "./cmd..."

    (buildpath/"buildkitd.toml").write <<~EOS
      [worker.containerd.runtime]
      name = "io.containerd.rund.v1"
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
