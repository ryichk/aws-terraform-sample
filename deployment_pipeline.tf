resource "aws_codebuild_project" "example" {
  name = "example"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:2.0"
    privileged_mode = true
  }
}

resource "aws_codepipeline" "example" {
  name = "example"
  role_arn = module.codepipeline_role.iam_role_arn

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = 1
      output_artifacts = ["Source"]

      configuration = {
        Owner = "ryichk"
        Repo = "cafe-shares-web-front"
        Branch = "main"
        OAuthToken = aws_ssm_parameter.github_personal_access_token.value
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = 1
      input_artifacts = ["Source"]
      output_artifacts = ["Build"]

      configuration = {
        ProjectName = aws_codebuild_project.example.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      version = 1
      input_artifacts = ["Build"]

      configuration = {
        ClusterName = aws_ecs_cluster.example.name
        ServiceName = aws_ecs_service.example.name
        FileName = "imagedefinitions.json"
      }
    }
  }
  artifact_store {
    location = aws_s3_bucket.artifact.id
    type = "S3"
  }
}

resource "aws_codepipeline_webhook" "example" {
  name = "example"
  target_pipeline = aws_codepipeline.example.name
  target_action = "Source"
  authentication = "GITHUB_HMAC"

  authentication_configuration {
    secret_token = "VeryRandomStringMore20Byte"
  }

  filter {
    json_path = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

provider "github" {
  organization = "ryichk"
}

resource "github_repository_webhook" "example" {
  repository = "cafe-shares-web-front"

  configuration {
    url = aws_codepipeline_webhook.example.url
    secret = "VeryRandomStringMoreThan20Byte"
    content_type = "json"
    insecure_ssl = false
  }

  events = ["push"]
}
