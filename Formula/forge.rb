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
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.12/forge_darwin_arm64.tar.gz"
      sha256 "b7f7ec7963b008218023390f06a5ebccb545183f68be92486eb599de7e52aff0"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.12/forge_darwin_amd64.tar.gz"
      sha256 "2b630a88f88e1f7ae251ba834441e5dc940e257f1839ee02bf8ccfa9dad4dadb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.12/forge_linux_arm64.tar.gz"
      sha256 "6111b90bea590f2659971deae053265f808d06fd7ce97003be07479717701553"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.12/forge_linux_amd64.tar.gz"
      sha256 "85e13199837f998fac304b894c0268e0c632d802011b767337a06f636d2197ab"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
