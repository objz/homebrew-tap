class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.5.1/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "1b24e218e1869e68ce2bfc372f08aa425dab04e46bed0e81cd73a434a344e077"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.5.1/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "b6e1b311faedf40c4f3359625e1f5e72f9ec2262609d988e5ce816a388898e61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.5.1/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a39479809fe7fc6e7b6852664db87d3799774cce1545ca7780e4648f0a1b0dca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.5.1/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "796f9a36eeb1e81b3f094a31ea8cbc09b1af2d9774659dc302ed96b9c6d84243"
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
