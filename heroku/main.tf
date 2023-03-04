terraform {
  required_providers {
     heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
     herokux = {
      source = "davidji99/herokux"
     }
  }
}

resource "heroku_app" "mnh_backend_prod" {
  name   = "my-new-homie-backend"
  region = "eu"
  buildpacks = [
    "heroku/gradle",
  ]
  stack           = "heroku-22"
}

resource "heroku_config" "mnh_backend_prod_config" {
    vars = {
      SPRING_PROFILE = "prod"
      test = "test"
    }
}

resource "heroku_app_config_association" "mnh_backend_prod_config_association" {
  app_id = heroku_app.mnh_backend_prod.id

  vars = heroku_config.mnh_backend_prod_config.vars
}

resource "heroku_app" "mnh_backend_dev" {
	name = "my-new-homie-backend-dev"  
	region="eu"

  config_vars = {
    SPRING_PROFILE = "prod"
  }
}



# resource "heroku_formation" "mnh_backend_prod_formation" {
#   app_id     = heroku_app.mnh_backend_prod.id
#   type       = "web"
#   quantity   = 1
#   size       = "Basic"
#     depends_on = [ heroku_build.mnh_backend_prod_build ]
# }


resource "heroku_addon" "mnh_prod_database" {
  app_id = heroku_app.mnh_backend_prod.id
  plan   = "heroku-postgresql:mini"
}


resource "heroku_addon" "mnh_dev_database" {
  app_id = heroku_app.mnh_backend_dev.id
  plan   = "heroku-postgresql:mini"
}

# Create a Heroku pipeline
resource "heroku_pipeline" "mnh_backend_pipeline" {
  name = "my-new-homie-backend-pipeline"

  # owner {
  #     id   = "f85fd1e2-7aa9-48e6-a426-f7fec8681cc8" # $(heroku authorizations)
  #     type = "user"
  # }
}

resource "heroku_pipeline_coupling" "dev" {
  app_id   = heroku_app.mnh_backend_dev.id
  pipeline = heroku_pipeline.mnh_backend_pipeline.id
  stage    = "development"
}

resource "heroku_pipeline_coupling" "prod" {
  app_id   = heroku_app.mnh_backend_prod.id
  pipeline = heroku_pipeline.mnh_backend_pipeline.id
  stage    = "production"
}

// Add the GitHub repository integration with the pipeline.
resource "herokux_pipeline_github_integration" "foobar" {
  pipeline_id = heroku_pipeline.mnh_backend_pipeline.id
  org_repo = "daszkiewiczk/MyNewHomie-backend"
}

// Add Heroku app GitHub integration.
resource "herokux_app_github_integration" "foobar" {
  app_id = heroku_app.mnh_backend_prod.id
  branch = "main"
  auto_deploy = true
  # wait_for_ci = true

  # Tells Terraform that this resource must be created/updated
  # only after the `herokux_pipeline_github_integration` has been successfully applied.
  depends_on = [herokux_pipeline_github_integration.foobar,
                heroku_app.mnh_backend_prod]

}
resource "herokux_app_github_integration" "foobar2" {
  app_id = heroku_app.mnh_backend_dev.id
  branch = "dev"
  auto_deploy = true
  # wait_for_ci = true

  # Tells Terraform that this resource must be created/updated
  # only after the `herokux_pipeline_github_integration` has been successfully applied.
  depends_on = [herokux_pipeline_github_integration.foobar,
  heroku_app.mnh_backend_prod]
}

resource "heroku_app" "mnh_frontend_prod" {
	name="mynewhomie"
	region="eu"
}




resource "heroku_config" "mnh_frontend_prod_config" {
    vars = {
      REACT_APP_API_URL = "https://${heroku_app.mnh_backend_prod.name}.herokuapp.com"
      test = "test"
    }
}

resource "heroku_app_config_association" "mnh_frontend_prod_config_association" {
  app_id = heroku_app.mnh_frontend_prod.id

  vars = heroku_config.mnh_frontend_prod_config.vars
}

resource "heroku_pipeline" "mnh_frontend_pipeline" {
  name = "my-new-homie-frontend-pipeline"

  # owner {
  #     id   = "f85fd1e2-7aa9-48e6-a426-f7fec8681cc8" # $(heroku authorizations)
  #     type = "user"
  # }
}


resource "heroku_pipeline_coupling" "frontend-prod" {
  app_id   = heroku_app.mnh_frontend_prod.id
  pipeline = heroku_pipeline.mnh_frontend_pipeline.id
  stage    = "production"
}
// Add the GitHub repository integration with the pipeline.
resource "herokux_pipeline_github_integration" "foobar2" {
  pipeline_id = heroku_pipeline.mnh_frontend_pipeline.id
  org_repo = "daszkiewiczk/MyNewHomie-frontend"
}

resource "herokux_app_github_integration" "foobar3" {
  app_id = heroku_app.mnh_frontend_prod.id
  branch = "main"
  auto_deploy = true
  # wait_for_ci = true

  # Tells Terraform that this resource must be created/updated
  # only after the `herokux_pipeline_github_integration` has been successfully applied.
  depends_on = [herokux_pipeline_github_integration.foobar2,
                heroku_app.mnh_frontend_prod]

}