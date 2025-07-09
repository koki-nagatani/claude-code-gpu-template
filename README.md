# claude-code-gpu-template
Claude CLIをGPUリソースを含めたDockerコンテナで動かすためのテンプレート。

## Base
* Docker Image: `nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04`
* Tools：rye, git, nodejs, npm, Github CLI
* User：ubuntu
* Volume： workディレクトリを/home/ubuntu/workに紐づけてマウント

DockerImageはお使いの環境に合わせて変更してください。

## Usage
### ビルド
```
docker compose up -d --build
```

### 環境へのアクセス
```
docker compose exec claude-code-gpu bash
```

### コンテナ内のclaude CLIを実行
```
docker compose exec claude-code-gpu claude
```
