class Rmcl < Formula
  desc "A fully featured Minecraft launcher TUI"
  homepage "https://github.com/objz/rmcl"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.0/rmcl-aarch64-apple-darwin.tar.xz"
      sha256 "67510337358efdb7296f3988122ca07d9ca59ace8113c761f5c370d25abfb384"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.0/rmcl-x86_64-apple-darwin.tar.xz"
      sha256 "ff35cfbe0cfae0cda7cc065c9d696ce706a682a5d9a42d66971e4b41e97b1459"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/objz/rmcl/releases/download/v0.3.0/rmcl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f54b7ff9e0cc5b5bf5f115eeebc5cd24b45116bf038a4692f433b444b30f90e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/objz/rmcl/releases/download/v0.3.0/rmcl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa887af36d02bc5286f98533311b39a6b40ac1d3b30fbc3fc66fd4ac7e0a59cd"
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
