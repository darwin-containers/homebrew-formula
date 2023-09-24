class MacosContainers < Formula
  version "0.0.1"
  depends_on "docker"
  depends_on "docker-buildx"
  depends_on "macOScontainers/formula/bindfs"
  depends_on "macOScontainers/formula/containerd"
  depends_on "macOScontainers/formula/rund"

  # Not actually needed for Docker
  # depends_on "macOScontainers/homebrew/buildkitd"
end
