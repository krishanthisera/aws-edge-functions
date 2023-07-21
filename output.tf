output "function_arns" {
  value = {
    for func_name, function in aws_lambda_function.edge_functions :
    func_name => function.arn
  }
}
 