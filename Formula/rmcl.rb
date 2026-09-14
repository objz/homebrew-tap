class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.5.0/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "32e80a8e932642a1a3a453379b4162ca291c464cbebbc36e8402112fe0fd6763"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.5.0/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "29aabb5f6458fd5df0b65381203c7b0b1a3f2c2761a3cedab48f2c9b702208ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.5.0/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b672c37ebcfec3be96e7b38016e21231475770171a9e2f65c0d5436dadf33d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.5.0/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0ed6405507855fd68f24e7ab01704d637639f2d25fb3d40fb0260bfd2ce1c349"
    end
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rmcl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rmcl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rmcl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rmcl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
