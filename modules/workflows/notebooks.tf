resource "databricks_notebook" "pipeline_file" {
    for_each = fileset("${path.root}/projects/demo/notebooks","*")
    source = "${path.root}/projects/demo/notebooks/${each.value}"
    path = "/sdongol/notebooks/${each.value}"
    language = "PYTHON"
}