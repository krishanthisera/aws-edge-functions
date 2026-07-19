resource "null_resource" "check_node_version" {

  triggers = {
    package_json = filesha256("${path.module}/${var.edge_function_path}/package.json")
  }

  provisioner "local-exec" {
    command     = "npx yarn version  --non-interactive"
    working_dir = "${path.module}/${var.edge_function_path}"

    interpreter = ["bash", "-c"]

    on_failure = fail
  }
}

resource "null_resource" "build_edge_functions" {

  triggers = {
    source_hash = sha1(join("", [
      for f in sort(fileset("${path.module}/${var.edge_function_path}/packages", "*/src/*.ts")) :
      filesha256("${path.module}/${var.edge_function_path}/packages/${f}")
    ]))
  }

  provisioner "local-exec" {
    command     = "npx yarn install  --non-interactive && npx yarn build"
    working_dir = "${path.module}/${var.edge_function_path}"

    interpreter = ["bash", "-c"]

    on_failure = fail
  }

  depends_on = [null_resource.check_node_version]

}

