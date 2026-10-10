class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.6.2/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "1322cd41657ea161c13c52370a9e5c679f8effef1603f241213211932727a091"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.6.2/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "abf9199df674e21c3b2327f8ff76d3a107546ba082439868a5d30afb7439f6b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.6.2/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a79c7a04ce019c5f722e3ad1ef5d9d9fa1720743998f063cf30942c22765e478"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.6.2/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95cdafc71dc482c22befe800af6f1b61ecc3f5426ec7a5b32a500df874e154f6"
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
