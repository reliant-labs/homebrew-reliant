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
      url "https://github.com/reliant-labs/forge/releases/download/v1.13.0/forge_darwin_arm64.tar.gz"
      sha256 "506445a0975e1bbb7216097ee7f0e209822078d996ee69d3cd4c2510c90e660e"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.13.0/forge_darwin_amd64.tar.gz"
      sha256 "21850615121c11c066614bdccb24bdb1611d839ef80d976428fe6f61645d9c6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.13.0/forge_linux_arm64.tar.gz"
      sha256 "7a629ae8db9a5052cb94c6517b4ff411025921f9b6f671778feb695536c1edea"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.13.0/forge_linux_amd64.tar.gz"
      sha256 "d78ae0830822161f99c729b9c519f51cab3e5cbb40ea8a4b74c47991a7e60f05"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
