variable "ml_tasks_list" {
  type = map(object({
    STEP = string
    DEPENDED_TASK = string
    PARAMETERS = map(string)
    NOTEBOOK_FILE_NAME = string
  }))
  default = {
    task1 = {
      STEP = "EXTRACT"
      DEPENDED_TASK = ""
      PARAMETERS = {
        "catalog" : "test",
        "schema" : "test"
      }
      NOTEBOOK_FILE_NAME =  "feature_extract.py"
    }
     task2 = {
      STEP = "TRANSFORM"
      DEPENDED_TASK = "EXTRACT"
      PARAMETERS = {
        "catalog" : "test",
        "schema" : "test"
      }
      NOTEBOOK_FILE_NAME =  "feature_extract.py"
    }
  }
}

variable "workflow_schedule" {
  type = string
  default = "* * * * *"
  }

variable "pause_schedule"{
  type = bool
  default = false
}

variable "timezone" {
  type =  string
  default = "Australia/Sydney"
}

