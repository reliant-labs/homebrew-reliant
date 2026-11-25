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
      url "https://github.com/reliant-labs/forge/releases/download/v1.11.0/forge_darwin_arm64.tar.gz"
      sha256 "8a8d97ad9c8011b2776205e0d51bf01b3c5893e540249f21a35dbe77eee919f3"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.11.0/forge_darwin_amd64.tar.gz"
      sha256 "9e12b17b173c0c7e76399686fd1a00bf5c1b061ddbe7004691082dd8c1041d54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.11.0/forge_linux_arm64.tar.gz"
      sha256 "4bd90926a03cf943be5289a4d2e1e8dc2e558f086cba267fbc7680ea23e38f30"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.11.0/forge_linux_amd64.tar.gz"
      sha256 "d100cd39b5c670c7d3f761cd9c8235aabc323353885a2d367caabd97f9cc5a14"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
