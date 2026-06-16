class Rmcl < Formula
  desc "A fully featured Minecraft TUI launcher"
  homepage "https://github.com/objz/rmcl"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.2/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "18f11d383bd0cffe31cb768538b4cfaf76cc67e11210fac7e618e5f7c627024b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.2/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "0d54c3c6df8cf0f56f46f89c62b466c6938c7dda76b9d9eb111c4fb8dbf68345"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.2/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1db8d7d9f3132469a82fb98eff1881df448df6498315c06a0d1b6f755fb35372"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.2/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e52f5eb4c7e486d0f9b794c4e3863b3766243c9284593ba47fd4e5df2af19ae7"
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
