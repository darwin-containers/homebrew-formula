class MacFuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_mac_fuse_installed? }

  def self.binary_mac_fuse_installed?
    File.exist?("/usr/local/include/fuse/fuse.h") &&
      !File.symlink?("/usr/local/include/fuse")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_LIBRARY/"Homebrew/os/mac/pkgconfig/fuse"

    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      ENV.append_path "HOMEBREW_LIBRARY_PATHS", "/usr/local/lib"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", "/usr/local/include/fuse"
    end
  end

  def message
    "macFUSE is required. Please run `brew install --cask macfuse` first."
  end
end

# TODO: This should be a cask so we can properly depend on macFUSE
class Bindfs < Formula
  version "1.17.7"
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-#{version}.tar.gz"
  sha256 "c0b060e94c3a231a1d4aa0bcf266ff189981a4ef38e42fbe23296a7d81719b7a"
  license "GPL-2.0-or-later"

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  on_macos do
    depends_on MacFuseRequirement => :build
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    args = %W[
        --disable-debug
        --disable-dependency-tracking
        --with-fuse2
        --disable-macos-fs-link
        --prefix=#{prefix}
      ]

    if build.head?
      system "./autogen.sh", *args
    end
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
