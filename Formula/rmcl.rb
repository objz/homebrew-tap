class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.4.1/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "28f48f403e3d55143bd7773b1ad3240ee4f6fa1840aec08f54b2e7a082e926e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.4.1/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "40e0d5b40efa6da2f53a4a5ca0eba59ca53b50b25758f6fb2cc9b126f106cba2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.4.1/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba4310a66bab26d86d74ae7f37ce9c05a61ab2947111a33d3ac5500c09caf606"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.4.1/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8f7ceae3c02980eee51c3efe3fdc148d92203fda0d8081e8343c7d2322a25c1"
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
