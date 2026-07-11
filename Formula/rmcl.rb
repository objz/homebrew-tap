class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.3/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "5061e6b361514108ace871ecd467417daa32dfa3dbb40cd8d79b0a7a70b57aeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.3/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "533c0eb1847f9196cd4df8a88a020067867d00278ec5f8707951ea1fb8e5e9b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.3/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c40e54beb9d1d0622c0fb332f1f9d110334246e200d86a9b2df6e3d1f363b849"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.3/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b399c48564e1e40788a07e8feb5d0c8c906eb80e3a90e0aa8b7d50b8b2fa3d07"
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
    bin.install "rmcl" if OS.mac? && Hardware::CPU.arm?
    bin.install "rmcl" if OS.mac? && Hardware::CPU.intel?
    bin.install "rmcl" if OS.linux? && Hardware::CPU.arm?
    bin.install "rmcl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
