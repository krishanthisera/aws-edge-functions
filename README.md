# AWS Edge Functions - Terraform Sub-Module

This repository serves as a Terraform sub-module designed for use with the AWS Static Hosting module. The primary purpose of this module is to deploy a set of Lambda@Edge functions that provide prerender integration for CloudFront. This enables faster page loading and improved search engine indexing for Single Page Applications (SPAs) and other dynamic web applications.

## Usage

To use this module in your Terraform configuration, simply add the following code:

```hcl
module "edge-functions" {
  source = "github.com/krishanthisera/aws-edge-functions.git"
}
```

After adding the module, run `terraform init`` to initialize your configuration.

## Technologies Used

This module is built using the following technologies and tools:

- Terraform: Infrastructure as Code (IaC) tool used to manage AWS resources.
- TypeScript: Language used to write the Lambda@Edge functions.
- turbo-repo: A tool used for repository management and monorepo setups.
- esbuild: Used to bundle the TypeScript code and set environment variables during the build process.
- Docker: A Dockerfile is provided to facilitate usage with Spacelift runner.

## How to Use as a Terraform Module

To use this repository as a Terraform module, you can refer to the example provided in the [AWS Static Hosting repository](https://github.com/krishanthisera/aws-static-hosting/tree/main). It showcases how to integrate this module to enable prerendering with CloudFront.

## Prerender Integration

The deployed Lambda@Edge functions work in conjunction with CloudFront to perform prerendering. This means that when a request is made to CloudFront for a page of your SPA (from a crawler), the Lambda@Edge functions will leverage prerender service to generate a prerendered version of the page and serve it to the user. This leads to improved page loading times and better SEO performance.

## Handling Environment Variables

As you are not able to set environment variables at runtime for the Lambda@Edge functions, during the build process, esbuild is used to configure the necessary environment variables and bundle them into the build artifacts.

## How to Contribute

Contributions to this project are welcome! If you have any bug reports, feature requests, or improvements to suggest, you can do so by creating a pull request or opening an issue. Your feedback is highly valuable to us, and we appreciate any contributions made to enhance this module.

## Contact

If you have any questions or need further assistance, you can contact the project maintainer by creating an issue in this repository.
