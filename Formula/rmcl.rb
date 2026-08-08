class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.4.0/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "2933251c1c0f4bc9e4bb8ab79c3986e307fd9c78a1a6484f213885d44b049faa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.4.0/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "a1dc7f1f4e67b5b49114562f8d68064d8060012f86a87841ff444eb6a61a6e8a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.4.0/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6354fda2be6957612324fde90683f541472a6e103cdd99b987afad93d93fc0e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.4.0/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c9d697e687964692f66b2b5366113220eb4eef6999f6b9f029070f960b374e5c"
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
