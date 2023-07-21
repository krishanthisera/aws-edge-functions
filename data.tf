# IAM Policy for Lambda assume role
# Lambda Invode permission
data "aws_iam_policy_document" "lambda_edge_assume_role_policy" {
  statement {
    sid       = "LambdaEdgeExecution"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}