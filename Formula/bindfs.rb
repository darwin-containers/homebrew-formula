class MacFuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_mac_fuse_installed? }

  def self.binary_mac_fuse_installed?
    File.exist?("/usr/local/include/fuse/fuse.h") or File.exist?("/usr/local/include/fuse3/fuse.h")
  end

  env do
    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      ENV.append_path "HOMEBREW_LIBRARY_PATHS", "/usr/local/lib"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", "/usr/local/include/fuse3"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", "/usr/local/include/fuse"
      ENV.append_path "PKG_CONFIG_PATH", "/usr/local/lib/pkgconfig"
    end
  end

  def message
    "macFUSE is required. Please run `brew install --cask macfuse` first."
  end
end

# TODO: This should be a cask so we can properly depend on macFUSE
class Bindfs < Formula
  version "1.18.4"
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-#{version}.tar.gz"
  sha256 "3266d0aab787a9328bbb0ed561a371e19f1ff077273e6684ca92a90fedb2fe24"
  license "GPL-2.0-or-later"

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  on_macos do
    depends_on MacFuseRequirement => :build
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    args = %W[
        --disable-macos-fs-link
        --prefix=#{prefix}
      ]

    if build.head?
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
