# wgsMetrics

Workflow to run picard WGSMetrics

## Overview

## Dependencies

* [picard 2.21.2](https://broadinstitute.github.io/picard/)


## Usage

### Cromwell
```
java -jar cromwell.jar run wgsMetrics.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputBam`|File|Input file (bam or sam).
`reference`|String|reference genome of inputs sample


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`outputFileNamePrefix`|String|basename(inputBam,'.bam')|Output prefix to prefix output file names with.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`collectWGSmetrics.picardJar`|String|"$PICARD_ROOT/picard.jar"|Picard jar file to use
`collectWGSmetrics.metricTag`|String|"WGS"|metric tag is used as a file extension for output
`collectWGSmetrics.filter`|String|"LENIENT"|Picard filter to use
`collectWGSmetrics.jobMemory`|Int|18|memory allocated for Job
`collectWGSmetrics.coverageCap`|Int|500|Coverage cap, picard parameter
`collectWGSmetrics.timeout`|Int|24|Maximum amount of time (in hours) the task can run for.


### Outputs

Output | Type | Description | Labels
---|---|---|---
`outputWGSMetrics`|File|File with collected metrics|


## Commands
 
 This section lists command(s) run by wgsmetrics workflow
 
 * Running wgsmetrics
 
 A simple wrapper workflow for running picard CollectWgsMetrics.
 
 ```
     java -Xmx[MEMORY]G -jar picard
     CollectWgsMetrics 
     TMP_DIR=picardTmp 
     R=REF_FASTA 
     COVERAGE_CAP=COVERAGE_CAP 
     INPUT=INPUT_BAM 
     OUTPUT=PREFIX.METRICS_TAG.txt" 
     VALIDATION_STRINGENCY=FILTER
 ```
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
