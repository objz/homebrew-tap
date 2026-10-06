class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.6.0/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "e7ed33b0eaba423cf64e1e2bdf6729f241b4d63e434da09cbff68c50ec8f9801"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.6.0/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "31df4a6e995a42075f946afff2f57a38bbeae55d993a30849e1d0bbb0e80dec4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.6.0/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "108ba02bb63d5c9eef61e0b6e6fd11e2a2f66d5005686176ab290145115c6816"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.6.0/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dfc67582d3c732007f378c82fa8f628546e22126a9fd4fc5c67fbe0edef971af"
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
