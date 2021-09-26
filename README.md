# AWS Terraform Sample

## アーキテクチャ

エンドユーザーはHTTPSでWebサービスにアクセスする。

ロードバランサーをパブリックネットワークに配置し、
アプリケーションを動かすコンテナオーケストレーションサービスや、データベースはプライベートネットワークに配置する。

バッチのジョブ管理や暗号化のための鍵管理、アプリケーションの設定管理は全てマネージドサービスで実装し、運用負荷の低減を図る。

デプロイメントパイプラインを構築し、継続的デリバリーを実現する。

運用のためにオペレーションサーバーを構築し、ログの検索と永続化の仕組みを整える。

## テクノロジースタック

- 権限管理：IAMポリシー、IAMロール
- ストレージ：S3
- ネットワーク：VPC、NATゲートウェイ、セキュリティグループ
- ロードバランサーとDNS：ALB、Route53、ACM
- コンテナオーケストレーション：ECS Fargate
- バッチ：ECS Scheduled Tasks
- 鍵管理：KMS
- 設定管理：SSMパラメータストア
- データストア：RDS、ElastiCache
- デプロイメントパイプライン：ECR、CodeBuild、CodePipeline
- SSHレスオペレーション：EC2、Session Manager
- ロギング：CloudWatch Logs、Kinesis Data Firehose

![aws-terraform-sample-technology-stack](https://user-images.githubusercontent.com/26560390/134791181-904bc37e-b6f1-40d2-9aa5-fe81c8d315e5.png)

## 参考

[実践Terraform AWSのおけるシステム設計とベストプラクティス](https://www.amazon.co.jp/dp/B07XT7LJLC/)
