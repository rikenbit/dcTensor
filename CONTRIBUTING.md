## Contributing
Thanks for having the interest of this package.
Your support is wellcome for keeping it great.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

By participating in this project you agree to abide by its terms.

## Issues
Please follow [our guideline](.github/ISSUE_TEMPLATE/bug_report.md) to create an issue.

## PRs
For the details about how to create a pull request (PR), see the official document of [GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

If fixing a bug or adding a new feature to a `dcTensor` function, please add a `testthat` unit test code like `tests/testthat/test_[NEW_FEATURE].R`.

Codes that take too long are commented out in `testthat.R`.
This is because CRAN expects tests to be completed in a short period of time.
If your test code takes more than 1 minute, please comment it out.

Also add a command `test_file("testthat/test_[NEW_FEATURE].R")` in `tests/testthat.R`.

The test code is performed in `Dockerfile` called by `.github/workflows/build_test_push.yml` (GitHub Actions) and you will see whether the test code has been finished without error after your PR. **Please do not leave the PR with errors.**
