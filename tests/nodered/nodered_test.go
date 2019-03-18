package test

import (
	"encoding/json"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func validateNodeRedVersion(status int, body string) bool {
	var result map[string]interface{}
	json.Unmarshal([]byte(body), &result)
	version := result["version"]

	return status == 200 && version == "0.20.2"
}

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestHttpNodeRed(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to nodered terraform
		TerraformDir: "../../apps/nodered",

		NoColor: true,
	}

	// Run `terraform destroy` after resources are created
	defer terraform.Destroy(t, terraformOptions)

	// Rrun `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	instanceURL := terraform.Output(t, terraformOptions, "nodered_settings_url")

	maxRetries := 30
	timeBetweenRetries := 2 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(t, instanceURL, maxRetries, timeBetweenRetries, validateNodeRedVersion)
}