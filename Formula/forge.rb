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
      url "https://github.com/reliant-labs/forge/releases/download/v1.10.0/forge_darwin_arm64.tar.gz"
      sha256 "3c4f3ef21a8d624568f0fa984d9546deecd0354854dfd953f45fc8628e3692ab"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.10.0/forge_darwin_amd64.tar.gz"
      sha256 "6c2659845ed6e63d469bf19bb8c018e0af1d8361b0c92d1446669af862c9bb7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.10.0/forge_linux_arm64.tar.gz"
      sha256 "cc3ed9a63682593c6b3ab62d03bbdf536e6e04397aa1f5e2614e076ca5b5df50"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.10.0/forge_linux_amd64.tar.gz"
      sha256 "70b413ae73d759d3d4a33d04e6d11428c9bcd89af55bd4775d356ad54c4879ba"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
