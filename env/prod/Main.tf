module "prod" {
    source = "../../infra"

    repository_name = "production"
    cluster_name = "production"
}
