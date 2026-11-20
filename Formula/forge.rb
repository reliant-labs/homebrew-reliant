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
      url "https://github.com/reliant-labs/forge/releases/download/v1.9.0/forge_darwin_arm64.tar.gz"
      sha256 "9a80e991a2405fe5842a451c0502775d58cf0d4bd88c9e339bc83f5c59668c7b"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.9.0/forge_darwin_amd64.tar.gz"
      sha256 "72a44583360e99c27e4cd15486ec3105c73f2a6587266a3b081ce2bcfa348449"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.9.0/forge_linux_arm64.tar.gz"
      sha256 "a7a936b0bda8493d72417835a3c1efe47a2144f78a661dbda9c9c41ffbd075b0"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.9.0/forge_linux_amd64.tar.gz"
      sha256 "f609977b68e6d7822edbd16ae2df9698a82a6cacce029986ae470aec15bfc038"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
