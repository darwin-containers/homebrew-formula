class Buildkitd < Formula
  version "0.0.13"
  url "https://github.com/darwin-containers/buildkit/archive/refs/tags/#{version}.zip"
  sha256 "b9d84f652c7bafecabfe5e14ac7083e9b139c154f70dbf4b96f1c3dce0a38d39"

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
