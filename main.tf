locals {
  edge_functions = [
    {
      name = "prerender"
      path = "edge-functions/packages/prerender/build/index.js"
      handler = "index.handler"
    },
    {
      name = "prerender-check"
      path = "edge-functions/packages/prerender-check/build/index.js"
      handler = "index.handler"
    },
    {
      name = "error-response"
      path = "edge-functions/packages/error-response/build/index.js"
      handler = "index.handler"
    },
    {
      name = "cache-control"
      path = "edge-functions/packages/cache-control/build/index.js"
      handler = "index.handler"
    }
  ]
}

data "archive_file" "edge_function_archives" {
  count       = length(local.edge_functions)
  type        = "zip"
  source_file = local.edge_functions[count.index].path
  output_path =  "function_archives/${local.edge_functions[count.index].name}.zip"

  depends_on = [ null_resource.build_edge_functions ]
}

resource "aws_lambda_function" "edge_functions" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  count         = length(local.edge_functions)
  filename      = "function_archives/${local.edge_functions[count.index].name}.zip"
  function_name = "${local.edge_functions[count.index].name}_function"
  handler       = local.edge_functions[count.index].handler
  publish       = true
  memory_size   = 128
  role          = aws_iam_role.lambda_edge_exec.arn


  source_code_hash = data.archive_file.edge_function_archives[count.index].output_base64sha256

  runtime = "nodejs16.x"

}

resource "aws_iam_role" "lambda_edge_exec" {
  assume_role_policy = data.aws_iam_policy_document.lambda_edge_assume_role_policy.json
}
