# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# [1.2.0] - 2924-06-25
### Added
- [GRD-797](https://jira.oicr.on.ca/browse/GRD-797) - Add vidarr labels to outputs (changes to medata only)

# [1.1.0] - 2023-07-04
### Changed
- Moved assembly-specific code in olive to wdl.

# [1.0.3] - 2022-08-31
### Added
- Added `wgsmetrics_call_ready_by_tumor_group` workflow for clinical.
- Added engineArguments to vidarrtest-regression.json.in

### Fixed
- [https://jira.oicr.on.ca/browse/GP-2892](GP-2892) Making Regression Tests more robusts by adding md5sum checks to replace line counts.

# [1.0.2] - 2020-05-31
### Changed
- Migrate to Vidarr
