# locals  {
#     tasks = ["FEATURE_EXTRACT","FEATURE_TRANSFORM","TRAINING","INFERENCE"]
# }
locals {
    ml_pipeline_params = {
        FEATURE_EXTRACT = {
            STEP = "EXTRACT"
            DEPENDED_TASK = ""
            NOTEBOOK_FILE_NAME = "feature_extract.py"
            PARAMETERS = {
                "CATALOG" : "TEST",
                "SCHEMA" : "SILVER"
            }
            }
        FEATURE_TRANSFORM = {
            STEP = "TRANSFORM"
            DEPENDED_TASK = "EXTRACT"
            NOTEBOOK_FILE_NAME = "feature_extract.py"
            PARAMETERS = {
                "CATALOG" : "TEST",
                "SCHEMA" : "SILVER"
            }
            }
            }
}

module "ml-pipeline-x01" {
    source = "./modules/workflows"
    ml_tasks_list = local.ml_pipeline_params
    workflow_schedule = "0 0 7 * * ?"
    timezone = "Australia/Sydney"
    pause_schedule = false
}