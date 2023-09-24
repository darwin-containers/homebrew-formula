class MacosContainers < Formula
  version "0.0.1"
  depends_on "docker"
  depends_on "docker-buildx"
  depends_on "macOScontainers/homebrew/bindfs"
  depends_on "macOScontainers/homebrew/containerd"
  depends_on "macOScontainers/homebrew/rund"

  # Not actually needed for Docker
  # depends_on "macOScontainers/homebrew/buildkitd"
end
