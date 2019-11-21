version 1.0

workflow wgsMetrics {
  input {
    File inputBam
    String? outputFileNamePrefix = basename(inputBam, '.bam')
  }

  call collectWGSmetrics {
    input:
      inputBam = inputBam,
      outputPrefix = outputFileNamePrefix
  }

  output {
    File outputWGSMetrics  = collectWGSmetrics.outputWGSMetrics
  }

  meta {
    author: "Peter Ruzanov"
    email: "peter.ruzanov@oicr.on.ca"
    description: "WGSMetrics 1.0"
  }
}

# ==========================================
#  TASK 1 of 1: collect WGS metric
# ==========================================
task collectWGSmetrics {
  input {
    File inputBam
    String? picardJar = "$PICARD_ROOT/picard.jar"
    String? refFasta = "$HG19_ROOT/hg19_random.fa"
    String? metricTag = "WGS"
    String? filter = "LENIENT"
    String? outputPrefix = "OUTPUT"
    Int? jobMemory = 18
    Int? coverageCap = 500
    String? modules = "picard/2.21.2 hg19/p13"
  }

  parameter_meta {
    picardJar: "Picard jar file to use"
    inputBam: "Input file (bam or sam)"
    refFasta: "Path to the reference fasta"
    metricTag: "metric tag is used as a file extension for output"
    filter: "Picard filter to use"
    outputPrefix: "Output prefix, either input file basename or custom string"
    jobMemory: "memory allocated for Job"
    coverageCap: "Coverage cap, picard parameter"
    modules: "Environment module names and version to load (space separated) before command execution"
  }

  meta {
    output_meta : {
      outputWGSMetrics: "Metrics about the fractions of reads that pass base and mapping-quality filters as well as coverage (read-depth) levels (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#CollectWgsMetrics.WgsMetrics)"
    }
  }

  command <<<
    java -Xmx~{jobMemory-6}G -jar ~{picardJar} \
    CollectWgsMetrics \
    TMP_DIR=picardTmp \
    R=~{refFasta} \
    COVERAGE_CAP=~{coverageCap} \
    INPUT=~{inputBam} \
    OUTPUT="~{outputPrefix}.~{metricTag}.txt" \
    VALIDATION_STRINGENCY=~{filter}
  >>>

  runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
  }

  output {
    File outputWGSMetrics = "~{outputPrefix}.~{metricTag}.txt"
  }
}
