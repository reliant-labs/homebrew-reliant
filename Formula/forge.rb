class Forge < Formula
  desc "Production-ready Go + Connect RPC + Postgres + Next.js project framework"
  homepage "https://github.com/reliant-labs/forge"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.8.0/forge_darwin_arm64.tar.gz"
      sha256 "4d9a3e986a67a8b3c10a3e3e658e51a540ee8dcf7217f4f339dae2551b7bf5f2"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.8.0/forge_darwin_amd64.tar.gz"
      sha256 "fefb9e2420b221c2027ee9f237a8f1e4c0cff26e204d16704b5124ac453abd7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.8.0/forge_linux_arm64.tar.gz"
      sha256 "0a78a4f2b74ade5811a67228fe7245cb75a7261f363c315d2bf4949a37e12dfd"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.8.0/forge_linux_amd64.tar.gz"
      sha256 "1b4bb5ad52c0e557c83c4abd30edbf4b6da91a6fede53849165a5de040bad463"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
