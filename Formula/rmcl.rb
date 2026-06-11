class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.1/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "a732a437c3aedfd98572480cadace4460a4ceeb2e01c147eb1dfb359f78c13f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.1/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "7ea13cc23eec1c78f9dab40b990474c04fb7ea4b2d416e5cd2b913f1a06a0711"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.1/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae9fb30dc285f4a9bce4da48702d63f73fca548e8e9592f6aa5f4462cba146fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.1/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "556231121a32ad0da9d37f655b10eb80f64db815f25bbbac9c797139fa11b58a"
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
