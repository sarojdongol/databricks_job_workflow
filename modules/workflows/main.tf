
data "databricks_current_user" "me" {}
data "databricks_spark_version" "latest" {}
data "databricks_node_type" "smallest" {
  local_disk = true
}

resource "databricks_notebook" "this" {
  path     = "${data.databricks_current_user.me.home}/Terraform"
  language = "PYTHON"
  content_base64 = base64encode(<<-EOT
    # created from ${abspath(path.module)}
    display(spark.range(10))
    EOT
  )
}


resource "databricks_job" "this" {
  name = "ml-x01-workflow"

  job_cluster {
    job_cluster_key = "j"
    new_cluster {
      num_workers   = 2
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }
  }
  schedule{
        quartz_cron_expression = var.workflow_schedule
        timezone_id            = var.timezone
        pause_status           = var.pause_schedule ? "PAUSED" : "UNPAUSED"
      }

  dynamic "task" {
    for_each = var.ml_tasks_list
    content {
    task_key = task.value.STEP
    notebook_task {
      notebook_path = "/sdongol/notebooks/${task.value.NOTEBOOK_FILE_NAME}"
      base_parameters = task.value.PARAMETERS != {} ? task.value.PARAMETERS : null
    } 
    dynamic "depends_on" {
      for_each = task.value.DEPENDED_TASK != "" ? [1] : []
      content {
          task_key = task.value.DEPENDED_TASK
      }
      }
  job_cluster_key = "j"
  }
}
}