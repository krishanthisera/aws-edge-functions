resource "null_resource" "check_node_version" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "node --version"
    working_dir = "${path.module}/${var.edge_function_path}"

    interpreter = ["bash", "-c"]

    on_failure = fail
  }
}

resource "null_resource" "build_edge_functions" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "npm ci && npm run build"
    working_dir = "${path.module}/${var.edge_function_path}"

    interpreter = ["bash", "-c"]

    on_failure = fail
  }

  depends_on = [null_resource.check_node_version]

}

